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
      result = system('/home/avsp/applications/redis-2.6.14/src/redis-server')
      if (result)
        @logger.info("[RedisCache] Redis cache server now started.")    
      else
        @logger.error("[RedisCache] Could not execute Redis cache server!")    
      end
    }    
    
    # Helper
    @redis = Redis.new
  end
    
end