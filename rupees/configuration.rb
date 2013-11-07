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
  
  def initialize(currentEnv, configFile)
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO    
    
    @options = OpenStruct.new
    @information = OpenStruct.new
    
    setInformation(currentEnv)
    parseOptions(configFile, currentEnv)
  end

  private
    
  def setInformation(env)
    information.env = env
    information.rb_directory = File.expand_path File.dirname(__FILE__)
    information.root_directory = "#{information.rb_directory}/.."
    information.conf_directory = "#{information.root_directory}/conf"
    information.out_directory = "#{information.root_directory}/out"

    # Conf summary    
    @logger.info("[Configuration] Information: #{information}")           
  end
  
  def parseOptions(configFile, env)
    begin
      contents = YAML.load_file(configFile)
    rescue Exception => exception 
      @logger.error("[Configuration] Config file #{configFile} not found or invalid! #{exception.inspect}")
      #This is critical!
      raise     
    end
    
    # Reads conf...
    envPrefix = env.downcase
    
    options.wsaccess_port = contents["controller"]["#{envPrefix}-wsaccess-port"]
    options.redis_path = contents["cache"]["#{envPrefix}-redis-path"]
    options.wsin_port = contents["connector-ws"]["#{envPrefix}-wsin-port"]
    options.wsout_port = contents["connector-ws"]["#{envPrefix}-wsout-port"]
    options.sharedmem_files = contents["connector-sharedmemory"]["mapping-files"]
    options.fileout_polling_rate = contents["connector-file"]["polling-rate"]
           
    # Conf summary    
    @logger.info("[Configuration] Options: #{options}")       
  end  
end