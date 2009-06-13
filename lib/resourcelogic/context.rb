# Nested and Polymorphic Resource Helpers
#
module Resourcelogic
  module Context
    def self.included(klass)
      klass.class_eval do
        add_acts_as_resource_module(Methods)
      end
    end
    
    module Methods
      def self.included(klass)
        klass.helper_method :context, :contexts, :contexts_url_parts
        klass.hide_action :context, :contexts
      end
      
      def context
        @context ||= contexts.last
      end
      
      def contexts
        return @contexts if defined?(@contexts)
        path_parts = request.path.split("/")
        path_parts.shift
        @contexts = []
        path_parts.each_with_index do |part, index|
          break if model_name_from_path_part(part.split(".").first) == model_name
          @contexts << (part.to_i > 0 ? @contexts.pop.to_s.singularize.to_sym : part.underscore.to_sym)
        end
        @contexts
      end
      
      private
        def contexts_url_parts
          return @contexts_url_parts if @contexts_url_parts
          path_parts = request.path.split("/")
          path_parts.shift
          @contexts_url_parts = []
          path_parts.each_with_index do |part, index|
            break if model_name_from_path_part(part.split(".").first) == model_name
            if part.to_i > 0
              @contexts_url_parts << [route_name_from_path_part(@contexts_url_parts.pop), part.to_i]
            else
              @contexts_url_parts << part.underscore.to_sym
            end
          end
          @contexts_url_parts
        end
    end
  end
end