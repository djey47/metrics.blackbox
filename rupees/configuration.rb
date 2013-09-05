#configuration.rb
#Handles Metrics configuration from yaml files

require 'ostruct'

class Configuration
  
  attr_reader :options
  attr_reader :env
  
  def initialize(currentEnv, configFile)
    @file = configFile
    @env = currentEnv
    @options = OpenStruct.new
    
    parse
  end
  
  def parse
    options.redis_path = "toto"
    
    
  end
  
end
