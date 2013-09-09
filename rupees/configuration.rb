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
  attr_reader :env
  
  def initialize(currentEnv, configFile)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO    
    
    @file = configFile
    @env = currentEnv
    @options = OpenStruct.new
    
    parse
  end
  
  def parse
    begin
      contents = YAML.load_file(@file)
    rescue Exception => e
      @logger.error("[Configuration] Config file #{@file} not found or invalid!")
      #This is critical!
      raise     
    end
    
    # Reads conf...
    envPrefix = @env.downcase
    
    options.redis_path = contents["common"]["#{envPrefix}-redis-path"]
    
    # Conf summary    
    @logger.info("[Configuration] #{options}")       
  end
  
end