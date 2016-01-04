class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(unread: true) }
  after_create_commit { NotificationBroadcastJob.perform_later self }
  enum n_type: [:normal_notice, :join_request, :invite_request]

  def self.create_join_request(notification_params, room, current_user)
    create!(notification_params.merge(title: "Join request to your room #{room.name}",
                                  actor_id: current_user.id,
                                  recipient_id: room.owner_id,
                                  notifiable: room,
                                  n_type: "join_request"))
  end

  def self.create_invite_request(room, recipient, current_user)
    create!(title: "Room invite",
            content: "Request to invite you to join room #{room.name}",
            actor_id: current_user.id,
            recipient_id: recipient.id,
            notifiable: room,
            n_type: "invite_request")
  end

  def self.create_remove_member(room, recipient, current_user)
    create!(title: "Room kick off",
            content: "You have been kick off from room #{room.name}",
            actor_id: current_user.id,
            recipient_id: recipient.id,
            notifiable: room,
            solved: true)
  end

  def self.create_accept_invite(notification, current_user)
    create!(title: 'Accept to join your room',
            content: "Request to invite #{notification.recipient.name} to join room #{notification.notifiable.name} accept",
            actor_id: current_user.id,
            recipient_id: notification.actor.id,
            notifiable: notification.notifiable,
            solved: true)
  end

  def self.create_accept_join(notification, current_user)
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

  def self.create_reject_join(notification, current_user)
    create!(title: 'Reject',
            content: "Request to join room #{notification.notifiable.name} reject",
            actor_id: current_user.id,
            recipient_id: notification.actor_id,
            notifiable: notification.notifiable,
            solved: true)
  end
end
