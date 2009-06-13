module Resourcelogic
  # This module let's you define various aliases for your controller. For example,
  # lets say you have the following routes:
  #
  #   /account/addresses        => UsersController
  #   /admin/users/5/addresses  => UsersController
  #
  # Here is how your AddressesController would look:
  #
  #   class AddressesController < ResourceController
  #     belongs_to :user
  #   end
  #
  # The problem is that sometimes the parent object is called user, sometimes its
  # called account. So the solution is to do:
  #
  #   class ResourceController < ApplicationController
  #     route_alias :account, :user
  #   end
  #
  # Now ResourceLogic knows that when it see account in the URL it will know the grab
  # the User model.
  #
  # Now I know an alternative could be to do somethig like:
  #
  #   belongs_to :user, :alias => :account
  #
  # The above presents a problem. Take the following URL:
  #
  #   /productos/1/pictures/4/comments
  #
  # In order for Resourcelogic to do its magic relative URLs, it needs to know what
  # model "productos" should be using. Which should be the Product model, yet we
  # can't define that in the CommentsController because it's 2 levels above, and we
  # only specify the parent.
  #
  # Now a lot of people say you should never nest more than 2 levels deep, and this
  # is absolutely true 95% of the time. But what if I want to link back to the parent
  # object from the comments controller and preserve it's context? In order to do
  # this I have to go 3 levels deep, because maybe context for the PicturesController
  # is really important / required. The only way to preserve context is with the URL.
  #
  # Sorry for rambling, this documentation is really more of an internal note for me
  # and to hopefully clarify why I took this approach.
  module Aliases
    def self.included(klass)
      klass.class_eval do
        extend Config
        include InstanceMethods
      end
    end
    
    module Config
      def path_alias(alias_name, model_name)
        current_aliases = path_aliases
        model_name = model_name.to_sym
        current_aliases[model_name] ||= []
        current_aliases[model_name] << alias_name.to_sym
        write_inheritable_attribute(:path_aliases, current_aliases)
      end

      def path_aliases
        read_inheritable_attribute(:path_aliases) || {}
      end
      
      def route_alias(alias_name, model_name)
        current_aliases = route_aliases
        model_name = model_name.to_sym
        current_aliases[model_name] ||= []
        current_aliases[model_name] << alias_name.to_sym
        write_inheritable_attribute(:route_aliases, current_aliases)
      end

      def route_aliases
        read_inheritable_attribute(:route_aliases) || {}
      end
    end
    
    module InstanceMethods
      private
        def model_name_from_route_alias(alias_name)
          route_aliases.each do |model_name, aliases|
            return model_name if aliases.include?(alias_name.to_sym)
          end
          nil
        end
      
        def route_aliases
          self.class.route_aliases
        end
        
        def model_name_from_path_alias(alias_name)
          path_aliases.each do |model_name, aliases|
            return model_name if aliases.include?(alias_name.to_sym)
          end
          nil
        end
      
        def path_aliases
          self.class.path_aliases
        end
        
        def possible_model_names(model_name)
          [model_name] + (route_aliases[model_name] || []) + (path_aliases[model_name] || [])
        end
        
        # The point of this method is to determine what the part of a url is really referring to.
        # For example, let's say you did this:
        #
        #   map.resources :users, :as => :accounts
        #
        # Resource logic looks at the request.path. It's going to see "accounts" in the urls. How
        # is it to know that by "accounts" you are referring to the "users" resource. That's the
        # point of this method, to say "hey, accounts is mapped to users".
        def model_name_from_path_part(part)
          part = part.to_s.singularize
          model_name_from_route_alias(part) || model_name_from_path_alias(part) || part.to_sym
        end
        
        # The point of this method is to determine the name used in the route method. For example,
        # let's say you did this:
        #
        #   map.resources :accounts, :controller => "users"
        #
        # You would want to use "account" in your path and url helper, not "user".
        def route_name_from_path_part(part)
          part = part.to_s.singularize
          model_name = model_name_from_path_alias(part)
          return model_name if model_name
          part.to_sym
        end
    end
  end
end