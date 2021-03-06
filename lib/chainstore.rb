require 'chainstore/version'
require 'chainstore/exceptions'
require 'chainstore/stores/store'
require 'chainstore/stores/linkable_store'
require 'chainstore/stores/in_memory_naive_store.rb'
require 'chainstore/stores/lru_memory_store.rb'
require 'chainstore/stores/redis_store.rb'
require 'chainstore/stores/s3_store.rb'

#TODO: Logging

module Chainstore

  class Chain
    def initialize(*links)
      @first = nil
      last = nil
      links.each { |link|
        raise StandardError unless link.class < Chainstore::Store
        if @first.nil?
          @first = link
        else
          last.next_in_chain = link
        end
        last = link
      }
      raise StandardError if @first.nil?
    end

    # Put should always chain
    def put(key, value)
      @first.put(key, value)
    end

    # Get only needs to chain if it can't find a key|value for the key
    def get(key)
      @first.get(key)
    end

    # Del should always chain
    def del(key)
      @first.del(key)
    end

  end
end
