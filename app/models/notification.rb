class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(unread: true) }
  after_create_commit { NotificationBroadcastJob.perform_later self }
  enum n_type: [:normal_notice, :join_request, :invite_reuqest]

  def self.create_accept_invite(notification, current_user)
    create!(title: 'Accept to join your room',
            content: "Request to invite #{notification.recipient.name} to join room #{notification.notifiable.name} accept",
            actor_id: current_user.id, recipient_id: notification.actor.id,
            notifiable: notification.notifiable,
            solved: true)
  end

  def self.create_accept_join(_notification, current_user)
    create!(title: 'Accept',
            content: "Request to join room #{notification.notifiable.name} accept",
            actor_id: current_user.id,
            recipient_id: notification.actor.id,
            notifiable: notification.notifiable,
            solved: true)
  end

  def self.create_reject_invite(notification, current_user)
    create!(title: 'Reject to join your room',
            content: "Request to invite #{notification.recipient.name} to join room #{notification.notifiable.name} is rejected",
            actor_id: current_user.id,
            recipient_id: notification.actor_id,
            notifiable: notification.notifiable,
            solved: true)
  end

  def self.create_reject_join(_notification, current_user)
    create!(title: 'Reject',
            content: "Request to join room #{@notification.notifiable.name} reject",
            actor_id: current_user.id,
            recipient_id: recipient.id,
            notifiable: @notification.notifiable,
            solved: true)
  end
end
