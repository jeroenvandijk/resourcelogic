# Nested and Polymorphic Resource Helpers
#
module Resourcelogic
  module SubViews
    def self.included(klass)
      klass.class_eval do
        extend Config
        add_acts_as_resource_module(Methods)
      end
    end
    
    module Config
      def namespace_views_by_context(value = nil)
        rw_config(:namespace_views_by_context, value)
      end

      def namespace_views_by_context?
        !namespace_views_by_context.blank?
      end
      
      def namespace_views_by_route_alias(value = nil)
        rw_config(:namespace_views_by_route_alias, value)
      end

      def namespace_views_by_route_alias?
        !namespace_views_by_route_alias.blank?
      end
    end
    
    module Methods
      def self.included(klass)
        klass.helper_method :namespace_views_by_route_alias, :namespace_views_by_route_alias?,
          :namespace_views_by_context, :namespace_views_by_context?, :sub_template_name
      end
      
      private
        def namespace_views_by_context?
          self.class.namespace_views_by_context?
        end
        
        def namespace_views_by_context
          self.class.namespace_views_by_context
        end
        
        def namespace_views_by_route_alias?
          self.class.namespace_views_by_route_alias? && route_name != model_name
        end
        
        def namespace_views_by_route_alias
          self.class.namespace_views_by_route_alias
        end
        
        def sub_template_name(name)
          path_parts = [controller_name]
          
          if namespace_views_by_context?
            context_folder_name = namespace_views_by_context.is_a?(Hash) && namespace_views_by_context.key?(context) ?
              namespace_views_by_context[context] : context
            path_parts << (context_folder_name || "root")
          end
          
          if namespace_views_by_route_alias?
            route_alias_folder_name = namespace_views_by_route_alias.is_a?(Hash) && namespace_views_by_route_alias.key?(route_name) ?
              namespace_views_by_route_alias[route_name] : route_name
            path_parts << (route_alias_folder_name).to_s.pluralize
          end
          
          path_parts << name
          path_parts.join("/")
        end
        
        def default_template_name(action_name = self.action_name)
          if namespace_views_by_context? || namespace_views_by_route_alias?
            sub_template_name(action_name)
          else
            super
          end
        end
    end
    
    module Partials
      def _pick_partial_template(partial_path)
        if respond_to?(:namespace_views_by_context?) && respond_to?(:namespace_views_by_route_alias?) &&
          (namespace_views_by_context? || namespace_views_by_route_alias?) && !partial_path.include?("/")
          partial_path = sub_template_name(partial_path)
        end
        super
      end
    end
  end
end


module ActionView
  class Base
    include Resourcelogic::SubViews::Partials
  end
end