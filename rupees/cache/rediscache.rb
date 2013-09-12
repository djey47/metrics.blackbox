#rediscache.rb
#To address cache, handled by Redis database

require 'logger'
require 'redis'

class RedisCache
  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    @logger.info("[RedisCache] Initializing...")    
    
    # Binary
    @logger.info("[RedisCache] Starting cache server...")    
    Controller::instance.allThreads << Thread.new {
      result = system("#{Controller::instance.configuration.options.redis_path} #{Controller::instance.configuration.information.conf_directory}/redis.conf")
      if (result.nil?)
        @logger.error("[RedisCache] Cache server has unexpectedly quit: #{$?}!")
        raise RuntimeError, "When running cache server: #{Controller::instance.configuration.options.redis_path}"
      else    
        @logger.info("[RedisCache] Cache server ended normally.")         
      end
    }    
    
    # Helper
    @redis = Redis.new
  end
  
  def store(datas)
    @logger.info("[RedisCache][store] Datas count: #{datas.length}")    
    @redis.multi do
      datas.each { |data| @redis.set(data.key, data.value) }
    end
  end      
end