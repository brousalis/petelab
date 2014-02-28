class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action
  
  def auth
    auth = Pusher[params[:channel_name]].authenticate(params[:socket_id])
    render :text => params[:callback] + "(" + auth.to_json + ")"
  end
end
