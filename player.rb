# require neccesary files
require_relative "pokemon"
require_relative "pokedex/pokemons"

class Player
  def initialize(player_name, pokemon_specie, pokemon_name = nil, pokemon_level = nil)
    @name = player_name
    @pokemon = Pokemon.new(pokemon_specie, pokemon_name, pokemon_level)
  end

  def select_move
    loop do
      puts "#{@name}, select your move:"
      @pokemon.moves.each.with_index do |option, index|
        print "#{index + 1}. #{option}    "
      end
      print "\n>"
      input = gets.chomp
      if @pokemon.moves.include?(input)
        @pokemon.apply_current_move(input)
        break
      else
        puts "#{@pokemon.name} can't use this move"
      end
    end
  end
end

class Bot < Player
  def select_move
    move = @pokemon.moves.sample
    @pokemon.apply_current_move(move)
  end
end

# pokemon = Pokedex::POKEMONS.keys.sample
# bot1 = Bot.new("Random Person", pokemon)
# bot1.select_move
# p bot1
