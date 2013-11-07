#options.rb
#Handles parsing of command line options for Metrics controller
#Important: every class including this module has to provide a @logger member (Ruby Logger class)

require 'optparse'

module Options
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
      
      opts.on("-w", "--windows", "(opt) Specify windows-specific features to be activated.") do |c|
        options[:windows] = true
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
        
    validate(options)
  end
  
  private
  
  def validate(options)    
    @logger.info("[Options] * Validating -c/--config ...")            
    raise OptionParser::MissingArgument if options[:configFile].nil?

    @logger.info("[Options] * Validating -e/--environment ...")            
    options[:env] = Environment::DEVELOPMENT if options[:env].nil?
    raise OptionParser::InvalidArgument unless 
      options[:env] == Environment::DEVELOPMENT || options[:env] == Environment::PRODUCTION    
    
    options
  end
  
end