class Admin::BaseController < ActionController::Base
  layout "admin"
  protect_from_forgery with: :exception

  before_action :authenticate_admin_user!
end
