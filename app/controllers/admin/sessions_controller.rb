class Admin::SessionsController < Admin::BaseController
  skip_before_action :authenticate_admin_user!, only: [ :new, :create ]

  def new
  end

  def create
    admin_user = AdminUser.find_by(email: params[:admin_user][:email])
    if admin_user&.valid_password?(params[:admin_user][:password])
      sign_in(:admin_user, admin_user)
      redirect_to admin_root_path, notice: "Signed in."
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(:admin_user)
    redirect_to new_admin_user_session_path, notice: "Signed out."
  end
end
