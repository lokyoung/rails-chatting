class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  helper_method :unread_notify_count

  def unread_notify_count
    return 0 if current_user.blank?
    @unread_notify_count ||= current_user.notifications.unread.count
  end
end
