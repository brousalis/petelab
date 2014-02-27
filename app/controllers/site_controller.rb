class SiteController < ApplicationController
  def slave
    #redirect_to "/slave?pks=#{Pusher.key}" unless params[:pks] 
  end

  def master 
    #redirect_to "/master?pk=#{Pusher.key}" unless params[:pk] 
  end
end
