module Resourcelogic
  module Child
    def self.included(klass)
      klass.class_eval do
        add_acts_as_resource_module(Urls)
      end
    end
    
    module Urls
      private
        # The following should work
        #
        #   child_path(obj)
        #   child_path(obj, :id => 2) # where obj is then replaced by the obj with id 2
        #   child_path(:child_name, :id => 2) # where this is a literal build of the url
        def child_url_parts(action = nil, child = nil, url_params = {})
          child_base_parts(action, url_params) + [[child.is_a?(Symbol) ? child : child.class.name.underscore.to_sym, child], url_params]
        end
        
        def child_collection_url_parts(action = nil, child_name = nil, url_params = {})
          child_base_parts(action, url_params) + [child_name, url_params]
        end
        
        # This determines if the child if off of an object or the collection. Most of the time,
        # as assumed, it will be off of an object. But let's say you are at this url:
        #
        #   /payments
        #
        # And you call this path:
        #
        #   child_collection(:credit_cards)
        #
        # There is no object to be a child off, we are in the collection / index action. But
        # we still want to call the following url:
        #
        #   /payments/credit_cards
        #
        # That's what this method does, it makes the above possible. So you can still link
        # to the "child" credit cards resource relatively, keeping the idea of contextual
        # development intact. Maybe you only want to use payments as a context for the
        # credit cards resource.
        def child_base_parts(action, url_params)
          object_to_use = (url_params.key?("#{model_name}_id".to_sym) && url_params["#{model_name}_id".to_sym]) || (id? && object)
          base_parts = object_to_use || singleton? ? object_url_parts(action, object_to_use) : collection_url_parts(action)
          base_parts.pop if base_parts.last.is_a?(Hash)
          base_parts
        end
        
        #def current_object_to_use(url_params)
        #  result = (url_params.key?("#{model_name}_id".to_sym) && url_params["#{model_name}_id".to_sym]) || (id? && object)
        #  result ? result : nil
        #end
    end
  end
end