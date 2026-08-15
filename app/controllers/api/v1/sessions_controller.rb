class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  private

  # No flash messages on a JSON API — there's no page to render them on.
  def set_flash_message!(*)
  end

  def respond_with(resource, _opts = {})
    render json: { trainer: trainer_json(resource) }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end

  def trainer_json(trainer)
    { id: trainer.id, email: trainer.email, name: trainer.name }
  end
end
