class Admin::TypesController < Admin::BaseController
  before_action :set_type, only: [ :edit, :update, :destroy ]

  def index
    @types = Type.order(:name)
  end

  def new
    @type = Type.new
  end

  def create
    @type = Type.new(type_params)
    if @type.save
      redirect_to admin_types_path, notice: "Type created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @type.update(type_params)
      redirect_to admin_types_path, notice: "Type updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @type.destroy
    redirect_to admin_types_path, notice: "Type deleted."
  end

  private

  def set_type
    @type = Type.find(params[:id])
  end

  def type_params
    params.require(:type).permit(:name)
  end
end
