#webservices-out.rb
#OUT connector for webservices
#Hosts a web server on a local port (defined by configuration)

require 'sinatra/base'
require 'json'
require 'sinatra'
# require_relative '../../mediators/server'
require_relative '../../model/data-item'
require_relative '../../model/error-item'
require_relative '../../model/exceptions/novalue'

class HttpServerOut < Sinatra::Base  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO    
    #Required for correct Sinatra init
    super
  end

  def retrieve(appId, contextId, natureId)
    @logger.info("[HttpServerOut][retrieve] appId: #{appId} - contextId: #{contextId} - natureId: #{natureId}")
    #Server::get(appId, contextId, natureId, value)
    DataItem.new(appId, contextId, natureId,"FOO")
  end  
  
  def retrieveStar(appId)
    @logger.info("[HttpServerOut][retrieve*] appId: #{appId}")
    #Server::getAll(appId)
    
    toReturn = []
    toReturn << DataItem.new(appId, "CTX1", "NAT1", "FOO1")
    toReturn << DataItem.new(appId, "CTX1", "NAT2", "FOO2")
    toReturn
  end
    
  #TODO externalize to DataItem class ?
  def buildDataStructure(data)
    { :key => data.key, :value => data.value }    
  end
      
  def buildJsonResult(data)
    buildDataStructure(data).to_json       
  end
  
  def buildJsonResults(datas)
    toReturn = []
    datas.each { |data| toReturn << buildDataStructure(data) } 
    { :datas => toReturn}.to_json 
  end

  def buildJsonError(error, params)
    { :code => error, :detail => "#{params[:appId]}|#{params[:contextId]}|#{params[:natureId]}"}.to_json    
  end
  
  def handleJsonResult(json, params)
    if (params[:jsonp_callback]) 
      "#{params[:jsonp_callback]}(#{json})"
    else
      json 
    end     
  end
  
  #config  
  set :port, Proc.new { 
    Controller::instance.configuration.options.wsout_port 
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
    @logger.info("[HttpServerOut] Heartbeat!")
    [200, "Metrics - BlackBox: webservices OUT connector is alive :)"]
  end
  
  #OUT service : mono-valued
  get '/server/:appId/:contextId/:natureId' do
    begin      
      result = retrieve(params[:appId], params[:contextId], params[:natureId])
      json = buildJsonResult(result)
      content_type :json      
      [200, handleJsonResult(json, params)]      
    rescue NoValueException
      json = buildJsonError(ErrorItem::VALUE_NOT_FOUND, params)
      content_type :json      
      [404, handleJsonResult(json, params)]
    rescue => exception
      @logger.error("[HttpServerOut][mono] #{exception.class} : #{exception.message}")
      500
    end
  end
  
  #OUT service : multi-valued
  get '/server/:appId' do
    begin      
      results = retrieveStar(params[:appId])
      json = buildJsonResults(results)                  
      content_type :json         
      [200, handleJsonResult(json, params)]
    rescue NoValueException      
      json = buildJsonError(ErrorItem::VALUES_NOT_FOUND, params)      
      content_type :json      
      [404, handleJsonResult(json, params)]      
    rescue => exception
      @logger.error("[HttpServerOut][multi] #{exception.class} : #{exception.message}")
      500
    end      
  end  
end
  
class WebservicesOutConnector
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    Controller::instance.allThreads << Thread.new {      
      @logger.info("[WebservicesOutConnector] Starting HTTP server...")    
      HttpServerOut.run!
    }    
  end
end