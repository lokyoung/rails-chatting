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
      @room << current_user
      respond_to do |format|
        format.html { redirect_to rooms_url }
        format.js
      end
    else
      render 'new'
    end
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
    Notification.create_invite_request(@room, @user, current_user)
    flash[:success] = 'Please wait for accept'
    respond_to do |format|
      format.html { redirect_to @room }
      format.js
    end
  end

  def remove_member
    @room = Room.find(params[:id])
    @user = User.find(params[:user_id])
    ActiveRecord::Base.transcation do
      @room.delete(@user)
      # send notification to the user
      Notification.create_remove_member(@room, @user, current_user)
    end
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
