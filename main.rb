require 'pp'
require_relative 'board.rb'
require_relative 'ai.rb'

b = Board.new(3,3) # Create the board

# Welcome text
puts "Welcome to Tic-Tac-Toe!"
$stdout.print("X or O? ")
playerToken = gets.chomp

# Set up AI
aiToken = (playerToken == 'X') ? 'O' : 'X'
ai = AI.new(aiToken,playerToken)

# If AI is X, take first move
if aiToken == 'X'
	ai.move(b)
end

# Game REPL
puts b
prompt = "Your move: "
loop do
	# Check if the game is over
	if b.end?
		puts "Game over!"
		exit
	end
	$stdout.print(prompt)
	input = gets.chomp # Get user input

	x,y = input.split(',').map{|e| e.to_i} # split into x & y

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
