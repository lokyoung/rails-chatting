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
    if RoomService.deal_with_create_room(room_params, current_user)
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
    RoomService.deal_with_destroy_room
    flash[:success] = 'Room has been destory'
    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.js
    end
  end

  def add_member
    @room = RoomService.deal_with_add_member(params, current_user)
    flash[:success] = 'Please wait for accept'
    respond_to do |format|
      format.html { redirect_to @room }
      format.js
    end
  end

  def remove_member
    @room = RoomService.deal_with_remove_member(params, current_user)
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
