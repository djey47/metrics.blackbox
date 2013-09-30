#controller-access.rb
#WS for remote access to Metrics Controller (status, actions)

require 'sinatra/base'
require 'json'
require 'sinatra'

class HttpServerAccess < Sinatra::Base  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO    
    #Required for correct Sinatra init
    super
  end

  def startFileLogging(fileName)
    @logger.info("[HttpServerAccess][startFileLogging] fileName: #{fileName}")
    
    # TODO: should check whether file can be written on disk
    
    # TODO: should create a thread, calling server at fixed rate and write results to buffer    
  end  
  
  def stopFileLogging(fileName)
    @logger.info("[HttpServerAccess][stopFileLogging] fileName: #{fileName}")    

    # TODO: should stop polling thread and flush buffer to file

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
  
  #Starts logging via file OUT connector
  get '/controller/fileOutConnector/start/:fileName' do
    begin
      startFileLogging(params[:fileName])
      204
    rescue => exception
      @logger.error("[HttpServerAccess][startFileOutConnector] #{exception.inspect}")
      500
    end
  end
  
  #Stops logging via file OUT connector
  get '/controller/fileOutConnector/stop/:fileName' do
    begin
      stopFileLogging(params[:fileName])
      204
    rescue => exception
      @logger.error("[HttpServerAccess][stopFileOutConnector] #{exception.inspect}")
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
