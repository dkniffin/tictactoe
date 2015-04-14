require 'pp'
class Board
	attr_reader :w,:h,:data
	def initialize(w,h,data=nil)
		@w = w
		@h = h
		@data = data || ys.map{|i| xs.map{|j| nil}}
	end
	def xs
		(0..(@w-1))
	end
	def ys
		(0..(@h-1))
	end
	def rows
		xs.map{|x| ys.map{|y| [x,y]}}
	end
	def cols
		ys.map{|y| xs.map{|x| [x,y]}}
	end
	def diags
		# TODO: Change this to dynamic generation
		[[[0,0],[1,1],[2,2]],
		 [[0,2],[1,1],[2,0]]]
		#0,0 1,1 2,2
		#0,2 1,1 2,0
	end
	def cellCoords
		rows.reduce(:+)
	end
	def cells
		cellCoords.map{|x,y| @data[x][y]}
	end
	def setCoords
		# Return array of winning sets
		rows + cols + diags
	end
	def sets
		setCoords.map{|set| set.map{|x,y| @data[x][y]}}
	end
	def valid?(x,y)
		@data[x][y].nil?
	end
	def validMoves
		cellCoords.select{|x,y| valid?(x,y)}
	end
	def move(x,y,player)
		@data[x][y] = player
	end
	def unmove(x,y)
		@data[x][y] = nil
	end
	def to_s
		cols.map{|c| c.map{|x,y| (@data[x][y] == nil) ? '_': @data[x][y]}.join(' ')}.join("\n")
	end
	def end?
		# Any sets have all the same, non-nil, elements
		sets.any? do |set|
			Board.countInRow(set,'X') == 3 ||
			Board.countInRow(set,'O') == 3
		end || cells.none? {|cell| cell.nil?}

	end
	class << self
		def countInRow(set,player)
			bestCount = 1
			currentCount = 1
			lastE = nil
			set.each do |e|
				if e == player
					if lastE == e
						currentCount += 1
					end
					if currentCount > bestCount
						bestCount = currentCount
					end
					lastE = e
				end
			end
			bestCount
		end
	end
end

class AI
	def initialize(player,opponent)
		# Player = number of player
		@player = player
		@opponent = opponent
	end
	def move(board)
		# Take a move on the board
		# moves = board.validMoves
		score, move = minimax(board, 2,@player)
		board.move(move[0],move[1],@player)
	end
	def minimax(board, depth, player)
		moves = board.validMoves

		bestScore = (player == @player) ? -99999 : 99999
		currentScore = nil
		bestMove = [-1,-1]

		if (moves.empty? || depth == 0)
			bestScore = heuristic(board)
		else
			moves.each do |x,y|
				board.move(x,y,player)
				if (player == @player) # Our move; maximize
					currentScore = minimax(board, depth - 1, @opponent)[0]
					if (currentScore > bestScore)
						bestScore = currentScore
						bestMove = [x,y]
					end
				else # Their move; minimize
					currentScore = minimax(board, depth - 1, @player)[0]
					if (currentScore < bestScore)
						bestScore = currentScore
						bestMove = [x,y]
					end
				end
				board.unmove(x,y)
			end
		end
		# board2 = Marshal::load(Marshal::dump(board))

		return [bestScore,bestMove]
	end
	def heuristic(board)
		board.sets.map{|set| setHeuristic(set)}.reduce(:+)
	end
	def setHeuristic(set)
		# myCount = set.count(@player)
		myCount = Board.countInRow(set,@player)
		# oppCount = set.count{|e| e != @player && e != nil}
		oppCount = Board.countInRow(set,@opponent)

		if myCount == 3
			100
		elsif oppCount == 3
			-100
		elsif myCount == 2
			10
		elsif oppCount == 2
			-10
		elsif myCount == 1
			1
		elsif oppCount == 1
			-1
		else
			0
		end

		# 1. If we have two, 100
		# 2. If opponent has two, -100
		# 3. If we have oportunity to get two in row, 10
		# 4. Block opponent from getting two in a row, 10
		# 5. If center is open, take it
		# 6. If corner is open, take it
		# 7. Take side
	end


end

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
# puts ai.setHeuristic(['X','X','X']) # 100
# puts ai.setHeuristic(['O','O','O']) # -100
# puts ai.setHeuristic(['X','X',nil]) # 10
# puts ai.setHeuristic(['O','O',nil]) # -10
# puts ai.setHeuristic(['X',nil,nil]) # 1
# puts ai.setHeuristic(['O',nil,nil]) # -1

### Test cases ###
# 1. if two in row for self, then win

def test(ai,testNum,testName,a)
	b = Board.new(3,3,a)
	puts "Test #{testNum}: #{testName}"
	puts "Starting state:"
	puts b
	ai.move(b)
	puts "End state:"
	puts b
end


# test(ai, 1.1, "finish row to win",
# 	[['X','X',nil],
# 	 [nil,nil,nil],
# 	 [nil,nil,nil]])
# test(ai, 1.2, "finish row to win",
# 	[[nil,nil,nil],
# 	 [nil,'X','X'],
# 	 [nil,nil,nil]])
# test(ai, 1.3, "finish row to win",
# 	[[nil,nil,nil],
# 	 [nil,nil,nil],
# 	 ['X',nil,'X']])

# test(ai, 2.1, "finish col to win",
# 	[['X',nil,nil],
# 	 ['X',nil,nil],
# 	 [nil,nil,nil]])
# test(ai, 2.2, "finish col to win",
# 	[[nil,nil,nil],
# 	 [nil,'X',nil],
# 	 [nil,'X',nil]])
# test(ai, 2.3, "finish col to win",
# 	[[nil,nil,'X'],
# 	 [nil,nil,nil],
# 	 [nil,nil,'X']])

# test(ai, 3.1, "finish diag to win",
# 	[[nil,nil,nil],
# 	 [nil,'X',nil],
# 	 [nil,nil,'X']])
# test(ai, 3.2, "finish diag to win",
# 	[[nil,nil,'X'],
# 	 [nil,'X',nil],
# 	 [nil,nil,nil]])

# test(ai, 4.1, "block opponent if they have two",
# 	[['O','O',nil],
# 	 [nil,nil,nil],
# 	 [nil,nil,nil]])
# test(ai, 4.2, "block opponent if they have two",
# 	[[nil,'O','X'],
# 	 [nil,'O',nil],
# 	 [nil,nil,nil]])

# test(ai, 5.1, "win, even if opponent has two",
# 	[['X','O',nil],
# 	 ['X','O',nil],
# 	 [nil,nil,nil]])

# test(ai, 6.1, "get two if we can",
# 	[['O',nil,'X'],
# 	 [nil,nil,nil],
# 	 [nil,nil,nil]])
# test(ai, 6.2, "get two if we can",
# 	[[nil,nil,'X'],
# 	 [nil,'O',nil],
# 	 [nil,nil,nil]])

