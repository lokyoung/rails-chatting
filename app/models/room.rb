class Room < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :messages
  validates_presence_of :name
end
