#controller.rb
#Metrics Controller

require 'logger'
require 'singleton'
require_relative 'configuration'
require_relative 'options'
require_relative 'cache/rediscache'
require_relative 'connectors/webservices/webservices-in'


class Controller 
  include Singleton
  include Options

  attr_reader :allThreads
  attr_reader :configuration
  
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
    
    @cache = RedisCache.new    
    
    @wsInConnector = WebservicesInConnector.new    
    
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