class AI
	attr_reader :player,:opponent
	def initialize(player,opponent)
		# Player = number of player
		@player = player
		@opponent = opponent
	end
	def move(board)
		# Take a move on the board
		score, move = minimax(board, 2,@player)
		board.move(move[0],move[1],@player)
		return move
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

		return [bestScore,bestMove]
	end
	def heuristic(board)
		board.sets.each_with_index.map do |set,i|
			midcenter = [1,4,6,7].include?(i)
			setHeuristic(set,midcenter)
		end.reduce(:+)
	end
	def setHeuristic(set,midcenter=false)
		# midcenter says whether the middle of this set is the center


		myCount = Board.countInRow(set,@player)
		oppCount = Board.countInRow(set,@opponent)

		if myCount == 3
			100
		elsif oppCount == 3
			-100
		elsif myCount == 2
			10
		elsif oppCount == 2
			-10
		elsif set[1] == @player && midcenter
			5
		elsif set[0] == @player || set[2] == @player # Owning a corner space
			3
		elsif myCount == 1 # Owning another space
			1
		elsif oppCount == 1
			-1
		else
			0
		end
	end
end
