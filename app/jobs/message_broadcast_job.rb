class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    # ActionCable.server.broadcast "room:#{message.room.id}", message: render_my_message(message)

    message.room.user_ids.each do |user_id|
      if user_id == message.user.id
        ActionCable.server.broadcast "room_channel_#{message.room.id}_user_#{user_id}", message: render_my_message(message)
      else
        ActionCable.server.broadcast "room_channel_#{message.room.id}_user_#{user_id}", message: render_message(message)
      end
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/other_user_message', locals: { message: message })
  end

  def render_my_message(message)
    ApplicationController.renderer.render(partial: 'messages/current_user_message', locals: { message: message })
  end
end
