class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  # No flash messages on a JSON API — there's no page to render them on.
  def set_flash_message!(*)
  end

  def sign_up_params
    params.require(:trainer).permit(:email, :password, :password_confirmation, :name)
  end

  def account_update_params
    params.require(:trainer).permit(:email, :password, :password_confirmation, :current_password, :name)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { trainer: trainer_json(resource) }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def trainer_json(trainer)
    { id: trainer.id, email: trainer.email, name: trainer.name }
  end
end
