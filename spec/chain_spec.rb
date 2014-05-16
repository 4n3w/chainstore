require 'spec_helper'

describe Chainstore::Chain do

  context '.initialize\'s happy path' do
    let(:ims) { InMemoryNaiveStore.new }

    it 'accepts a set of classes that mix-in Chainstore::Store' do
      Chainstore::Chain.new(ims)
    end
  end

  context '.initialize handles bad input gracefully' do
    let(:ims) { InMemoryNaiveStore.new }

    it 'throws StandardError when given bad input' do
      expect { Chainstore::Chain.new("RandomString", 5) }.to raise_error(StandardError)
    end

    it 'throws StandardError when given good and bad input' do
      expect { Chainstore::Chain.new(ims, 5) }.to raise_error(StandardError)
    end
  end

  context 'multiple Naive in memory stores' do
    let(:ims_one) { InMemoryNaiveStore.new }
    let(:ims_two) { InMemoryNaiveStore.new }
    let(:chain) { Chainstore::Chain.new(ims_one, ims_two) }

    context '.initialize' do
      it 'instantiates a correct storechain without issue' do
        Chainstore::Chain.new(ims_one, ims_two)
      end
    end

    context '.put' do
      it 'calls put on both stores' do
        chain.put 'key', 'value'
        #TODO: Double/mock the put method on ims_{one,two}
      end
    end

    context '.get' do
      it 'calls get on only the first store' do
        chain.put 'k1', 'v1'
        expect(chain.get 'k1').to eq 'v1'
      end

      it 'calls get on the second store' do
        chain.put 'k1', 'v1'
        ims_one.data = {}
        expect(chain.get 'k1').to eq 'v1'
      end

    end

    context '.del' do
      it 'deletes from all stores in chain' do
        chain.put 'k1', 'v1'
        chain.del 'k1'
        expect(chain.get 'k1').to eq nil
      end

      it 'double delete is ok' do
        chain.put 'dd1k', 'dd1v'
        chain.del 'dd1k'
        chain.del('dd1k')
      end
    end
  end

  context 'LRU and naive stores in chain' do
    let(:lru_one) { LRU_MemoryStore.new 4}
    let(:ims_two) { InMemoryNaiveStore.new }
    let(:chain) { Chainstore::Chain.new(lru_one, ims_two) }
    let(:lru_only_chain) { Chainstore::Chain.new(lru_one) }

    context '.initialize' do
      it 'instantiates a correct storechain without issue' do
        Chainstore::Chain.new(lru_one, ims_two)
      end
    end

    context '.del' do
      it 'deletion cascades properly through chain' do
        chain.put '1', 'One'
        expect(chain.del '1').to eq true
      end

      it 'deletion actually deletes tuples from the chain' do
        chain.put '1', 'One'
        chain.del '1'
        expect(chain.get '1').to eq nil
      end
    end

    context '.get' do
      it 'get works correctly' do
        chain.put 'getworks_correctly', 'it sure does'
        expect(chain.get 'getworks_correctly').to eq 'it sure does'
      end

      it 'get works when tuple is deleted from lru' do
        chain.put '1', 'lru tuple deletion'
        lru_one.data.delete '1'
        expect(chain.get '1').to eq 'lru tuple deletion'
      end
    end

    context '.put' do
      it 'lru cache does not store more than it should' do
        lru_only_chain.put '1', 'one'
        lru_only_chain.put '2', 'two'
        lru_only_chain.put '3', 'three'
        lru_only_chain.put '4', 'four'
        lru_only_chain.put '5', 'five'
        expect(lru_only_chain.get '1').to eq nil
        expect(lru_only_chain.get '5').to eq 'five'
      end

      it 'chain handles putting a larger number of elements than the LRU cache can contain' do
        chain.put '1', 'one'
        chain.put '2', 'two'
        chain.put '3', 'three'
        chain.put '4', 'four'
        chain.put '5', 'five'
        expect(chain.get '1').to eq 'one'
      end
    end
  end

  context 'Redis-only chain' do
    let(:redis) { RedisStore.new }
    let(:chain) { Chainstore::Chain.new(redis) }

    context '.initialize' do
      it 'instantiates the chain correctly' do
        Chainstore::Chain.new(redis)
      end
    end

    context '.get' do
      it 'correctly retrieves a value' do
        chain.put '.get1', 'My hovercraft is full of eels.'
        expect(chain.get '.get1').to eq 'My hovercraft is full of eels.'
      end

      it 'correctly returns nil for a non-existent key' do
        expect(chain.get '.get2').to eq nil
      end
    end

    context '.put' do
      it 'correctly puts a value into redis' do
        expect(chain.put '.put1', 'Value!').to eq true
      end

      it 'correctly double puts a value into redis' do
        chain.put '.put1', 'Value 1!'
        chain.put '.put1', 'Value 2!'
        expect(chain.get '.put1').to eq 'Value 2!'
      end

      it 'returns false when putting a nil key' do
        expect(chain.put nil, 'Value of awesomeness').to eq false
      end
    end

    context '.del' do
      it 'correctly deletes a record' do
        chain.put '.del1', 'Value'
        expect(chain.del '.del1').to eq true
      end

      it 'correctly deletes a non existent record' do
        expect(chain.del 'Bogus').to eq false
      end
    end
  end

  context 'S3-only chain' do
    let(:s3) { S3Store.new 'AKIAI2BCDKXTOHL7PM4A', 'z3xfZdRn+bqixtcxZZKJTwtPQ/bGcNTLxm+ZOzC9', 's3.amazonaws.com', 'testing-chainstore-pressly' }
    let(:chain) { Chainstore::Chain.new(s3) }

    context '.initialize' do
      it 'initializes without error' do
        Chainstore::Chain.new(s3)
      end
    end

    context '.get' do
      it 'calls .get on a non-existent key' do
        expect(chain.get 'notyet').to eq nil
      end
    end

    context '.put' do
      it 'puts a value correctly' do
        chain.put 'andrew', 'wood'
        expect(chain.get 'andrew').to eq 'wood'
      end
    end

    context '.del' do
      it 'deletion of a non-existent record returns true' do
        expect(chain.del 'berks').to eq true
      end

      it 'deletion of an existent record returns true' do
        chain.put 's3-test-del', 'deletion test'
        chain.del 's3-test-del'
        expect(chain.get 's3-test-del').to eq nil
      end
    end

  end

  context 'Redis and Naive in memory stores' do
    let(:ims_one) { InMemoryNaiveStore.new }
    let(:redis_two) { RedisStore.new }
    let(:chain) { Chainstore::Chain.new(ims_one, redis_two) }

    context '.initialize' do
      it 'initializes correctly' do
        Chainstore::Chain.new(ims_one, redis_two)
      end
    end

    context '.put' do
      it 'puts a single value correctly' do
        chain.put '1', 'One'
      end
    end
  end


end