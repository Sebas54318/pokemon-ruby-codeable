# require neccesary files
require_relative "pokemon"

class Player
  def initialize(player_name, pokemon_specie, pokemon_name = nil, pokemon_level = nil)
    @name = player_name
    @pokemon = Pokemon.new(pokemon_specie, pokemon_name, pokemon_level)
  end

  def select_move
    # Complete this
  end
end

# Create a class Bot that inherits from Player and override the select_move method

# player1 = Player.new("Diego", "Charmander")
# p player1
