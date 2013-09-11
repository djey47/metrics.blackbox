#webservices-in.rb
#IN connector for webservices
#Hosts a web server on a local port (defined by configuration)

require 'sinatra'
require 'sinatra/base'

class HttpServerIn < Sinatra::Base  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO    
    #Required for correct Sinatra init
    super
  end

  #config  
  set :port, Proc.new { 
    Controller::instance.configuration.options.wsin_port 
  }
  set :environment, Proc.new {
    if (Controller::instance.configuration.information.env == "DEV")
      :development
    else
      :production
    end
  }
  set :show_exceptions, Proc.new {
    Controller::instance.configuration.information.env
  }
 
  #Heartbeat
  get '/' do
    @logger.info("[HttpServerIn] GET /")
    [200, "Metrics - BlackBox: webservices IN connector is alive :)"]
  end
end

class WebservicesInConnector
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    Controller::instance.allThreads << Thread.new {      
      @logger.info("[WebservicesInConnector] Starting HTTP server...")    
      HttpServerIn.run!
    }    
  end
end