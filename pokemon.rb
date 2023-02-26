# require neccesary files
require_relative "pokedex/pokemons"
require_relative "pokedex/moves"

class Pokemon
  include Pokedex

  attr_reader :stats, :type, :name, :base_exp, :level , :moves, :current_hp, :current_move, :species, :experience_points

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
    @current_hp = @stats[:hp]
  end

  def receive_damage(damage)
    @current_hp -= damage
    @current_hp = 0 if @current_hp.negative?
  end

  def apply_current_move(move)
    @current_move = MOVES[move]
  end

  def fainted?
    @current_hp.zero?
  end

  def attack(target)
    # Print attack message 'Tortuguita used MOVE!'
    puts "#{@name} used #{@current_move[:name].upcase}!"
    # Accuracy check
    if rand(1..100) > @current_move[:accuracy]
      puts "But it MISSED!"
      return
    end
    # -- Calculate base damage
    damage = calc_base_damage(target)
    # -- Critical Hit check
    damage *= 1.5 if critical_hit?
    # -- Effectiveness check
    multiplier = calc_multiplier(target)
    # -- Mutltiply damage by effectiveness multiplier and round down. Print message if neccesary
    damage = (damage * multiplier).floor
    print_effectiveness(multiplier, target)
    # -- Inflict damage to target and print message "And it hit [target name] with [damage] damage""
    target.receive_damage(damage)
    puts "And it hit #{target.name} with #{damage} damage"
  end

  def increase_stats(target)
    amount = (target.base_exp * target.level / 7.0).floor
    @experience_points += amount
    puts "#{@name} gained #{amount} experience points"
    new_level = LEVEL_TABLES[@growth_rate].index { |exp| exp > @experience_points }

    return unless new_level > @level

    @level = new_level
    @stats = calc_stats
    puts "#{@name} reached level #{@level}!"
  end

  private

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

  def calc_base_damage(target)
    is_special = SPECIAL_MOVE_TYPE.include?(@current_move[:type])
    offensive_stat = is_special ? @stats[:special_attack] : @stats[:attack]
    target_defensive_stat = is_special ? target.stats[:special_defense] : target.stats[:defense]

    ((((2 * @level / 5.0) + 2).floor * offensive_stat * @current_move[:power] / target_defensive_stat)
    .floor / 50.0).floor + 2
  end

  def critical_hit?
    if rand(1..16) == 1
      puts "It was CRITICAL hit!"
      return true
    end

    false
  end

  def calc_multiplier(target)
    found_conditions = TYPE_MULTIPLIER.select do |condition|
      condition[:user] == @current_move[:type] && target.type.include?(condition[:target])
    end

    multiplier = 1
    found_conditions.each do |condition|
      multiplier *= condition[:multiplier]
    end

    multiplier
  end

  def print_effectiveness(multiplier, target)
    if multiplier <= 0.5
      puts "It's not very effective..."
    elsif multiplier >= 1.5
      puts "It's super effective!"
    elsif multiplier.zero?
      puts "It doesn't affect #{target.name}!"
    end
  end
end
