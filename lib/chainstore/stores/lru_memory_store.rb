class LRU_MemoryStore
  include Chainstore::Store
  include Chainstore::LinkableStore

  attr_accessor :size, :data

  def initialize(size = 16, name = 'Default LRU Memory Store')
    @size = size
    @data = {}
  end

  def get(key)
    if value = @data[key]
      renew(key)
      age_keys
      return value[1]
    end
    nil
  end

  def put(key, value)
    return false if key.nil?
    @data.store key, [0, value]
    age_keys
    prune
  end

  def del(key)
    @data.delete key
    true
  end

  chain_method :get
  chain_method :put
  chain_method :del

  private

  def renew(key)
    @data[key][0] = 0
  end

  def delete_oldest
    oldest = @data.values.map { |v| v[0] }.max
    @data.reject! { |_, v| v[0] == oldest }
  end

  def age_keys
    @data.each { |k, _| @data[k][0] += 1 }
  end

  def prune
    delete_oldest if @data.size > size
  end

end