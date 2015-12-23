class RoomsController < ApplicationController
  before_action :room_members, only: [:show]

  def index
    @rooms = Room.page params[:page]
  end

  def show
    @room = Room.find(params[:id])
    @messages = Message.page params[:page]
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params.merge(owner_id: current_user.id))
    if @room.save
      user_ids = []
      user_ids << current_user.id
      @room.user_ids = user_ids
      redirect_to rooms_url
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

  def add_member
    @room = Room.find(params[:id])
    @user = User.find(params[:user_id])
    user_ids = @room.user_ids
    user_ids << @user.id
    @room.user_ids = user_ids
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
