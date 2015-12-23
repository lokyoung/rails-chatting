class Room < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :messages, dependent: :destroy
  validates_presence_of :name
  belongs_to :owner
end
