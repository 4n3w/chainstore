require 'redis'

class RedisStore
  include Chainstore::Store
  include Chainstore::LinkableStore

  #TODO flushdb clears current database, flushall clears all databases
  #TODO create a specific database to not clobber with the above.
  #TODO modify tests accordingly.
  #TODO add mocks!

  def initialize(url = nil)
    if url.nil?
      @redis = Redis.new
    else
      @redis = Redis.new url
    end
  end

  def get(key)
    @redis.get(key)
  end

  def put(key, value)
    return false if key.nil?
    status = @redis.set(key, value)
    status == 'OK' ? true : status
  end

  def del(key)
    return true if @redis.del(key) >= 1
    false
  end

  chain_method :get
  chain_method :put
  chain_method :del
end