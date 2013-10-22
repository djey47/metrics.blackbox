#file-out.rb
#OUT connector to file system
#Polls server to get datas to write to a given file on disk

class FileOutConnector
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    
    @currentDumpFile = nil
    @buffer = nil
  end  
  
  def start(fileName, appId)    
    if fileName == @currentDumpFile
      @logger.warn "[FileOutConnector] Already logging to #{fileName}. Ignoring start request."
    else
      stop
      
      @logger.info "[FileOutConnector] Starting logging to #{fileName} @60Hz..."
      @currentDumpFile = fileName    
      @buffer = []
      @dumpThread = repeat_every(1/60) do
          dumpLoop(appId)      
      end                
      Controller::instance.allThreads << @dumpThread       
    end
  end
  
  def stop
    if running?
      @logger.info "[FileOutConnector] Stopping logging to #{@currentDumpFile}."
      Thread.kill @dumpThread
      @dumpThread.join
      Controller::instance.allThreads.delete @dumpThread
      
      @logger.info "[FileOutConnector] Dumping data: #{@buffer}"
      
      File.open(@currentDumpFile, "w") { |file| @buffer.each do |data|
        file.write(data + "\n")
      end }

      fileSize = File.size(@currentDumpFile).to_f
      @logger.info "[FileOutConnector] Succesfully dumped data to #{@currentDumpFile} - bytes written: #{fileSize}"
                          
      @dumpThread = nil
      @currentDumpFile = nil  
      @buffer = []    
    else
      @logger.warn "[FileOutConnector] Not logging. Ignoring stop request."      
    end  
  end
    
  def running?
    !(@dumpThread.nil?)
  end
  
  def dumpLoop(appId)       
    @logger.info "[FileOutConnector] Logging!"

    begin      
      @buffer << buildJsonResults(Server::getAll(appId))
    rescue NoValueException      
      @buffer << buildJsonError(ErrorItem::VALUE_NOT_FOUND, appId)
    rescue => exception
      @logger.error("[FileOutConnector] #{exception.inspect}")
    end          
  end
  
  def repeat_every(interval)
    Thread.new do
      loop do
        start_time = Time.now
        yield
        elapsed = Time.now - start_time
        sleep([interval - elapsed, 0].max)
      end
    end
  end
  
  def buildJsonResults(datas)
    toReturn = []
    datas.each { |data| toReturn << buildDataStructure(data) } 
    { :datas => toReturn}.to_json 
  end

  def buildJsonError(error, appId)
    { :code => error, :detail => "#{appId}|*|*"}.to_json    
  end
  
  def buildDataStructure(data)
    { :key => data.key, :value => data.value }    
  end

end