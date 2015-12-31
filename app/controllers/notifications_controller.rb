class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.page(params[:page])
  end

  def join_room_request
    @room = Room.find(params[:id])
    @notification = Notification.new(notification_params.merge(title: "Join request to your room #{@room.name}", actor_id: current_user.id, recipient_id: @room.owner_id, notifiable: @room, n_type: "join_request"))
    if @notification.save
      flash[:success] = 'Please wait for accepet.'
    end
    respond_to do |format|
      format.js
    end
  end

  #def approve_join_request
  #@notification = Notification.find_by(id: params[:id])
  #@notification.update_attributes(solved: true)
  #@room = Room.find_by(id: @notification.notifiable.id)
  #@user = User.find_by(id: @notification.actor_id)
  #user_ids = @room.user_ids
  #user_ids << @user.id
  #@room.user_ids = user_ids
  #Notification.create!(title: "Accept",
  #content: "Request to join room #{@notification.notifiable.name} accept",
  #actor_id: current_user.id,
  #recipient_id: @notification.actor.id,
  #notifiable: @notification.notifiable,
  #solved: true)
  #respond_to do |format|
  #format.js
  #end
  #end

  #def disapprove_join_request
  #@notification = Notification.find_by(id: params[:id])
  #@notification.update_attributes(solved: true)
  #recipient = @notification.actor
  #Notification.create!(title: "Reject",
  #content: "Request to join room #{@notification.notifiable.name} reject",
  #actor_id: current_user.id,
  #recipient_id: recipient.id,
  #notifiable: @notification.notifiable,
  #solved: true)
  #respond_to do |format|
  #format.js
  #end
  #end

  #def accept_invite_request
  #@notification = Notification.find_by(id: params[:id])
  #@notification.update_attributes(solved: true)
  #@room = Room.find_by(id: @notification.notifiable.id)
  #@user = User.find_by(id: @notification.recipient_id)
  #user_ids = @room.user_ids
  #user_ids << @user.id
  #@room.user_ids = user_ids
  #Notification.create!(title: "Accept to join your room",
  #content: "Request to invite #{@notification.recipient.name} to join room #{@notification.notifiable.name} accept",
  #actor_id: current_user.id, recipient_id: @notification.actor.id,
  #notifiable: @notification.notifiable,
  #solved: true)
  #respond_to do |format|
  #format.js
  #end
  #end

  #def reject_invite_request
  #@notification = Notification.find_by(id: params[:id])
  #@notification.update_attributes(solved: true)
  #Notification.create!(title: "Reject to join your room",
  #content: "Request to invite #{@notification.recipient.name} to join room #{@notification.notifiable.name} is rejected",
  #actor_id: current_user.id,
  #recipient_id: @notification.actor.id,
  #notifiable: @notification.notifiable,
  #solved: true)
  #respond_to do |format|
  #format.js
  #end
  #end

  def accept_request
    @notification = Notification.find_by(id: params[:id])
    @notification.update_attributes(solved: true)
    @room = Room.find_by(id: @notification.notifiable.id)
    # 邀请用户加入房间
    if @notification.n_type == "invite_request"
      @user = User.find_by(id: @notification.recipient_id)
      Notification.create!(title: "Accept to join your room",
                           content: "Request to invite #{@notification.recipient.name} to join room #{@notification.notifiable.name} accept",
                           actor_id: current_user.id, recipient_id: @notification.actor.id,
                           notifiable: @notification.notifiable,
                           solved: true)
    elsif @notification.n_type == "join_request"
      #接受用户申请加入房间的请求
      @user = User.find_by(id: @notification.actor_id)
      Notification.create!(title: "Accept",
                           content: "Request to join room #{@notification.notifiable.name} accept",
                           actor_id: current_user.id,
                           recipient_id: @notification.actor.id,
                           notifiable: @notification.notifiable,
                           solved: true)
    end
    user_ids = @room.user_ids
    user_ids << @user.id
    @room.user_ids = user_ids
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  def reject_request
    @notification = Notification.find_by(id: params[:id])
    @notification.update_attributes(solved: true)
    recipient = @notification.actor
    if @notification.n_type == "invite_request"
      Notification.create!(title: "Reject to join your room",
                           content: "Request to invite #{@notification.recipient.name} to join room #{@notification.notifiable.name} is rejected",
                           actor_id: current_user.id,
                           recipient_id: recipient.id,
                           notifiable: @notification.notifiable,
                           solved: true)
    elsif @notification.n_type == "join_request"
      Notification.create!(title: "Reject",
                           content: "Request to join room #{@notification.notifiable.name} reject",
                           actor_id: current_user.id,
                           recipient_id: recipient.id,
                           notifiable: @notification.notifiable,
                           solved: true)
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
