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


test(ai, 1.1, "finish row to win",
	[['X','X',nil],
	 [nil,nil,nil],
	 [nil,nil,nil]])
test(ai, 1.2, "finish row to win",
	[[nil,nil,nil],
	 [nil,'X','X'],
	 [nil,nil,nil]])
test(ai, 1.3, "finish row to win",
	[[nil,nil,nil],
	 [nil,nil,nil],
	 ['X',nil,'X']])

test(ai, 2.1, "finish col to win",
	[['X',nil,nil],
	 ['X',nil,nil],
	 [nil,nil,nil]])
test(ai, 2.2, "finish col to win",
	[[nil,nil,nil],
	 [nil,'X',nil],
	 [nil,'X',nil]])
test(ai, 2.3, "finish col to win",
	[[nil,nil,'X'],
	 [nil,nil,nil],
	 [nil,nil,'X']])

test(ai, 3.1, "finish diag to win",
	[[nil,nil,nil],
	 [nil,'X',nil],
	 [nil,nil,'X']])
test(ai, 3.2, "finish diag to win",
	[[nil,nil,'X'],
	 [nil,'X',nil],
	 [nil,nil,nil]])

test(ai, 4.1, "block opponent if they have two",
	[['O','O',nil],
	 [nil,nil,nil],
	 [nil,nil,nil]])
test(ai, 4.2, "block opponent if they have two",
	[[nil,'O','X'],
	 [nil,'O',nil],
	 [nil,nil,nil]])

test(ai, 5.1, "win, even if opponent has two",
	[['X','O',nil],
	 ['X','O',nil],
	 [nil,nil,nil]])

test(ai, 6.1, "get two if we can",
	[['O',nil,'X'],
	 [nil,nil,nil],
	 [nil,nil,nil]])
test(ai, 6.2, "get two if we can",
	[[nil,nil,'X'],
	 [nil,'O',nil],
	 [nil,nil,nil]])

