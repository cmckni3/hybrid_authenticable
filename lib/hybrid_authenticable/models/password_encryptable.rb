# lib/hybrid_authenticatable/models/password_encryptable.rb

require 'bcrypt'

module Devise
  module Models
    module PasswordEncryptable
      extend ActiveSupport::Concern
      
      included do
        attr_reader :password, :current_password
        attr_accessor :password_confirmation
      end
      
      def self.required_fields(klass)
        [:encrypted_password] + klass.authentication_keys
      end
      
      # Generates password encryption based on the given value.
      def password=(new_password)
        @password = new_password
        self.encrypted_password = password_digest(@password) if @password.present?
      end
      
      # A reliable way to expose the salt regardless of the implementation.
      def authenticatable_salt
        encrypted_password[0,29] if encrypted_password
      end
      
      protected

      # Digests the password using bcrypt.
      def password_digest(password)
        ::BCrypt::Password.create("#{password}#{self.class.pepper}", :cost => self.class.stretches).to_s
      end
      
      module ClassMethods
        Devise::Models.config(self, :pepper, :stretches)
      end
    end
  end
end