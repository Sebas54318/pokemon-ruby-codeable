require_relative "player"
require_relative "battle"

class Game
  def start
    print_welcome
    player_name = ask_for_player_name
    pokemon_species = ask_for_pokemon_species
    pokemon_name = ask_for_pokemon_name
    @player = Player.new(player_name, pokemon_species, pokemon_name)

    action = menu
    until action == "Exit"
      case action
      when "Train"
        train
        action = menu
      when "Leader"
        challenge_leader
        action = menu
      when "Stats"
        show_stats
        action = menu
      end
    end

    goodbye
  end

  def train
    bot = Bot.new("Random Person", Pokedex::POKEMONS.keys.sample, nil, rand(1..6))
    battle = Battle.new(@player, bot)
    battle.start
  end

  def challenge_leader
    bot = Bot.new("Brock", "Onix", nil, 10)
    battle = Battle.new(@player, bot)
    battle.start
  end

  def show_stats
    pokemon = @player.pokemon
    stats = pokemon.stats

    puts pokemon.name
    puts "Kind: #{pokemon.species}"
    puts "Level: #{pokemon.level}"
    puts "Type: #{pokemon.type}"
    puts "Stats:"
    puts "HP: #{stats[:hp]}"
    puts "Attack: #{stats[:attack]}"
    puts "Defense: #{stats[:defense]}"
    puts "Special Attack: #{stats[:special_attack]}"
    puts "Special Defense: #{stats[:special_defense]}"
    puts "Speed: #{stats[:speed]}"
    puts "Experience Points: #{pokemon.experience_points}"
  end

  def goodbye
    puts "Thanks for playing Pokemon Ruby"
    puts "This game was created with love by: Diego, Manuel, Renzo, Sebastian, Yahaira, Bryan"
  end

  def menu
    puts "-----------------------Menu-----------------------"
    puts ""
    options = ["Stats", "Train", "Leader", "Exit"]

    input = nil

    loop do
      puts "1. Stats        2. Train        3. Leader       4. Exit "
      print "> "
      input = gets.chomp
      break if options.include?(input)
    end

    input
  end

  def print_welcome
    puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#
#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#
#$##$##$##$ ---        Pokemon Ruby         --- #$##$##$#$#
#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#
#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#

Hello there! Welcome to the world of POKEMON! My name is OAK!
People call me the POKEMON PROF!

This world is inhabited by creatures called POKEMON! For some
people, POKEMON are pets. Others use them for fights. Myself...
I study POKEMON as a profession."
  end

  def ask_for_player_name
    puts "First, what is your name?"
    print "> "
    gets.chomp
  end

  def ask_for_pokemon_species(player_name)
    puts "Right! So your name is #{player_name.upcase}!
Your very own POKEMON legend is about to unfold! A world of
dreams and adventures with POKEMON awaits! Let's go!
Here, #{player_name.upcase}! There are 3 POKEMON here! Haha!
When I was young, I was a serious POKEMON trainer.
In my old age, I have only 3 left, but you can have one! Choose!"

    while true
      puts "1. Bulbasaur    2. Charmander   3. Squirtle"
      print "> "
      pokemon_species = gets.chomp
      break if ["Bulbasaur", "Charmander", "Squirtle"].include?(pokemon_species)

      puts "That's not an option"
    end

    puts "You selected #{pokemon_species.upcase}. Great choice!"
    pokemon_species
  end

  def ask_for_pokemon_name
    puts "Give your pokemon a name?"
    print "> "
    gets.chomp
  end
end
