class ApplicationController < ActionController::Base

  def current_app
    @current_app = App.find(params[:app_id])
  end
end
