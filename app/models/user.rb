class User < ApplicationRecord
  include LetterAvatar::AvatarHelper

  validates_presence_of :name, :email, :password, :password_confirmation
  has_secure_password
  #has_many :rooms, dependent: :destroy
  has_and_belongs_to_many :rooms
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  def username_for_avatar
    Pinyin.t(self.name)
  end

  def avatar_url
    letter_avatar_for(username_for_avatar, 200).sub('public/', '/')
  end
end
