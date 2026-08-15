class Admin::TypeEffectivenessesController < Admin::BaseController
  before_action :set_type_effectiveness, only: [ :edit, :update, :destroy ]
  before_action :set_types, only: [ :new, :edit, :create, :update ]

  def index
    @type_effectivenesses = TypeEffectiveness.includes(:attacking_type, :defending_type)
                                              .order("types.name" => :asc)
                                              .joins(:attacking_type)
  end

  def new
    @type_effectiveness = TypeEffectiveness.new
  end

  def create
    @type_effectiveness = TypeEffectiveness.new(type_effectiveness_params)
    if @type_effectiveness.save
      redirect_to admin_type_effectivenesses_path, notice: "Type effectiveness created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @type_effectiveness.update(type_effectiveness_params)
      redirect_to admin_type_effectivenesses_path, notice: "Type effectiveness updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @type_effectiveness.destroy
    redirect_to admin_type_effectivenesses_path, notice: "Type effectiveness deleted."
  end

  private

  def set_type_effectiveness
    @type_effectiveness = TypeEffectiveness.find(params[:id])
  end

  def set_types
    @types = Type.order(:name)
  end

  def type_effectiveness_params
    params.require(:type_effectiveness).permit(:attacking_type_id, :defending_type_id, :multiplier)
  end
end
