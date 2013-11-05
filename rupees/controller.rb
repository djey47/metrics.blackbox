#controller.rb
#Metrics Controller

require 'logger'
require 'singleton'
require_relative 'cache/rediscache'
require_relative 'connectors/file/file-out'
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
    @fileOutConnector = FileOutConnector.new

    # Windows-specific connectors
    if (options[:windows])
      @logger.info("[Controller] Activating Windows-specific features...")
      
      require_relative 'connectors/sharedmemory/sharedmemory-in'
      @smInConnector = SharedMemoryInConnector.new  
    end 
    
    @logger.info("[Controller] Ready to rumble!")
    
    # Waiting for all threads to terminate
    @allThreads.each { |thr| thr.join }    
    
    @logger.info("[Controller] Exiting Metrics controller. Bye!")        
  end
  
  def shutdown
    @logger.info("[Controller] Will shutdown now ! Killing all running threads...")    
    
    @allThreads.each { |thr| Thread.kill thr }
  end  
    
  def startFileLogging(appId)
    @logger.info("[Controller][startFileLogging] appId: #{appId}")
    
    filePath = generateAndCheckFilePath(appId)
    @fileOutConnector.start(filePath, appId)
  end  
  
  def stopFileLogging
    @logger.info("[Controller][stopFileLogging]")    
    
    @fileOutConnector.stop
  end
  
  def generateAndCheckFilePath(key)    
    timestamp = Time.now.strftime("%Y%m%d-%H%M%S")
    filePath = "#{@configuration.information.out_directory}/#{timestamp}-#{key}"

    # Checks whether file can be written on disk or not
    FileUtils.touch(filePath)
    FileUtils.remove_file(filePath)    
    
    filePath
  end    
end

# Boot
Controller.instance.run
# Boot