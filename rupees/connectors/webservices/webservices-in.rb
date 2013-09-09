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
  set :environment, :development
  #set :server, %w[thin]    
  set :port, 4567  

  #Q&D example
  get '/' do
    @logger.info("[HttpServerIn] GET /")

    [200, 'Hello world! This is Metrics Project - BlackBox :)
    <br/>
    Currently demonstrating of webservices IN connector']
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