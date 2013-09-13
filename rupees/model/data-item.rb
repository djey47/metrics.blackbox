#data-item.rb
#Data model: represents base structure for data exchange

class DataItem  
  attr_reader :appId
  attr_reader :contextId
  attr_reader :natureId
  attr_reader :value
  
  def initialize(appId, contextId, natureId, value)
    @appId = appId
    @contextId = contextId
    @natureId = natureId
    @value = value
  end
  
  def key
    "#{@appId}|#{@contextId}|#{@natureId}"  
  end       
end