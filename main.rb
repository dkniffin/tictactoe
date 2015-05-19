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

puts "Game input grid:"
puts Board.inputGrid
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

	coords = [[0,0],[1,0],[2,0],
			  [0,1],[1,1],[2,1],
			  [0,2],[1,2],[2,2]]
	pos = input.to_i
	if ! pos.between?(1,9)
		puts "Invalid input. Input should be a number 1-9."
		puts "Move grid:"
		puts Board.positionsString
		next
	end
	x,y = coords[pos-1]
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
