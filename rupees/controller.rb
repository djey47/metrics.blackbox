#controller.rb
#Metrics Controller

require 'logger'
require 'singleton'
require 'optparse'
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
    
    @logger.info("[Controller] Booting Metrics controller aka `BlackBox`into #{options[:env]} mode...")

    @logger.info("[Controller] Loading configuration...")
    @configuration = Configuration.new(options[:env], options[:configFile])
    
    @cache = RedisCache.new
    
    @logger.info("[Controller] Ready to rumble!")
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
      
      opts.on_tail("-v" , "--version", "Show version information about this program") do
        puts OptionParser::Version.join('.')
        exit
      end      
    end.parse!(args)
        
    validate options
  end
  
  def validate(options)    
    @logger.info("[Controller] * -c/--config ...")            
    raise OptionParser::MissingArgument if options[:configFile].nil?

    @logger.info("[Controller] * -e/--environment ...")            
    options[:env] = Environment::DEVELOPMENT if options[:env].nil?
    raise OptionParser::InvalidArgument if
      options[:env] != Environment::DEVELOPMENT && options[:env] != Environment::PRODUCTION    
    
    options
  end
end

# Boot
Controller.instance.run
Controller.instance.stop

