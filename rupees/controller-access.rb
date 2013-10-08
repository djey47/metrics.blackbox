#controller-access.rb
#WS for remote access to Metrics Controller (status, actions)

require 'sinatra/base'
require 'fileutils'
require 'json'
require 'sinatra'

class HttpServerAccess < Sinatra::Base  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO    
    #Required for correct Sinatra init
    super
  end
  
  def stopMetrics
    @logger.info("[HttpServerAccess][stopMetrics]")
    Controller::instance.shutdown    
  end

  def startFileLogging(fileName)
    @logger.info("[HttpServerAccess][startFileLogging] fileName: #{fileName}")
    Controller::instance.startFileLogging(fileName)
  end  
  
  def stopFileLogging
    @logger.info("[HttpServerAccess][stopFileLogging]")    
    Controller::instance.stopFileLogging
  end
  
  #config  
  set :port, Proc.new { 
    Controller::instance.configuration.options.wsaccess_port 
  }
  set :environment, Proc.new {
    if (Controller::instance.configuration.information.env == "DEV")
      :development
    else
      :production
    end
  }
  set :show_exceptions, Proc.new {
    Controller::instance.configuration.information.env == "DEV"
  }
 
  #Heartbeat
  get '/' do
    @logger.info("[HttpServerAccess] Heartbeat!")
    [200, "Metrics - BlackBox: controller access is alive :)"]
  end
  
  #Stops METRICS
  get '/controller/shutdown' do
    begin
      stopMetrics
      204
    rescue => exception
      @logger.error("[HttpServerAccess] shutdown: #{exception.inspect}")
      500
    end    
  end
  
  #Starts logging via file OUT connector
  get '/controller/fileOutConnector/start/:fileName' do
    begin
      startFileLogging(params[:fileName])
      204
    rescue => exception
      @logger.error("[HttpServerAccess] startFileOutConnector: #{exception.inspect}")
      500
    end
  end
  
  #Stops logging via file OUT connector
  get '/controller/fileOutConnector/stop' do
    begin
      stopFileLogging
      204
    rescue => exception
      @logger.error("[HttpServerAccess] stopFileOutConnector: #{exception.inspect}")
      500
    end
  end
end

class ControllerAccess
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    Controller::instance.allThreads << Thread.new {      
      @logger.info("[ControllerAccess] Starting HTTP server...")    
      HttpServerAccess.run!
    }    
  end
  
end
