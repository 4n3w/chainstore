module Chainstore
  # TODO: Move away from boolean return values
  # Note: I wanted to groom exceptions according to the following, but It's 23:35 and I said I'd
  # have this done by EOD :/
    class ChainstoreError < StandardError; end
    class NilKeyError < ChainstoreError; end
    class NilValueError < ChainstoreError; end
    class KeyNotFoundError < ChainstoreError; end
    class KeyRemovalError < ChainstoreError; end
    class StoreProtocolError < ChainstoreError; end
    class StoreTransportError < ChainstoreError; end
end