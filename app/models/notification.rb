class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(unread: true) }
  after_create_commit { NotificationBroadcastJob.perform_later self }
end
