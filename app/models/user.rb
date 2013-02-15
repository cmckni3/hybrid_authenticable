# app/models/user.rb

class User < ActiveRecord::Base
  devise :hybrid_authenticatable, :password_encryptable, :rememberable, :trackable

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :override_ldap

  validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true, :if => lambda { |user| user.override_ldap == true }
end