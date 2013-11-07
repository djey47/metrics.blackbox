#data-item.rb
#Data model: represents base structure for data exchange

class DataItem  
  attr_reader :appId
  attr_reader :contextId
  attr_reader :natureId
  attr_reader :value
  
  KEY_SEPARATOR = "|"
  
  def initialize(appId, contextId, natureId, value)
    @appId = appId
    @contextId = contextId
    @natureId = natureId
    @value = value
  end

  def self.fromKey(key, value)    
    keyItems = key.split(KEY_SEPARATOR)
    DataItem.new(keyItems[0], keyItems[1], keyItems[2], value)
  end  
  
  private
  
  def key
    "#{@appId}#{KEY_SEPARATOR}#{@contextId}#{KEY_SEPARATOR}#{@natureId}"  
  end       
end