require 'colorize'

class Player
  attr_accessor :lives
  attr_reader :name, :wins

  def initialize(name)
    @name = name
    @wins = 0
  end

  def lose_life
    @lives -= 1
  end

  def gain_win
    @wins += 1
  end
end

class Game

  def self.initialize_players
    puts "What is player 1's name?"
    name1 = gets.chomp.capitalize

    puts "What is player 2's name?"
    name2 = gets.chomp.capitalize

    return Game.new(name1, name2)
  end
  
  def initialize(name1, name2)
    @player1 = Player.new(name1)
    @player2 = Player.new(name2)
  end


  def start_game
    finished = false
    until finished
      game_over = false
      player = new_game
      until game_over
        turn(player)
        game_over = game_over?(player)
        player = swap_players(player)
        if game_over
          player.gain_win
          puts game_summary(player)
        end
      end
      puts "Play again? (y/n)"
      play_again = gets.chomp.downcase
      case play_again
      when 'n'
        finished = true
      end
    end
  end

  def new_game
    @player1.lives = 3
    @player2.lives = 3
    puts game_status
    player = @player1
  end

  def turn(player)
    question, answer = generate_question_with_answer
    player_answer = prompt_player(player, question)
    unless verify_answer(player, answer, player_answer)
      player.lose_life
      puts game_status
    end
  end

  def random_number(max)
    rand(max) + 1
  end

  def generate_question_with_answer
    num1 = random_number(20)
    num2 = random_number(20)
    operation = random_number(4)
    case operation
    when 1
      operation = "+"
    when 2
      operation = "-"
      if num1 < num2
        num1, num2 = num2, num1
      end
    when 3
      operation = "*"
    when 4
      operation = "/"
      if num1 < num2
        num1, num2 = num2, num1
      end
    end
    
    question = "what is #{num1} #{operation} #{num2}?"
    answer = eval "#{num1} #{operation} #{num2}"
    return [question, answer]
  end

  def prompt_player(player, question)
    puts "#{player.name}, #{question}"
    print "You answer: "
    return gets.chomp.to_i
  end

  def verify_answer(player, answer, player_answer)
    if answer == player_answer
      puts "\nCorrect!\n".colorize(:green)
      return true
    else
      puts "\nWrong! The answer was #{answer}.\n".colorize(:red)
      return false
    end
  end

  def game_over?(player)
    player.lives === 0
  end


  def game_summary(winning_player)
    "The game is over!\n#{winning_player.name} wins with #{winning_player.lives} live(s) remaining.\n\n#{@player1.name} has won #{@player1.wins} times!\n#{@player2.name} has won #{@player2.wins} times!\n".colorize(:blue)
  end

  def game_status
      "The current game status is: \n\t#{@player1.name}: #{@player1.lives}\n\t#{@player2.name}: #{@player2.lives}\n\n"
  end

  def swap_players(player)
    player === @player1 ? @player2 : @player1
  end


end


game1 = Game.initialize_players
game1.start_game