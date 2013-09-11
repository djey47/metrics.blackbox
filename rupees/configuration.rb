#configuration.rb
#Handles Metrics configuration from yaml files

require 'ostruct'
require 'yaml'
require 'logger'

module Environment
  DEVELOPMENT = "DEV"
  PRODUCTION = "PROD"
end

class Configuration
  
  attr_reader :options
  attr_reader :information
  attr_reader :env
  
  def initialize(currentEnv, configFile)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO    
    
    @file = configFile
    @env = currentEnv
    @options = OpenStruct.new
    @information = OpenStruct.new
    
    setInformation(currentEnv)
    parseOptions
  end
  
  def setInformation(env)
    information.env = env
    information.rb_directory = File.expand_path File.dirname(__FILE__)
    information.root_directory = "#{File.expand_path File.dirname(__FILE__)}/.."
    information.conf_directory = "#{information.root_directory}/conf"

    # Conf summary    
    @logger.info("[Configuration] Information: #{information}")           
  end
  
  def parseOptions
    begin
      contents = YAML.load_file(@file)
    rescue Exception => e
      @logger.error("[Configuration] Config file #{@file} not found or invalid!")
      #This is critical!
      raise     
    end
    
    # Reads conf...
    envPrefix = @env.downcase
    
    options.redis_path = contents["cache"]["#{envPrefix}-redis-path"]
    options.wsin_port = contents["connector-ws"]["#{envPrefix}-wsin-port"]
    options.wsout_port = contents["connector-ws"]["#{envPrefix}-wsout-port"]
    
    # Conf summary    
    @logger.info("[Configuration] Options: #{options}")       
  end
  
end