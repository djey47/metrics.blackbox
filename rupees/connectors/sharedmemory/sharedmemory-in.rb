#sharedmemory-in.rb
#IN connector from shared memory (Windows only)

class SharedMemoryInConnector
  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    Controller::instance.allThreads << Thread.new {      
      @logger.info("[SharedMemoryInConnector] Starting connector...")    
      run
    }        
  end
  
  def run
    readConfiguration
    
    
    
  end
  
  def readConfiguration
    @logger.info("[SharedMemoryInConnector] Loading mappings...")    
    mappingFiles = Controller::instance.configuration.options.sharedmem_files
    mappings = []
    mappingFiles.each do |mappingFile| 
      mappingFilePath = "#{Controller::instance.configuration.information.conf_directory}/#{mappingFile}"
      begin
        mappings << YAML.load_file(mappingFilePath)
        @logger.info("[SharedMemoryInConnector] #{mappings}")    
      rescue Exception => exception
        @logger.error("[SharedMemoryInConnector] Mapping file #{mappingFilePath} not found or invalid! #{exception.class} : #{exception.message}")
      end
    end
  end
end