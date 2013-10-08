#file-out.rb
#OUT connector to file system
#Polls server to get datas to write to a given file on disk

class FileOutConnector
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    
    @currentDumpFile = nil
  end  
  
  def start(fileName)    
    if fileName == @currentDumpFile
      @logger.warn "[FileOutConnector] Already logging to #{fileName}. Ignoring start request."
    else
      stop
      
      @logger.info "[FileOutConnector] Starting logging to #{fileName} @60Hz..."
      @currentDumpFile = fileName    
      @dumpThread = repeat_every(1/60) do
          dumpLoop      
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
      
      #TODO Should write buffer to file then close
                   
      @dumpThread = nil
      @currentDumpFile = nil      
    else
      @logger.warn "[FileOutConnector] Not logging. Ignoring stop request."      
    end  
  end
    
  def running?
    !(@dumpThread.nil?)
  end
  
  def dumpLoop       
    @logger.info "[FileOutConnector] Logging!"
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
end