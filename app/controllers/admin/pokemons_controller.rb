class Admin::PokemonsController < Admin::BaseController
  before_action :set_pokemon, only: [ :edit, :update, :destroy ]
  before_action :set_options, only: [ :new, :edit, :create, :update ]

  def index
    @pokemons = Pokemon.includes(:types, :attacks).order(:national_dex_number)
  end

  def new
    @pokemon = Pokemon.new
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)
    if @pokemon.save
      sync_types(@pokemon)
      sync_attacks(@pokemon)
      redirect_to admin_pokemons_path, notice: "Pokemon created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @pokemon.update(pokemon_params)
      sync_types(@pokemon)
      sync_attacks(@pokemon)
      redirect_to admin_pokemons_path, notice: "Pokemon updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pokemon.destroy
    redirect_to admin_pokemons_path, notice: "Pokemon deleted."
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end

  def set_options
    @types = Type.order(:name)
    @attacks = Attack.order(:name)
  end

  def pokemon_params
    params.require(:pokemon).permit(:name, :national_dex_number, :generation, :image_url)
  end

  def sync_types(pokemon)
    pokemon.pokemon_types.destroy_all
    [ [ 1, params[:pokemon][:primary_type_id] ], [ 2, params[:pokemon][:secondary_type_id] ] ].each do |slot, type_id|
      pokemon.pokemon_types.create!(type_id: type_id, slot: slot) if type_id.present?
    end
  end

  def sync_attacks(pokemon)
    pokemon.pokemon_attacks.destroy_all
    (1..4).each do |slot|
      attack_id = params[:pokemon]["attack_id_#{slot}"]
      pokemon.pokemon_attacks.create!(attack_id: attack_id, slot: slot) if attack_id.present?
    end
  end
end
