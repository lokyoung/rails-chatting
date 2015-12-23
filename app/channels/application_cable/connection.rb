# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected
    def find_verified_user
      if verified_user = User.find_by(id: session["user_id"])
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def session
      session_key = Rails.application.config.session_options[:key]
      cookies.encrypted[session_key]
    end
  end
end
