class NotificationService

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def deal_with_join_request
    room = Room.find(@params[:id])
    Notification.create_join_request(notification_params, room, @current_user)
  end

  def deal_with_accept_request
    ActiveRecord::Base.transaction do
      @notification = Notification.find_by!(id: @params[:id])
      @notification.update_attributes!(solved: true)
      room = Room.find_by!(id: notification.notifiable.id)
      # 邀请用户加入房间
      if notification.invite_request?
        @user = User.find_by!(id: @notification.recipient_id)
        Notification.create_accept_invite(@notification, @current_user)
      elsif @notification.join_request?
        #接受用户申请加入房间的请求
        @user = User.find_by!(id: @notification.actor_id)
        Notification.create_accept_join(@notification, @current_user)
      end
      room << @user
    end
  end

  def deal_with_reject_request
    ActiveRecord::Base.transaction do
      @notification = Notification.find_by!(id: @params[:id])
      @notification.update_attributes!(solved: true)
      if @notification.invite_request?
        Notification.create_reject_invite(@notification, @current_user)
      elsif @notification.join_request?
        Notification.create_reject_join(@notification, @current_user)
      end
    end
    return @notification
  end

  private

  def notification_params
    @params.require(:notification).permit(:content)
  end

end
