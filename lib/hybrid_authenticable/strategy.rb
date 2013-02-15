# lib/hybrid_authenticatable/strategy.rb

require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class HybridAuthenticatable < Authenticatable

      def authenticate!
        # resource = mapping.to.find_for_authentication(authentication_hash)
        resource = mapping.to.where("username = ?", authentication_hash[:username]).limit(1).first || mapping.to.where("email = ?", authentication_hash[:username]).limit(1).first
        return fail(:invalid) if resource.nil? || !valid_password?

        if resource.override_ldap == true
          mapping.to.send(:extend, Devise::Models::DatabaseAuthenticatable::ClassMethods)
          mapping.to.send(:include, Devise::Models::DatabaseAuthenticatable)

          return fail(:invalid) unless resource.valid_password?(password)
        else
          mapping.to.send(:include, Devise::Models::LdapAuthenticatable)
          return fail(:invalid) unless resource.valid_ldap_authentication?(password)
        end

        if validate(resource)
          success!(resource)
        else
          return fail(:invalid)
        end
      end
    end
  end
end

Warden::Strategies.add(:hybrid_authenticatable, Devise::Strategies::HybridAuthenticatable)