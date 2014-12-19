class Player
	attr_reader :name, :color

	def initialize(name, color)
		@name = name
		@color = color
	end

	def turn
		puts "Which piece would you like to move, #{name}? (row, col)"
		piece_pos_str = gets.chomp.split(",")
		piece_pos = [piece_pos_str.first.to_i, piece_pos_str.last.to_i]
		x = false
		move_to_seq = []
		until x
			puts "Where would you like to move it to, #{name}? (row, col) Please press x when done entering moves"
			move_to_str = gets.chomp
			if move_to_str == "x"
				x = true
			else
				move_to_str = move_to_str.split(",")
				move_to_seq << [move_to_str.first.to_i, move_to_str.last.to_i]
			end
		end
		[piece_pos, move_to_seq]
	end

end