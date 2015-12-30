class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.page(params[:page])
  end

  def join_room
    @room = Room.find(params[:id])
    @notification = Notification.new(notification_params.merge(title: "Join request to your room #{@room.name}", actor_id: current_user.id, recipient_id: @room.owner_id, notifiable: @room))
    if @notification.save
      flash[:success] = 'Please wait for accepet.'
      respond_to do |format|
        format.html { redirect_to rooms_url }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to rooms_url }
        format.js
      end
    end
  end

  def accept_join
    @notification = Notification.find_by(id: params[:id])
    @notification.update_attributes(solved: true)
    @room = Room.find_by(id: @notification.notifiable.id)
    # 邀请用户加入房间
    if @notification.title == "Room invite"
      @user = User.find_by(id: @notification.recipient_id)
      Notification.create!(title: "Accept to join your room", content: "Request to invite #{@notification.recipient.name} to join room #{@notification.notifiable.name} accept", actor_id: current_user.id, recipient_id: @notification.actor.id, notifiable: @notification.notifiable, solved: true)
    else
      #接受用户申请加入房间的请求
      @user = User.find_by(id: @notification.actor_id)
      Notification.create!(title: "Accept", content: "Request to join room #{@notification.notifiable.name} accept", actor_id: current_user.id, recipient_id: @notification.actor.id, notifiable: @notification.notifiable, solved: true)
    end
    user_ids = @room.user_ids
    user_ids << @user.id
    @room.user_ids = user_ids
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  def reject_join
    @notification = Notification.find_by(id: params[:id])
    @notification.update_attributes(solved: true)
    recipient = @notification.actor
    if @notification.title == "Room invite"
      Notification.create!(title: "Reject to join your room", content: "Request to invite #{@notification.recipient.name} to join room #{@notification.notifiable.name} is rejected", actor_id: current_user.id, recipient_id: recipient.id, notifiable: @notification.notifiable, solved: true)
    else
      Notification.create!(title: "Reject", content: "Request to join room #{@notification.notifiable.name} reject", actor_id: current_user.id, recipient_id: recipient.id, notifiable: @notification.notifiable, solved: true)
    end
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:content)
  end

end
