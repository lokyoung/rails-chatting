# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"

    room_ids.each do |room_id|
      #stream_from "room_channel_#{room_id}_user_#{current_user.id}"
      stream_from "room:#{room_id}"
    end

    # stream_from "room:#{params[:room_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    #ActionCable.server.broadcast 'room_channel', message: data['message']
  end

  private

  def room_ids
    current_user.room_ids
  end
end
