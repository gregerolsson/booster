class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    render :text => 'Happy speccing', :layout => 'application'
  end
end
