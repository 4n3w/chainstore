require 'chainstore'

lru = LRU_MemoryStore.new 16
redis = RedisStore.new
s3 = S3Store.new 'AKIAI2BCDKXTOHL7PM4A', 'z3xfZdRn+bqixtcxZZKJTwtPQ/bGcNTLxm+ZOzC9', 's3.amazonaws.com', 'testing-chainstore-pressly' 

chain = Chainstore::Chain.new lru, redis, s3
chain.put 'Secret of the Universe', '42'

