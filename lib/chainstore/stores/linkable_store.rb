module Chainstore::LinkableStore

  def self.included(base)
    base.extend(ClassMethods)
  end

  def next_in_chain=(next_obj)
    @_next_in_chain = next_obj
    next_obj || self
  end

  alias_method :set_next, :next_in_chain=

  def next_in_chain
    @_next_in_chain ||= nil
    @_next_in_chain
  end

  def abort_chain
    @_abort_chain = true
  end

  private

  module ClassMethods
    def chain_method(method)
      original_method = "execute_#{method}".to_sym
      alias_method original_method, method

      self.class_eval <<-RUBYHERE
        def #{method}(*args, &block)
          @_abort_chain = false
          val = #{original_method}(*args, &block)
          if !@_abort_chain && next_in_chain #!next_in_chain.nil?
            next_in_chain.#{method}(*args, &block)
          else
            val
          end
        end
      RUBYHERE
    end
  end

end
