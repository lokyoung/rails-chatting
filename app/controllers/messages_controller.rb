class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params.merge(user_id: current_user.id))
    if @message.save

    else
      redirect_to @room
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
