#controller.rb
#Metrics Controller

require 'logger'
require 'singleton'
require 'optparse'
require 'pp'
require_relative 'configuration'
require_relative 'cache/rediscache'


class Controller 
  include Singleton

  attr_reader :allThreads
  attr_reader :configuration
  
  def initialize               
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    
    @allThreads = []
  end
    
  def run
    @logger.info("[Controller] Reviewing parameters from command line...")
    options = parseParams(ARGV)
    
    @logger.info("[Controller] Booting Metrics controller aka `BlackBox`...")

    @logger.info("[Controller] Loading configuration...")
    @configuration = Configuration.new(options[:env], options[:configFile])
    
    @logger.info("[Controller] Booting into #{options[:env]} mode...")
    
    @cache = RedisCache.new
    
    # Waiting for all threads to terminate
    allThreads.each { |thr| thr.join }    
  end
  
  def stop
    @logger.info("[Controller] Exiting Metrics controller.")    
  end  
  
  def parseParams(args)
    options = {}
    
    OptionParser.new do |opts|
      opts.banner = "Usage: controller.rb [options]"

      opts.on("-e", "--environment ENV", "(opt) Specify run environment : DEV/PROD. Defaulted to DEV.") do |e|
        options[:env] = e
      end

      opts.on("-c", "--config FILE", "(req) Specify config file") do |c|
        options[:configFile] = c
      end
      
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
      
      opts.on_tail("-v" , "--version", "Show version") do
        puts OptionParser::Version.join('.')
        exit
      end      
    end.parse!(args)
    
    # default options
    options[:env] = "DEV" if options[:env].nil?
    
    #Now raise an exception if we have not found mandatory options
    raise OptionParser::MissingArgument if options[:configFile].nil?
    
    options
  end
end

# Boot
Controller.instance.run
Controller.instance.stop

