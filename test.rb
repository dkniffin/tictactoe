require_relative 'board.rb'
require_relative 'ai.rb'

def test(ai,testNum,testName,a)
	b = Board.new(3,3,a)
	puts "Test #{testNum}: #{testName}"
	puts "Starting state:"
	puts b
	ai.move(b)
	puts "End state:"
	puts b
end

$wins = 0

def test(in_b,ai,turn,moves=[])
	b = Marshal.load(Marshal.dump(in_b)) # clone the board
	# puts b.to_s
	# First check if opponent has won
	if b.end?
		if b.winner == ai.opponent
			puts "Wins:#{$wins}"
			puts "Failed board:"
			puts b
			puts
			puts "Moves:"
			puts moves.to_s
			exit
		elsif b.winner == ai.player
			# puts "AI wins"
			$wins += 1
		elsif b.winner == nil
			# puts "Tie."
			$wins += 1
		end
	# If it's ai's turn, go
	elsif turn == ai.player
		move = ai.move(b)
		pos = Board.posCoords.index(move) + 1
		moves.push("#{ai.player}->#{pos}")
		test(b,ai,ai.opponent,moves)
	# If it's not, run all possible moves that are left
	else
		for x,y in Board.posCoords
			moves_copy = Marshal.load(Marshal.dump(moves))
			if b.valid?(x,y)
				b.move(x,y,ai.opponent)
				pos = Board.posCoords.index([x,y]) + 1
				moves_copy.push("#{ai.opponent}->#{pos}")
				test(b,ai,ai.player,moves_copy)
				b.unmove(x,y)
			end
		end
	end
end

test(Board.new(3,3), AI.new('O','X'),'X')
test(Board.new(3,3), AI.new('X','O'),'X')
puts "All tests passed."
