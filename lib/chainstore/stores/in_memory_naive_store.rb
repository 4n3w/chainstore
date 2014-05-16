class InMemoryNaiveStore
  include Chainstore::Store
  include Chainstore::LinkableStore

  attr_accessor :data #for testing

  def initialize
    @data = {}
  end

  def put(key, value)
    #TODO: replace booleans with exceptions
    #raise NilKeyError if key.nil?
    return false if key.nil?
    @data.store key, value
    true
  end

  def get(key)
    abort_chain unless @data[key].nil?
    @data[key]
  end

  def del(key)
    @data.delete(key)
    true
  end

  chain_method :get
  chain_method :put
  chain_method :del
end