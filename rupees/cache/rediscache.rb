#rediscache.rb
#To address cache, handled by a Redis server

require 'logger'
require 'redis'

class RedisCache  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    @logger.info("[RedisCache] Initializing...")    
    
    # Binary
    @logger.info("[RedisCache] Starting cache server...")
    
    redisBinary = Controller::instance.configuration.options.redis_path
    raise RuntimeError, "Redis not found at #{redisBinary}." unless File.exists?(redisBinary) 
    redisConf = "#{Controller::instance.configuration.information.conf_directory}/redis.conf"
    raise RuntimeError, "Redis configuration not found at #{redisConf}." unless File.exists?(redisConf) 
        
    @redisPid = 0
    Controller::instance.allThreads << Thread.new {
      @redisPid = Process.spawn("#{redisBinary} #{redisConf}")
      Process.wait(@redisPid)
      
      # Unlikely to get to here... thread should have been killed by controller, already.
      # TODO Controller should not kill attached threads, but ask for shutdown first      
      @logger.info("[RedisCache] Cache server ended with exit status=#{$?.exitstatus}") 
    }    
    
    # Helper
    @redis = Redis.new
  end
  
  def shutdown
    @logger.info("[RedisCache] Terminating cache server as requested (pid=#{@redisPid})...")
    
    begin
      Process.kill("SIGTERM", @redisPid)
    rescue => exception
      @logger.error("[RedisCache] Unable to terminate cache server: #{exception.inspect}")
    end

  end
  
  def store(datas)
    @logger.info("[RedisCache][store] Datas count: #{datas.length}")   
     
    @redis.multi do
      datas.each { |data| @redis.set(data.key, data.value) }
    end
  end  
  
  def retrieve(datas)
    @logger.info("[RedisCache][retrieve] Keys count: #{datas.length}")
    
    rawResults = {}
    @redis.multi do
      datas.each { |data| rawResults[data] = @redis.get(data.key) }
    end
    
    results = rawResults.collect do |data,future|
      DataItem.new(data.appId, data.contextId, data.natureId, future.value)
    end        
    
    @logger.info("[RedisCache][retrieve] Result: #{results}")    
    results
  end
  
  def retrieveByAppId(appId)
    @logger.info("[RedisCache][retrieveByAppId] appId: #{appId}")
    
    keys = @redis.keys("#{appId}|*")
    rawResults = {}
    @redis.multi do
      keys.each { |key| rawResults[key] = @redis.get(key) }
    end
    
    results = rawResults.collect do |key,future|
      DataItem::fromKey(key, future.value)
    end        
    
    @logger.info("[RedisCache][retrieveByAppId] Result: #{results}")
    results  
  end  
end