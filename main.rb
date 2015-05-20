require 'pp'
require_relative 'board.rb'
require_relative 'ai.rb'

b = Board.new(3,3) # Create the board

# Welcome text
puts "Welcome to Tic-Tac-Toe!"
playerToken = nil
continueloop = true
while(continueloop) do
	$stdout.print("X or O? ")
	playerToken = gets.chomp
	if playerToken != 'X' && playerToken != 'O'
		puts "Invalid token."
	else
		continueloop = false
	end
end

# Set up AI
aiToken = (playerToken == 'X') ? 'O' : 'X'
ai = AI.new(aiToken,playerToken)

# If AI is X, take first move
if aiToken == 'X'
	ai.move(b)
end

puts "Game input grid:"
puts Board.input_grid
puts
puts "Current Board:"
puts b
# Game REPL
prompt = "Your move: "
loop do
	# Check if the game is over
	if b.end?
		winner = b.winner
		result_msg = winner.nil? ? 'Tie.' : "#{winner} wins!"
		puts "Game over! #{result_msg}"
		exit
	end
	$stdout.print(prompt)
	input = gets.chomp # Get user input

	pos = input.to_i
	if ! pos.between?(1,9)
		puts "Invalid input. Input should be a number 1-9."
		puts "Move grid:"
		puts Board.input_grid
		puts "Current Board:"
		puts b
		next
	end
	x,y = Board.pos_coords[pos-1]
	# x,y = input.split(',').map{|e| e.to_i} # split into x & y

	if b.valid?(x,y)
		b.move(x,y,playerToken)
		unless b.end?
			ai.move(b)
		end
	else
		puts "Invalid move! Try again."
	end
  	puts b # Print the board
end
