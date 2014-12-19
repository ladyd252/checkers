require_relative "Board.rb"
require_relative "Player.rb"

class WrongPieceError < StandardError
end

class Game 

	attr_reader :player1, :player2, :board

	def initialize
		@board = Board.new
		@player1 = Player.new("Player 1", :white)
		@player2 = Player.new("Player2", :black)
	end

	def play
		player = @player1
		until @board.board_empty? || @board.lost?(player.color)
			system("clear")
			begin
				board.render
				positions = player.turn
				raise WrongPieceError if @board[positions.first].color != player.color
			rescue
				puts "That's not your piece. Please choose again."
				retry
			else
				@board[positions.first].perform_moves(positions.last)
				#change player
				player == player1 ? player = player2 : player = player1
			end
		end
	end

end


g = Game.new
g.play
# b = Board.new
# b.render
# b[[2,1]].perform_slide([3,0])
# b[[5,0]].perform_slide([4,1])
# b[[5,2]].perform_slide([4,3])
# b.render
# b[[5,6]].perform_slide([4,7])
# b[[6,5]].perform_slide([5,6])
# b[[7,4]].perform_slide([6,5])
# b.render
# b[[3,0]].perform_moves([[5,2], [7,4]])
# b.render