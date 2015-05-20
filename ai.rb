class AI
	attr_reader :player,:opponent
	def initialize(player,opponent)
		# Player = number of player
		@player = player
		@opponent = opponent
	end
	def move(board)
		if board.empty?
			board.move(0,0,@player)
			return [0,0]
		end
		# Take a move on the board
		@base_score = board.valid_moves.count + 1
		bound = @base_score + 1
		minimax(board, 0, @player, -bound, bound)

		move = @current_move_choice

		board.move(move[0],move[1],@player)
		return move
	end

	def minimax(board, depth, player,lower_bound,upper_bound)
		return heuristic(board) if board.end?

		moves_w_scores = []

		board.valid_moves.each do |move|
			board.move(move[0],move[1],player)
			next_player = (player == @player)? @opponent : @player
			score = minimax(board,depth+1,next_player,lower_bound,upper_bound)
			board.unmove(move[0],move[1])
			node = [score,move]

			if player == @player
				moves_w_scores.push(node)
				lower_bound = node[0] if node[0] > lower_bound
			else
				upper_bound = node[0] if node[0] < upper_bound
			end
			break if upper_bound < lower_bound
		end
		return upper_bound unless player == @player

		@current_move_choice = moves_w_scores.max_by{|node|node[0]}[1]
		lower_bound
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
