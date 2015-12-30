class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    ActionCable.server.broadcast "notification:#{notification.recipient_id}", { body: notification.recipient.notifications.unread.count.to_s }
  end
end
