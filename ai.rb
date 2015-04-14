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
