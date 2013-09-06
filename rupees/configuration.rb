#configuration.rb
#Handles Metrics configuration from yaml files

require 'ostruct'
require 'yaml'
require 'logger'

class Configuration
  
  attr_reader :options
  attr_reader :env
  
  def initialize(currentEnv, configFile)
    @logger = Logger.new(STDOUT)
    
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
      raise     
    end
    
    # Reads conf...
    if @env == "DEV"
      options.redis_path = contents["common"]["dev-redis-path"]
    elsif @env == "PROD"
      options.redis_path = contents["common"]["prod-redis-path"]
    end
    
    # Conf summary    
    @logger.info("[Configuration] * redis_path = #{options.redis_path}")
        
  end
  
end
