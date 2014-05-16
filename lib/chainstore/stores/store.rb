module Chainstore::Store

  def get(key)
    raise NotImplementedError
  end

  def put(key, value)
    raise NotImplementedError
  end

  def del(key, value)
    raise NotImplementedError
  end

end
