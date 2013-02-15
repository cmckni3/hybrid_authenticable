# lib/hybrid_authenticatable/models/hybrid_authenticatable.rb

require 'devise'

require 'strategy'
require 'models/hybrid_authenticatable'
require 'models/password_encryptable'

module HybridAuthenticatable
end

Devise.add_module(:hybrid_authenticatable,
                  :route => :session,
                  :strategy => true,
                  :controller => :sessions,
                  :model => 'models/hybrid_authenticatable')
                  
Devise.add_module(:password_encryptable,
                  :route => :session,
                  :strategy => false,
                  :controller => :sessions,
                  :model => 'models/password_encryptable')