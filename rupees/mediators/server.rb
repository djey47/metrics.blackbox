#server.rb
#Provides methods to handle gathering of stored information

require_relative '../model/data-item'
require_relative '../model/exceptions/novalue'

module Server
  @logger = Logger.new(STDOUT)
  @logger.level = Logger::INFO
  
  def self.get(appId, contextId, natureId)
    @logger.info("[Server][get] Request received. appId: #{appId} - contextId: #{contextId} - natureId: #{natureId}")    
    datas = []
    datas << DataItem.new(appId, contextId, natureId, "")    
    results = Controller::instance.cache.retrieve(datas)
    
    if (results[0].value.nil?)
      raise NoValueException, 'Value not found for key #{datas[0].key}.'
    end
    results[0]
  end

  def self.getAll(appId)
    @logger.info("[Server][getAll] Request received. appId: #{appId}")    
    results = Controller::instance.cache.retrieveByAppId(appId)
    
    if (results.length == 0)
      raise NoValueException, 'Value not found for appId #{appId}.'
    end        
    results
  end
end