class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params.merge(user_id: current_user.id))
    if @message.save
      ActionCable.server.broadcast "room_channel_#{@room.id}", message: render_message(@message)
      redirect_to @room
    else
      redirect_to @room
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
