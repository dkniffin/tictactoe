class AI
	attr_reader :player,:opponent
	def initialize(player,opponent)
		# Player = number of player
		@player = player
		@opponent = opponent
	end
	def move(board)
		# If the board is empty, it means we're going first. The best move to
		# take in this case is the top left. By manually doing this, we reduce
		# computation time.
		if board.empty?
			board.move(0,0,@player)
			return [0,0]
		end

		@best_move = nil

		# Start with best and worst scores of -11 and +11
		@base_score = board.valid_moves.count + 1
		bound = @base_score + 1

		# Run minimax
		minimax(board, 0, @player, -bound, bound)

		# Take a move on the board, and return it
		board.move(@best_move[0],@best_move[1],@player)
		return @best_move
	end

	def minimax(board, depth, player, best, worst)
		# If the game is over, return the score of the board

		# TODO: In tic-tac-toe, many times a result can be determined before
		# the end of the game. Computation time could be decreased if we do
		# this before the very end
		return heuristic(board) if board.end?

		move_score_pairs = []

		# For each valid move on the board
		board.valid_moves.each do |move|
			# Take the move
			board.move(move[0],move[1],player)

			# Calculate the score for that move
			next_player = (player == @player)? @opponent : @player
			score = minimax(board,depth+1,next_player,best,worst)

			# Undo the move
			board.unmove(move[0],move[1])

			pair = [score,move]

			if player == @player
				# Add the score and move to the list of potential moves
				move_score_pairs.push(pair)
				# Update best
				best = pair[0] if pair[0] > best
			else
				# Update worst
				worst = pair[0] if pair[0] < worst
			end
			# We found a winning move; break
			break if worst < best
		end
		if player == @opponent
			worst
		else
			# Set the best move, and return the score
			@best_move = move_score_pairs.max_by{|node|node[0]}[1]
			best
		end
	end
	def heuristic(board)
		if board.winner == @player
			10
		elsif board.winner == @opponent
			-10
		else
			0
		end
	end
end
