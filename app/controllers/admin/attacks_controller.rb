class Admin::AttacksController < Admin::BaseController
  before_action :set_attack, only: [ :edit, :update, :destroy ]

  def index
    @attacks = Attack.order(:name)
  end

  def new
    @attack = Attack.new
  end

  def create
    @attack = Attack.new(attack_params)
    if @attack.save
      redirect_to admin_attacks_path, notice: "Attack created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @attack.update(attack_params)
      redirect_to admin_attacks_path, notice: "Attack updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @attack.destroy
    redirect_to admin_attacks_path, notice: "Attack deleted."
  end

  private

  def set_attack
    @attack = Attack.find(params[:id])
  end

  def attack_params
    params.require(:attack).permit(:name)
  end
end
