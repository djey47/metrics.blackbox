#collector.rb
#Provides methods to handle information storage

require_relative '../model/data-item'

module Collector
  @logger = Logger.new(STDOUT)
  @logger.level = Logger::INFO
    
  def self.add(appId, contextId, natureId, value)
    @logger.info("[Collector][add] Data received. appId: #{appId} - contextId: #{contextId} - natureId: #{natureId} - value: #{value}")    
    toStore = []
    toStore << DataItem.new(appId, contextId, natureId, value)     
    #Controller::instance.cache.store(toStore)
  end  
  
  def self.addAll(appId, datas)
    @logger.info("[Collector][addAll] Data received. appId: #{appId} - values: #{datas}")
    begin
      toStore=[]
      datas.each { |data| toStore << DataItem.new(appId, data["key"]["ctxId"], data["key"]["natId"], data["value"]) }
      #Controller::instance.cache.store(toStore)
    rescue => exception
      @logger.error("[Collector][addAll] Error in JSON request!")
      raise exception
    end
  end  
end