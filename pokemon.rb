# require neccesary files
require_relative "pokedex/pokemons"
require_relative "pokedex/moves"

class Pokemon
  # include neccesary modules
  include Pokedex

  attr_reader :stats

  def initialize(species, name = nil, level = nil)
    @name = name || species
    @level = level || 1

    pokemon_data = POKEMONS[species]
    @species = species
    @type = pokemon_data[:type]
    @base_exp = pokemon_data[:base_exp]
    @growth_rate = pokemon_data[:growth_rate]
    @base_stats = pokemon_data[:base_stats]
    @effort_points = pokemon_data[:effort_points]
    @moves = pokemon_data[:moves]
    @individual_stats = individual_stats
    @effort_values = effort_values
    @experience_points = initial_exp(@level)
    @stats = calc_stats

    @current_hp = nil
    @current_move = nil
  end

  def prepare_for_battle
    # Complete this
    @current_hp = @stats[:hp]
  end

  def receive_damage(damage)
    @current_hp -= damage
    @current_hp = 0 if @current_hp.negative?
  end

  def set_current_move(move)
    @current_move = MOVES[move]
  end

  def fainted?
    @current_hp.zero?
  end

  def attack(target) 
    # target es un objeto de la clase Pokemon
    # Print attack message 'Tortuguita used MOVE!'
    puts "#{@name} used #{@current_move[:name].upcase}!"
    # Accuracy check
    # If the movement is not missed
    if rand(1..100) < @current_move[:accuracy]
      # -- Calculate base damage
      is_special = SPECIAL_MOVE_TYPE.includes?(@current_move[:type])
      offensive_stat = is_special ? @stats[:special_attack] : @stats[:attack]
      target_defensive_stat = is_special ? target.stats[:special_defense] : target.stats[:defense]
      base_damage = ((((2 * @level / 5.0) + 2).floor * offensive_stat * @current_move[:power] / target_defensive_stat)
                    .floor / 50.0).floor + 2
      
    # -- Critical Hit check
    if rand(1..16) == 1
    # -- If critical, multiply base damage and print message 'It was CRITICAL hit!'
      base_damage *= 1.5
      puts "It was CRITICAL hit!"
    
    # -- Effectiveness check
    # -- Mutltiply damage by effectiveness multiplier and round down. Print message if neccesary
    # ---- "It's not very effective..." when effectivenes is less than or equal to 0.5
    # ---- "It's super effective!" when effectivenes is greater than or equal to 1.5
    # ---- "It doesn't affect [target name]!" when effectivenes is 0
    
    # -- Inflict damage to target and print message "And it hit [target name] with [damage] damage""
    else
      puts "But it MISSED!"
    end

  end

  def increase_stats(target)
    # Increase stats base on the defeated pokemon and print message "#[pokemon name] gained [amount] experience points"

    # If the new experience point are enough to level up, do it and print
    # message "#[pokemon name] reached level [level]!" # -- Re-calculate the stat
  end

  # private methods:
  # Create here auxiliary methods
  def individual_stats
    { hp: rand(0..31),
      attack: rand(0..31),
      defense: rand(0..31),
      special_attack: rand(0..31),
      special_defense: rand(0..31),
      speed: rand(0..31) }
  end

  def effort_values
    { hp: 0,
      attack: 0,
      defense: 0,
      special_attack: 0,
      special_defense: 0,
      speed: 0 }
  end

  def initial_exp(level)
    return 0 if level == 1

    case @growth_rate
    when :low
      (5 * (level**3) / 4.0).ceil
    when :medium_slow
      ((1.2 * (level**3)) - (15 * (level**2)) + (100 * level) - 140).ceil
    when :medium_fast
      level**3
    when :fast
      (0.8 * (level**3)).ceil
    end
  end

  def calc_stats
    hp = ((((2 * @base_stats[:hp]) + @individual_stats[:hp] + (@effort_values[:hp] / 4.0)
         .floor) * @level / 100) + @level + 10).floor

    {
      hp: hp,
      attack: calc_stat(:attack),
      defense: calc_stat(:defense),
      special_attack: calc_stat(:special_attack),
      special_defense: calc_stat(:special_defense),
      speed: calc_stat(:speed)
    }
  end

  def calc_stat(stat)
    ((((2 * @base_stats[stat]) + @individual_stats[stat] + (@effort_values[stat] / 4.0)
    .floor) * @level / 100) + 5).floor
  end
end

charmander = Pokemon.new("Charmander", "Colita")
# p charmander.stats
# charmander.set_current_move("tackle")
# # charmander.attack("otro pokemon")

# def show_stats(pokemon)
#   p pokemon.stats
# end

# show_stats(charmander)
