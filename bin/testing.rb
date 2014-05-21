#!/usr/bin/env ruby

require 'chainstore'

lru = LRU_MemoryStore.new 16
redis = RedisStore.new
s3 = S3Store.new 'accessKeyId', 'secretAccessKey', 's3.amazonaws.com', 'testing-chainstore-pressly' 

chain = Chainstore::Chain.new lru, redis, s3
chain.put 'Secret of the Universe', '42'

