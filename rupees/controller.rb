#controller.rb
#Metrics Controller

require 'logger'
require 'singleton'
require_relative 'cache/rediscache'
require_relative 'connectors/webservices/webservices-in'
require_relative 'connectors/webservices/webservices-out'
require_relative 'mediators/collector'
require_relative 'configuration'
require_relative 'controller-access'
require_relative 'options'
# Imports below are required only when necessary
# require_relative 'connectors/sharedmemory/sharedmemory-in'


class Controller 
  include Singleton
  include Options

  attr_reader :allThreads
  attr_reader :configuration
  attr_reader :cache
  
  def initialize               
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    
    @allThreads = []
  end
    
  def run
    @logger.info("[Controller] Reviewing parameters from command line...")
    options = parseParams(ARGV)
    
    @logger.info("[Controller] Booting Metrics controller aka `BlackBox`into #{options[:env]} mode...")
    
    @logger.info("[Controller] Loading configuration...")
    @configuration = Configuration.new(options[:env], options[:configFile])
    
    # Command interface
    @access = ControllerAccess.new
    
    # Cache
    @cache = RedisCache.new    
    
    # Common connectors
    @wsInConnector = WebservicesInConnector.new    
    @wsOutConnector = WebservicesOutConnector.new 

    # Windows-specific connectors
    if (options[:windows])
      @logger.info("[Controller] Activating Windows-specific features...")
      require_relative 'connectors/sharedmemory/sharedmemory-in'
      @smInConnector = SharedMemoryInConnector.new  
    end 
    
    @logger.info("[Controller] Ready to rumble!")
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