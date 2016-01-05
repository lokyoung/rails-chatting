module NotificationService

  def self.deal_with_join_request(params, current_user, notification_params)
    room = Room.find(params[:id])
    Notification.create_join_request(notification_params, room, current_user)
  end

  def self.deal_with_accept_request(params, current_user)
    notification = Notification.find(params[:id])
    ActiveRecord::Base.transaction do
      notification.update_attributes!(solved: true)
      # 邀请用户加入房间
      user = nil
      if notification.invite_request?
        user = notification.recipient
        Notification.create_accept_invite(notification, current_user)
      elsif notification.join_request?
        #接受用户申请加入房间的请求
        user = notification.actor
        Notification.create_accept_join(notification, current_user)
      end
      # 将用户加入房间
      room = notification.notifiable
      room << user
    end
    return notification
  end

  def self.deal_with_reject_request(params, current_user)
    notification = Notification.find(params[:id])
    ActiveRecord::Base.transaction do
      notification.update_attributes!(solved: true)
      if notification.invite_request?
        Notification.create_reject_invite(notification, current_user)
      elsif notification.join_request?
        Notification.create_reject_join(notification, current_user)
      end
    end
    return notification
  end

end
