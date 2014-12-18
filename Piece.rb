class InvalidMoveError < StandardError
end
	
class Piece
	attr_accessor :pos, :board, :king
	attr_reader :color

	def initialize(pos, color, board, king = false)
		@pos = pos
		@color = color
		@board = board
		@king = king
	end

	def inspect
		{:pos => @pos}.inspect
	end

	def render
		if !@king
			color == :white ? "⚆" : "⚈"
		else
			color == :white ? "♔" : "♚"
		end
	end

	def perform_moves(move_sequence)
		if valid_move_seq?(move_sequence)
			perform_moves!(move_sequence)
		else
			raise InvalidMoveError
		end
	end



	def perform_moves!(move_sequence)
		#performs moves one by one
		#if a move fails, raise InvalidMoveError
		if move_sequence.length == 1
			if !perform_slide(move_sequence.first) 
				perform_jump(move_sequence.first)
				promote
			end
		else
			move_sequence.each do |move|
				raise InvalidMoveError if !perform_jump(move)
				promote
			end
		end
	end

	def valid_move_seq?(move_sequence)
		begin
			dupped_board = @board.dup_board
			dupped_piece = dupped_board[@pos]
			dupped_piece.perform_moves!(move_sequence)
		rescue InvalidMoveError 
			return false
		else
			true
		end
	end


	def perform_slide(next_pos)
		#return true or false if move is legal
		#move is legal if our possible moves include the next position and the board is empty at that position
		#make move by changing board and piece's position value
		if slide_moves.include?(next_pos) && board[next_pos].nil?
			move!(next_pos)
		else
			false
		end
	end

	def perform_jump(next_pos)
		#return true or false if move is legal

		#not a valid move if our possible moves don't include the next position
		return false if single_jump_moves.include?(next_pos)

		#check which positon we're trying to jump
		jumped_pos = [pos[0] + (next_pos[0] - @pos[0])/2, pos[1] + (next_pos[1] - @pos[1])/2]

		return false if @board[jumped_pos].nil?

		return false if @board[jumped_pos].color == @color
		#see if that position has a piece to be jumped, and if the next position is empty
		#if so, make move by changing board, removing jumped piece, and changing jumping piece's position
		if board[next_pos].nil?
			@board[jumped_pos] = nil
			move!(next_pos)
		else
			false
		end
	end

	def move!(next_pos)
		@board[next_pos] = self
		@board[pos] = nil
		@pos = next_pos
		true
	end

	def move_diffs 
		if king
			[[-1, 1], [-1, -1], [1, 1], [1, -1]]

		elsif color == :white
			[[-1, 1], [-1, -1]]
		else
			[[1, 1], [1, -1]]
		end
	end

	def slide_moves
		poss_moves = []
		diffs = move_diffs

		poss_moves << [pos[0] + diffs[0][0], pos[1] + diffs[0][1]]
		poss_moves << [pos[0] + diffs[1][0], pos[1] + diffs[1][1]]


		poss_moves.select do |poss_move| 
			poss_move[0] >= 0 && poss_move[0] <= 7 && poss_move[1] >= 0 && poss_move[1] <= 7
		end
	end

	def single_jump_moves
		poss_moves = []
		diffs = move_diffs
		
		poss_moves << [pos[0]* + diffs[0][0]*2, pos[1] + diffs[0][1]*2]
		poss_moves << [pos[0] + diffs[1][0]*2, pos[1] + diffs[1][1]*2]


		poss_moves.select do |poss_move| 
			poss_move[0] >= 0 && poss_move[0] <= 7 && poss_move[1] >= 0 && poss_move[1] <= 7
		end
	end

	def promote
		if color == :white && pos[1] == 0
			@king = true
		elsif color == :black && pos[1] == 7
			@king = true
		end
	end

end


