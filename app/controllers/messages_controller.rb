class MessagesController < ApplicationController
  def create
    if MessageService.deal_with_create_message

    else
      redirect_to @room
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
