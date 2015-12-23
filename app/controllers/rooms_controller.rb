class RoomsController < ApplicationController

  def index
    @rooms = Room.page params[:page]
  end

  def show
    @room = Room.find(params[:id])
    @messages = Message.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
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

  private

  def room_params
    params.require(:room).permit(:name)
  end
end
