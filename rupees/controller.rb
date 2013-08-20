#controller.rb
#Metrics Controller

require 'singleton'

class Controller 
  include Singleton
  
  def initialize               
  end
    
  def run
  end
end

# Boot
puts("[Controller] Booting Metrics controller aka `BlackBox`...")

Controller.instance.run

puts("[Controller] Exiting Metrics controller...")
