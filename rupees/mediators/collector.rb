#collector.rb
#Provides methods to handle information storage

require_relative '../model/data-item'

module Collector
  @logger = Logger.new(STDOUT)
  @logger.level = Logger::INFO
    
  def add(appId, contextId, natureId, value)
    @logger.info("[Collector][add] Data received! appId: #{appId} - contextId: #{contextId} - natureId: #{natureId} - value: #{value}")    
    datas = []
    datas << DataItem.new(appId, contextId, natureId, value)     
    #Controller::instance.cache.store(datas)
  end  
end