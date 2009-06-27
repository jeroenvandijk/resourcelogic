module Resourcelogic
  class ResponseCollector
    
    attr_reader :responses
    
    delegate :clear, :to => :responses
    
    def initialize
      @responses = []
    end
    
    def method_missing(method_name, &block)
      existing = self[method_name]
      if existing
        existing[0] = method_name
        existing[1] = block || nil
      else
        @responses << [method_name, block || nil]
      end
    end
    
    def [](symbol)
      @responses.find { |method, block| method == symbol }
    end
    
    def dup
      returning ResponseCollector.new do |duplicate|
        duplicate.instance_variable_set(:@responses, responses.dup)
      end
    end
  end
end