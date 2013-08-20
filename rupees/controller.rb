#controller.rb
#Metrics Controller

require 'logger'
require 'singleton'
require_relative 'cache/rediscache'

class Controller 
  include Singleton

  attr_reader :allThreads
  
  def initialize               
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    @logger.info("[Controller] Booting Metrics controller aka `BlackBox`...")
    
    @allThreads = []
  end
    
  def run
    @cache = RedisCache.new
    
    # Waiting for all threads to terminate
    allThreads.each { |thr| thr.join }    
  end
  
  def stop
    @logger.info("[Controller] Exiting Metrics controller.")    
  end  
end

# Boot
Controller.instance.run
Controller.instance.stop

