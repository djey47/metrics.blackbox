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
    @logger.info("[RedisCache] Starting Redis cache server...")    
    Controller::instance.allThreads << Thread.new {
      result = system("#{Controller::instance.configuration.options.redis_path}")
      if (!result)
        @logger.error("[RedisCache] Could not execute Redis cache server!")    
      end
    }    
    
    # Helper
    @redis = Redis.new
  end
    
end