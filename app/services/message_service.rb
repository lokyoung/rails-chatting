module MessageService
  def self.deal_with_create_message(params, current_user)
    room = Room.find(params[:room_id])
    message = room.messages.new(message_params.merge(user_id: current_user.id))
    message.save
  end
end
