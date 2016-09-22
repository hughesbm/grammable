class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_error(status)
    render plain: "#{status.to_s.titleize}. :(", status: status
  end

end
