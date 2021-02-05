class ApplicationController < ActionController::Base
  before_action :authenticate_user!


  protected

  def authenticate_admin_user!
    raise 'no entry' unless current_user.admin?
  end
end
