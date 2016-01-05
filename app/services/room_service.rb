module RoomService

  def self.deal_with_create_room(room_params, current_user)
    room = Room.new(room_params.merge(owner_id: current_user.id))
    room.save
  end

  def self.deal_with_destroy_room(params)
    room = Room.find(params[:id])
    room.destroy
  end

  def self.deal_with_add_member(params, current_user)
    room = Room.find(params[:id])
    user = User.find(params[:user_id])
    Notification.create_invite_request(room, user, current_user)
    return room
  end

  def self.deal_with_remove_member(params, current_user)
    room = Room.find(params[:id])
    user = User.find(params[:user_id])
    ActiveRecord::Base.transcation do
      room.delete(user)
      # send notification to the user
      Notification.create_remove_member(room, user, current_user)
    end
    return room
  end

end
