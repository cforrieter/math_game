require 'colorize'

@player1_life
@player2_life
@player1_name
@player2_name
@current_player
@player1_wins = 0
@player2_wins = 0

def initialize_players
  puts "What is player 1's name?"
  @player1_name = gets.chomp.capitalize

  puts "What is player 2's name?"
  @player2_name = gets.chomp.capitalize
end

def initialize_game
  @player1_life = 3
  @player2_life = 3

  @current_player = @player1_name

  game_status
end

def win_status
  "\n\n#{@player1_name} has won #{@player1_wins} times!\n#{@player2_name} has won #{@player2_wins} times!"
end

def game_status
  game_over = false
  message = ''
  unless @player1_life === 0 || @player2_life === 0
    message = "The current game status is: \n\t#{@player1_name}: #{@player1_life}\n\t#{@player2_name}: #{@player2_life}"
  else
    game_over = true
    message << "The game is over!\n"
    if @player1_life > @player2_life
      message << "#{@player1_name} wins with #{@player1_life} live(s) remaining."
      @player1_wins += 1 
    else
      message << "#{@player2_name} wins with #{@player2_life} live(s) remaining."
      @player2_wins += 1 
    end
    message << win_status
  end
  puts message
  return game_over
end

def lose_life
  if @current_player === @player1_name
    @player1_life -= 1
  else
    @player2_life -= 1
  end
end

def swap_players
  if @current_player === @player1_name
    @current_player = @player2_name
  else
    @current_player = @player1_name
  end
end

def generate_question
  num1 = rand(20) + 1
  num2 = rand(20) + 1
  operation = rand(4) + 1
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

def prompt_player(question)
  puts "#{@current_player}, #{question}"
  print "You answer: "
  return gets.chomp.to_i
end

def verify_answer(answer, player_answer)
  if answer == player_answer
    puts "Correct!".colorize(:green)
  else
    puts "Wrong! The answer was #{answer}.".colorize(:red)
    lose_life
    return game_status
  end
end

def turn
  question, answer = generate_question
  player_answer = prompt_player(question)
  game_state = verify_answer(answer, player_answer)
  swap_players
  return game_state
end

def game
  finished = false
  initialize_players

  until finished
    game_over = false
    initialize_game
    until game_over
      game_over = turn
    end
    puts "Play again? (y/n)"
    play_again = gets.chomp.downcase
    case play_again
    when 'n'
      finished = true
    end
  end
end

game