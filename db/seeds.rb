# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Seeds a representative subset of the Gen 1 & 2 Pokedex (not the full 251) — enough to exercise
# every type, several dual-type combos, and evolution lines, without hand-typing all 251 entries
# from memory at high risk of small inaccuracies.

TYPE_NAMES = %w[
  Normal Fire Water Electric Grass Ice Fighting Poison Ground Flying
  Psychic Bug Rock Ghost Dragon Dark Steel
].freeze

# Classic (pre-Fairy, Gen 2-era) type chart. Only non-1x multipliers are stored;
# any (attacker, defender) pair absent here is treated as 1x (normal) elsewhere.
TYPE_EFFECTIVENESS = {
  "Normal" => { "Rock" => 0.5, "Ghost" => 0, "Steel" => 0.5 },
  "Fire" => { "Fire" => 0.5, "Water" => 0.5, "Grass" => 2, "Ice" => 2, "Bug" => 2, "Rock" => 0.5, "Dragon" => 0.5, "Steel" => 2 },
  "Water" => { "Fire" => 2, "Water" => 0.5, "Grass" => 0.5, "Ground" => 2, "Rock" => 2, "Dragon" => 0.5 },
  "Electric" => { "Water" => 2, "Electric" => 0.5, "Grass" => 0.5, "Ground" => 0, "Flying" => 2, "Dragon" => 0.5 },
  "Grass" => { "Fire" => 0.5, "Water" => 2, "Grass" => 0.5, "Poison" => 0.5, "Ground" => 2, "Flying" => 0.5, "Bug" => 0.5, "Rock" => 2, "Dragon" => 0.5, "Steel" => 0.5 },
  "Ice" => { "Fire" => 0.5, "Water" => 0.5, "Grass" => 2, "Ice" => 0.5, "Ground" => 2, "Flying" => 2, "Dragon" => 2, "Steel" => 0.5 },
  "Fighting" => { "Normal" => 2, "Ice" => 2, "Poison" => 0.5, "Flying" => 0.5, "Psychic" => 0.5, "Bug" => 0.5, "Rock" => 2, "Ghost" => 0, "Dark" => 2, "Steel" => 2 },
  "Poison" => { "Grass" => 2, "Poison" => 0.5, "Ground" => 0.5, "Rock" => 0.5, "Ghost" => 0.5, "Steel" => 0 },
  "Ground" => { "Fire" => 2, "Electric" => 2, "Grass" => 0.5, "Poison" => 2, "Flying" => 0, "Bug" => 0.5, "Rock" => 2, "Steel" => 2 },
  "Flying" => { "Electric" => 0.5, "Grass" => 2, "Fighting" => 2, "Bug" => 2, "Rock" => 0.5, "Steel" => 0.5 },
  "Psychic" => { "Fighting" => 2, "Poison" => 2, "Psychic" => 0.5, "Dark" => 0, "Steel" => 0.5 },
  "Bug" => { "Fire" => 0.5, "Grass" => 2, "Fighting" => 0.5, "Poison" => 2, "Flying" => 0.5, "Ghost" => 0.5, "Steel" => 0.5, "Psychic" => 2, "Dark" => 2 },
  "Rock" => { "Fire" => 2, "Ice" => 2, "Fighting" => 0.5, "Ground" => 0.5, "Flying" => 2, "Bug" => 2, "Steel" => 0.5 },
  "Ghost" => { "Normal" => 0, "Psychic" => 2, "Ghost" => 2, "Dark" => 0.5 },
  "Dragon" => { "Dragon" => 2, "Steel" => 0.5 },
  "Dark" => { "Fighting" => 0.5, "Psychic" => 2, "Ghost" => 2, "Dark" => 0.5, "Steel" => 0.5 },
  "Steel" => { "Fire" => 0.5, "Water" => 0.5, "Electric" => 0.5, "Ice" => 2, "Rock" => 2, "Steel" => 0.5 }
}.freeze

# 4 illustrative moves per type — not a claim of canonical game-accurate learnsets.
TYPE_ATTACKS = {
  "Normal" => [ "Tackle", "Scratch", "Quick Attack", "Hyper Beam" ],
  "Fire" => [ "Ember", "Flamethrower", "Fire Fang", "Flame Wheel" ],
  "Water" => [ "Water Gun", "Bubble Beam", "Hydro Pump", "Aqua Tail" ],
  "Electric" => [ "Thundershock", "Thunderbolt", "Spark", "Thunder" ],
  "Grass" => [ "Vine Whip", "Razor Leaf", "Solar Beam", "Leech Seed" ],
  "Ice" => [ "Powder Snow", "Ice Beam", "Blizzard", "Ice Punch" ],
  "Fighting" => [ "Karate Chop", "Low Kick", "Submission", "Focus Punch" ],
  "Poison" => [ "Poison Sting", "Sludge", "Acid", "Toxic" ],
  "Ground" => [ "Sand Attack", "Dig", "Earthquake", "Bone Club" ],
  "Flying" => [ "Gust", "Wing Attack", "Peck", "Drill Peck" ],
  "Psychic" => [ "Confusion", "Psybeam", "Psychic", "Barrier" ],
  "Bug" => [ "String Shot", "Bug Bite", "X-Scissor", "Leech Life" ],
  "Rock" => [ "Rock Throw", "Rock Slide", "Rollout", "Stone Edge" ],
  "Ghost" => [ "Lick", "Night Shade", "Shadow Ball", "Curse" ],
  "Dragon" => [ "Dragon Rage", "Dragon Claw", "Twister", "Outrage" ],
  "Dark" => [ "Bite", "Crunch", "Feint Attack", "Pursuit" ],
  "Steel" => [ "Metal Claw", "Iron Tail", "Flash Cannon", "Iron Head" ]
}.freeze

# [national_dex_number, name, generation, [type1, type2_or_nil]]
POKEMON = [
  [ 1, "Bulbasaur", 1, [ "Grass", "Poison" ] ],
  [ 4, "Charmander", 1, [ "Fire", nil ] ],
  [ 6, "Charizard", 1, [ "Fire", "Flying" ] ],
  [ 7, "Squirtle", 1, [ "Water", nil ] ],
  [ 9, "Blastoise", 1, [ "Water", nil ] ],
  [ 16, "Pidgey", 1, [ "Normal", "Flying" ] ],
  [ 19, "Rattata", 1, [ "Normal", nil ] ],
  [ 25, "Pikachu", 1, [ "Electric", nil ] ],
  [ 26, "Raichu", 1, [ "Electric", nil ] ],
  [ 37, "Vulpix", 1, [ "Fire", nil ] ],
  [ 41, "Zubat", 1, [ "Poison", "Flying" ] ],
  [ 54, "Psyduck", 1, [ "Water", nil ] ],
  [ 58, "Growlithe", 1, [ "Fire", nil ] ],
  [ 63, "Abra", 1, [ "Psychic", nil ] ],
  [ 66, "Machop", 1, [ "Fighting", nil ] ],
  [ 69, "Bellsprout", 1, [ "Grass", "Poison" ] ],
  [ 74, "Geodude", 1, [ "Rock", "Ground" ] ],
  [ 81, "Magnemite", 1, [ "Electric", "Steel" ] ],
  [ 92, "Gastly", 1, [ "Ghost", "Poison" ] ],
  [ 95, "Onix", 1, [ "Rock", "Ground" ] ],
  [ 104, "Cubone", 1, [ "Ground", nil ] ],
  [ 109, "Koffing", 1, [ "Poison", nil ] ],
  [ 113, "Chansey", 1, [ "Normal", nil ] ],
  [ 123, "Scyther", 1, [ "Bug", "Flying" ] ],
  [ 127, "Pinsir", 1, [ "Bug", nil ] ],
  [ 129, "Magikarp", 1, [ "Water", nil ] ],
  [ 130, "Gyarados", 1, [ "Water", "Flying" ] ],
  [ 131, "Lapras", 1, [ "Water", "Ice" ] ],
  [ 133, "Eevee", 1, [ "Normal", nil ] ],
  [ 143, "Snorlax", 1, [ "Normal", nil ] ],
  [ 147, "Dratini", 1, [ "Dragon", nil ] ],
  [ 149, "Dragonite", 1, [ "Dragon", "Flying" ] ],
  [ 150, "Mewtwo", 1, [ "Psychic", nil ] ],
  [ 151, "Mew", 1, [ "Psychic", nil ] ],
  [ 152, "Chikorita", 2, [ "Grass", nil ] ],
  [ 155, "Cyndaquil", 2, [ "Fire", nil ] ],
  [ 158, "Totodile", 2, [ "Water", nil ] ],
  [ 161, "Sentret", 2, [ "Normal", nil ] ],
  [ 164, "Noctowl", 2, [ "Normal", "Flying" ] ],
  [ 168, "Ariados", 2, [ "Bug", "Poison" ] ],
  [ 175, "Togepi", 2, [ "Normal", nil ] ],
  [ 179, "Mareep", 2, [ "Electric", nil ] ],
  [ 185, "Sudowoodo", 2, [ "Rock", nil ] ],
  [ 198, "Murkrow", 2, [ "Dark", "Flying" ] ],
  [ 200, "Misdreavus", 2, [ "Ghost", nil ] ],
  [ 202, "Wobbuffet", 2, [ "Psychic", nil ] ],
  [ 208, "Steelix", 2, [ "Steel", "Ground" ] ],
  [ 227, "Skarmory", 2, [ "Steel", "Flying" ] ],
  [ 229, "Houndoom", 2, [ "Dark", "Fire" ] ],
  [ 248, "Tyranitar", 2, [ "Rock", "Dark" ] ],
  [ 249, "Lugia", 2, [ "Psychic", "Flying" ] ],
  [ 250, "Ho-Oh", 2, [ "Fire", "Flying" ] ]
].freeze

puts "Seeding types..."
types_by_name = TYPE_NAMES.index_with { |name| Type.find_or_create_by!(name: name) }

puts "Seeding type effectiveness..."
TYPE_EFFECTIVENESS.each do |attacker, targets|
  targets.each do |defender, multiplier|
    TypeEffectiveness.find_or_create_by!(
      attacking_type: types_by_name.fetch(attacker),
      defending_type: types_by_name.fetch(defender)
    ) { |te| te.multiplier = multiplier }
  end
end

puts "Seeding attacks..."
attacks_by_name = TYPE_ATTACKS.values.flatten.uniq.index_with { |name| Attack.find_or_create_by!(name: name) }

puts "Seeding Pokemon..."
POKEMON.each do |dex_number, name, generation, (type1_name, type2_name)|
  pokemon = Pokemon.find_or_create_by!(national_dex_number: dex_number) do |p|
    p.name = name
    p.generation = generation
    p.image_url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{dex_number}.png"
  end

  [ [ 1, type1_name ], [ 2, type2_name ] ].each do |slot, type_name|
    next if type_name.nil?

    PokemonType.find_or_create_by!(pokemon: pokemon, slot: slot) do |pt|
      pt.type = types_by_name.fetch(type_name)
    end
  end

  attack_names = if type2_name
    TYPE_ATTACKS.fetch(type1_name).first(2) + TYPE_ATTACKS.fetch(type2_name).first(2)
  else
    TYPE_ATTACKS.fetch(type1_name).first(4)
  end
  attack_names.uniq.each_with_index do |attack_name, index|
    PokemonAttack.find_or_create_by!(pokemon: pokemon, slot: index + 1) do |pa|
      pa.attack = attacks_by_name.fetch(attack_name)
    end
  end
end

puts "Seeding default trainer..."
Trainer.find_or_create_by!(email: "trainer@test.com") do |trainer|
  trainer.name = "Ash"
  trainer.password = "okokok"
  trainer.password_confirmation = "okokok"
end

puts "Done: #{Type.count} types, #{Attack.count} attacks, #{Pokemon.count} Pokemon, #{Trainer.count} trainer(s)."
