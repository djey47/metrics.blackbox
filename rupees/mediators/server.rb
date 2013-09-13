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
    #results = MetricsController.instance.cache.retrieve(datas)
    results = []
    results << DataItem.new(appId, contextId, natureId, "FOO")
    
    if (results[0].value.nil?)
      raise NoValueException, 'Value not found for key #{datas[0].key}.'
    else
      results[0]
    end        
  end
end