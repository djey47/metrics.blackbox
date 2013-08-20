#controller.rb
#Metrics Controller

require 'logger'
require 'singleton'

class Controller 
  include Singleton
  
  def initialize               
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end
    
  def run
    @logger.info("[Controller] Booting Metrics controller aka `BlackBox`...")
  end
  
  def stop
    @logger.info("[Controller] Exiting Metrics controller.")    
  end
end

# Boot
Controller.instance.run
Controller.instance.stop

