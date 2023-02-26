require_relative "player"
class Battle
  # (complete parameters)
  
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def start
    prepare_pokemons
    display_pokemons
    puts "-------------------Battle Start!------------------- \n"
    
    # Until one pokemon faints
    until game_over?
      # --Print Battle Status
      display_battle_status
      # --Both players select their moves
      player_move
      # --Calculate which go first and which second
      first, second = calculate_order

      # --First attack second
      puts "--------------------------------------------------"
      atk(first, second)
      break if second.fainted?
      atk(second, first)
      break if first.fainted?
    end

    winner = first.fainted? ? second : first
    # Check which one won and print messages
    puts "#{winner.name} WINS!"
    # If the winner is the Player increase pokemon stats
    if winner == @player1.pokemon
      winner.increase_stats(@player2.pokemon)
    end
    puts "-------------------Battle Ended!-------------------"
  end

  private

  def prepare_pokemons
    @players = [@player1, @player2]
    @players.each { |player| player.pokemon.prepare_for_battle}
    puts "#{@player2.name} sent out #{@player2.pokemon.name.upcase}!"
    puts "#{@player1.name} sent out #{@player1.pokemon.name.upcase}!"
  end

  def display_pokemons
    @players = [@player1, @player2]
    @players.each do |player|
      puts "#{player.name} sent out #{player.pokemon.name.upcase}!"
    end
  end

  def player_move
    @players = [@player1, @player2]
    @players.each { |player| player.select_move }
  end

  def display_battle_status
    @players = [@player1, @player2]
    @players.each do |player|
      puts "#{player.name}'s #{player.pokemon.name} - Level #{player.pokemon.level}"
      puts "HP: #{player.pokemon.current_hp}"
    end
    puts ""
  end

  def calculate_order
    if  @player1.pokemon.current_move[:priority] == @player2.pokemon.current_move[:priority]
        if @player1.pokemon.stats[:speed] == @player2.pokemon.stats[:speed]
          first = [@player1.pokemon, @player2.pokemon].sample
        end
        first = @player1.pokemon.stats[:speed] > @player2.pokemon.stats[:speed] ? @player1.pokemon : @player2.pokemon
      else 
        first = @player1.pokemon.current_move[:priority] > @player2.pokemon.current_move[:priority] ? @player1.pokemon : @player2.pokemon
      end
      
      second = first == @player1.pokemon ? @player2.pokemon : @player1.pokemon
      [first, second]
  end

  def atk(attacker, deffender)
    attacker.attack(deffender)
      # --If second is fainted, print fainted message
      puts "--------------------------------------------------"
      if deffender.fainted?
        puts "#{deffender.name} FAINTED!"
        puts "--------------------------------------------------"
      end
  end

  def game_over?
    @players = [@player1, @player2]
    @players.any? { |player| player.pokemon.fainted? }
  end
end

player1 = Player.new("Renzo", "Squirtle")
player2 = Player.new("Manuel", "Charmander", nil, 3)

battle = Battle.new(player1, player2)
battle.start
