class User < ApplicationRecord
  validates_presence_of :name, :email, :password, :password_confirmation
  has_secure_password
  #has_many :rooms, dependent: :destroy
  has_and_belongs_to_many :rooms
end
