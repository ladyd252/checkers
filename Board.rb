require_relative "Piece.rb"
require "colorize"

class Board
	attr_accessor :grid

	def initialize(set_up_board = true)
		@grid = Array.new (8) {Array.new (8)}
		set_up if set_up_board
	end

	def set_up
		color = :black
		start_row = 0
		end_row = 2
		starting_el = 1
		(2).times do 
			(start_row..end_row).each do |row|
				(0..7).each do |col|
					if starting_el == 1 && col % 2 != 0
						self[[row, col]] = Piece.new([row, col], color, self)
					elsif starting_el == 0 && col % 2 == 0
						self[[row, col]] = Piece.new([row, col], color, self)
					end
				end
				starting_el ==1 ? starting_el = 0 : starting_el = 1
			end
			starting_el = 0
			color = :white
			start_row = 5
			end_row = 7
			p @grid
		end
	end

	def render
		start_white = true
		puts "   0  1  2  3  4  5  6  7"
		@grid.each_with_index do |row, r_i|
			print r_i.to_s + "  "
			row.each_with_index do |col, c_i|
				pos = [r_i, c_i]
				if self[pos]
					if (r_i + c_i) % 2 != 0 
						print self[pos].render.white.on_black + "  ".white.on_black
					else
						print self[pos].render + "  "
					end
				else 
					if (r_i + c_i) % 2 != 0  
						print "   ".white.on_black
					else
						print "   "
					end
				end
			end
			puts ""
			start_white == true ? false : true
		end
	end

	def dup_board
		dupped_board = Board.new(false)
		all_pieces.each do |orig_piece|
			dup_piece = orig_piece.class.new(orig_piece.pos.dup, orig_piece.color, dupped_board, orig_piece.king)
      		dupped_board[dup_piece.pos] = dup_piece
      	end
      	dupped_board
	end

	def all_pieces
		@grid.flatten.compact
	end

	def board_empty?
		all_pieces.empty?
	end

	def lost?(player_color)
		player_pieces = all_pieces.select {|piece| piece.color == player_color}
		player_pieces.all? do |piece| 
			piece.single_jump_moves.empty? && piece.slide_moves.empty? 
		end
	end



	def [](pos)
		@grid[pos[0]][pos[1]] 
	end

	def []=(pos, value)
		@grid[pos[0]][pos[1]] = value
	end

end

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
