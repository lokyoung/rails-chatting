class RoomsController < ApplicationController
  before_action :room_members, only: [:show]

  def index
    @rooms = Room.page params[:page]
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.page(params[:page])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params.merge(owner_id: current_user.id))
    @rooms = Room.page params[:page]
    if @room.save
      flash[:success] = "Create room suceess"
      user_ids = []
      user_ids << current_user.id
      @room.user_ids = user_ids
      respond_to do |format|
        format.html { redirect_to rooms_url }
        format.js
      end
    else
      render 'new'
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:success] = 'Room has been destory'
    @rooms = Room.page(params[:page])
    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.js
    end
  end

  def add_member
    @room = Room.find(params[:id])
    @user = User.find(params[:user_id])
    Notification.create!(title: "Room invite", content: "Request to invite you to join room #{@room.name}", actor_id: current_user.id, recipient_id: @user.id, notifiable: @room)
    flash[:success] = 'Please wait for accept'
    respond_to do |format|
      format.html { redirect_to @room }
      format.js
    end
  end

  def remove_member
    @room = Room.find(params[:id])
    @user = User.find(params[:user_id])
    user_ids = @room.user_ids
    user_ids.delete @user.id
    @room.user_ids = user_ids
    # send notification to the user
    Notification.create!(title: "Room kick off", content: "You have been kick off from room #{@room.name}", actor_id: current_user.id, recipient_id: @user.id, notifiable: @room, solved: true)
    respond_to do |format|
      format.html { redirect_to @room }
      format.js
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

  def room_members
    room = Room.find(params[:id])
    unless room.users.include?(current_user)
      flash[:warning] = 'You are not the member of the room.'
      redirect_to rooms_url
    end
  end

end
