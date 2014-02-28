class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  after_action { expires_now }

end
