#webservices-in.rb
#IN connector for webservices
#Hosts a web server on a local port (defined by configuration)

require 'sinatra/base'
require 'json'
require 'sinatra'
require_relative '../../mediators/collector'


class HttpServerIn < Sinatra::Base  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO    
    #Required for correct Sinatra init
    super
  end

  def store(appId, contextId, natureId, value)
    @logger.info("[HttpServerIn][store] appId: #{appId} - contextId: #{contextId} - natureId: #{natureId} - value: #{value}")
    Collector::add(appId, contextId, natureId, value)
  end  
  
  def storeStar(appId, datas)
    @logger.info("[HttpServerIn][store*] appId: #{appId} - values: #{datas}")    
    Collector::addAll(appId, datas)
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
    Controller::instance.configuration.information.env == "DEV"
  }
 
  #Heartbeat
  get '/' do
    @logger.info("[HttpServerIn] Heartbeat!")
    [200, "Metrics - BlackBox: webservices IN connector is alive :)"]
  end
  
  #IN service : mono-valued
  post '/collector/:appId/:contextId/:natureId/:value' do
    begin
      store(params[:appId], params[:contextId], params[:natureId], params[:value])
      204
    rescue => exception
      @logger.error("[HttpServerIn][mono] #{exception.inspect}")
      500
    end
  end
  
  #IN service : multi-valued
  post '/collector/:appId' do
    begin
      req = JSON.parse(request.body.read)
      storeStar(params[:appId], req["datas"])
      204
    rescue => exception
      @logger.error("[HttpServerIn][multi] #{exception.inspect}")
      400
    end
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