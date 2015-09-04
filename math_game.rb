require 'colorize'

@player1 = {
  :wins => 0,
  :lives => 3,
  :name => "Player1"
}
@player2 = {
  :wins => 0,
  :lives => 3,
  :name => "Player2"
}

def initialize_players

  puts "What is player 1's name?"
  @player1[:name] = gets.chomp.capitalize

  puts "What is player 2's name?"
  @player2[:name] = gets.chomp.capitalize
end

def initialize_game
  @player1[:lives] = 3
  @player2[:lives] = 3
  player = @player1
  game_status(player)
  
  return player
end

def win_status
  "\n\n#{@player1[:name]} has won #{@player1[:wins]} times!\n#{@player2[:name]} has won #{@player2[:wins]} times!"
end

def game_status(player)
  game_over = false
  message = ''
  unless player[:lives] === 0
    message = "The current game status is: \n\t#{@player1[:name]}: #{@player1[:lives]}\n\t#{@player2[:name]}: #{@player2[:lives]}"
  else
    game_over = true
    message << "The game is over!\n"
    if player != @player1
      message << "#{@player1[:name]} wins with #{@player1[:lives]} live(s) remaining."
      @player1[:wins] += 1 
    else
      message << "#{@player2[:name]} wins with #{@player2[:lives]} live(s) remaining."
      @player2[:wins] += 1 
    end
    message << win_status
  end
  puts message
  return game_over
end

def lose_life(player)
  player[:lives] -= 1
end

def swap_players(player)
  if player === @player1
    player = @player2
  else
    player = @player1
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

def prompt_player(player, question)
  puts "#{player[:name]}, #{question}"
  print "You answer: "
  return gets.chomp.to_i
end

def verify_answer(player, answer, player_answer)
  if answer == player_answer
    puts "Correct!".colorize(:green)
    return true
  else
    puts "Wrong! The answer was #{answer}.".colorize(:red)
    return false
  end
end

def turn(player)
  game_over = false
  question, answer = generate_question
  player_answer = prompt_player(player, question)
  unless verify_answer(player, answer, player_answer)
    lose_life(player)
    game_over = game_status(player)
  end
  return game_over
end

def game
  finished = false
  initialize_players

  until finished
    game_over = false
    player = initialize_game
    until game_over
      game_over = turn(player)
      player = swap_players(player)
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