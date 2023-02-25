# require neccesary files
require_relative "pokemon"

class Player

  def initialize(player_name, pokemon_specie, pokemon_name = nil, pokemon_level = nil)
    @name = player_name
    @pokemon = Pokemon.new(pokemon_specie, pokemon_name, pokemon_level)
  end

  def select_move
    # Complete this
    # EJEMPLO:
    continue = true
     while continue
      puts "#{@name}, select your move:"
      @pokemon.moves.each.with_index do |option, index|
        print "#{index+1}. #{option}    "   
      end  
      
      print "\n>"
      # puts "1. #{@pokemon.moves[0]}      2. #{@pokemon.moves[1]}"
      input = gets.chomp
      if @pokemon.moves.include?(input)
        @pokemon.apply_current_move(input)
        continue = false
      else 
        puts "#{@pokemon.name} can't use this move"
      end

    end
  
    # Pokemon.new.apply_current_move  

    # Great master, select your move:
    # 1. scratch      2. ember
    # >

    # Una vez que obtenemos un moviemiento valido
    # ejecutar al metodo apply_current_move de mi pokemon pasandole el movimiento
  end
end

# Create a class Bot that inherits from Player and override the select_move method

player1 = Player.new("Pepe", "Charmander")
player1.select_move
# Pepe, select your move
# 1. scratch      2. ember
# > ember
 p player1
# <PlayerX423423423, @name="Pepe"... 
# @pokemon = <PokemonX34i34 ... @current_move={name: "ember", ...}  ...>>