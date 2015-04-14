require 'pp'
require_relative 'board.rb'
require_relative 'ai.rb'

b = Board.new(3,3)

puts "Welcome to Tic-Tac-Toe!"
$stdout.print("X or O? ")
playerToken = gets.chomp

aiToken = (playerToken == 'X') ? 'O' : 'X'
ai = AI.new(aiToken,playerToken)

if aiToken == 'X'
	ai.move(b)
end

puts b
prompt = "Your move: "
loop do
	if b.end?
		puts "Game over!"
		exit
	end
	$stdout.print(prompt)
	input = gets.chomp

	x,y = input.split(',').map{|e| e.to_i}

	if b.valid?(x,y)
		b.move(x,y,playerToken)
		ai.move(b)
	else
		puts "Invalid move! Try again."
	end
  	puts b
end
