#file-out.rb
#OUT connector to file system
#Polls server to get datas to write to a given file on disk

class FileOutConnector
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    @currentDumpFile = nil
    @buffer = nil
    @startDateTime = nil
  end

  def start(fileName, appId)
    if running?
      @logger.warn "[FileOutConnector] Start request ignored: already logging to #{@currentDumpFile}."
    else
      frequency = Controller::instance.configuration.options.fileout_polling_rate.to_i
      
      @logger.info "[FileOutConnector] Starting logging for appId:#{appId} @#{frequency}Hz..."
      @currentDumpFile = fileName
      @startDateTime = Time.now
      @buffer = []
      @dumpThread = repeat_every(1/frequency) do
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

      #@logger.debug "[FileOutConnector] Dumping data: #{@buffer}"

      File.open(@currentDumpFile, "w") { |file| @buffer.each do |data|
          file.write(data + "\n")
        end }
      fileSize = File.size(@currentDumpFile).to_f

      @logger.info "[FileOutConnector] Succesfully dumped data to #{@currentDumpFile} - bytes written: #{fileSize}"

      @dumpThread = nil
      @currentDumpFile = nil
      @startDateTime = nil
      @buffer = []
    else
      @logger.warn "[FileOutConnector] Not logging. Ignoring stop request."
    end
  end

  def running?
    !(@dumpThread.nil?)
  end

  private
  
  def dumpLoop(appId)
    # @logger.debug "[FileOutConnector] Logging!"

    begin
      @buffer << buildJsonResults(Server::getAll(appId))
    rescue NoValueException
      @buffer << buildJsonNoValue
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
    datas.each { |data| toReturn << buildJsonData(data) }
    { :d => toReturn}.to_json
  end

  def buildJsonNoValue
    {}.to_json
  end

  def buildJsonData(data)
    { :k => data.key, :v => data.value }
  end
end