#sharedmemory-in.rb
#IN connector from shared memory (Windows only)

require 'windows/file_mapping'
require 'win32/mmap'


class SharedMemoryInConnector
  include Windows::FileMapping
  include Win32
    
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @mappings = []    

    Controller::instance.allThreads << Thread.new {      
      @logger.info("[SharedMemoryInConnector] Starting connector...")    
      run
    }        
  end
  
  def run
    readConfiguration

    begin
      fileName = @mappings[0]["shared-filename"]   
      fileHandle = OpenFileMapping(0x02, 0, fileName)      
      
      raise Exception, "Unable to capture memory file for Name:#{fileName}" unless fileHandle != 0
      
      @logger.info("[SharedMemoryInConnector] File Handle:#{fileHandle} for Name:#{fileName}") 
      sharedData = MapViewOfFile(fileHandle, 0x02, 0, 0, 0)
      
      if (sharedData.nil?)
        CloseHandle(fileHandle)
        raise Exception, "Unable to capture shared memory data."        
      end
      
      @logger.info("[SharedMemoryInConnector] Share data:#{sharedData}")
     
    rescue Exception => exception
      @logger.error("[SharedMemoryInConnector] #{exception.inspect}")
    end
  end
  
  def readConfiguration
    @logger.info("[SharedMemoryInConnector] Loading mappings...")    
    mappingFiles = Controller::instance.configuration.options.sharedmem_files
    
    mappingFiles.each do |mappingFile| 
      mappingFilePath = "#{Controller::instance.configuration.information.conf_directory}/#{mappingFile}"
      begin
        @mappings << YAML.load_file(mappingFilePath)
        @logger.info("[SharedMemoryInConnector] Loaded mappings: #{@mappings}")    
      rescue Exception => exception
        @logger.error("[SharedMemoryInConnector] Mapping file #{mappingFilePath} not found or invalid! #{exception.inspect}")
      end
    end
  end
end