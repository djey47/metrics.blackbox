#data-item.rb
#Data model: represents base structure for data exchange

class DataItem  
  attr_reader :key
  attr_reader :value
  
  def initialize(appId, contextId, natureId, value)
    @key = buildKey(appId, contextId, natureId)
    @value = value
  end
  
  def buildKey(appId, contextId, natureId)
    "#{appId}|#{contextId}|#{natureId}"  
  end       
end