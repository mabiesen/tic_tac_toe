require 'terminal-table'

class Grid
  attr_accessor :grid

  BLANK_SPACE = ' '.freeze

  def initialize(width = 3)
    @grid = generate_grid(width)
  end

  def update_square(row, col, indicator)
    @grid[row.to_s][col.to_s] = indicator
  end

  def square_already_occupied?(row, col)
    return false if @grid[row.to_s][col.to_s].nil?

    true
  end

  def count_blank_squares
    ct = 0
    @grid.each do |_, v|
      v.each do |_, v2|
        ct += 1 if v2.nil?
      end
    end
    ct
  end

  def print_grid
    arr = grid_to_array_of_values

    # swap nils to make grid pretty
    arr = arr.map { |a| a.map { |i| i.nil? ? BLANK_SPACE : i } }
    ct = 0
    table = Terminal::Table.new do |t|
      arr.each do |row|
        ct += 1
        t.add_row row
        t.add_separator unless ct == arr.count
      end
    end
    puts table
  end

  # looks for a 'winner' relative to tic-tac-toe speak
  # returns the game string that one, traditionally  an 'X' or an 'O'
  def symbol_if_match_exists
    horizontal_match_symbol || vertical_match_symbol || diagonal_match_symbol || nil
  end

  def vertical_match_symbol
    keys = @grid.keys
    keys.each do |key|
      vals = []
      @grid.each_value do |val|
        vals.push(val[key])
      end
      uniq_vals = vals.uniq
      return uniq_vals.first if uniq_vals.count == 1 && !uniq_vals.first.nil?
    end
    nil
  end

  def horizontal_match_symbol
    keys = @grid.keys
    keys.each do |key|
      vals = @grid[key].values
      uniq_vals = vals.uniq
      return uniq_vals.first if uniq_vals.count == 1 && !uniq_vals.first.nil?
    end
    nil
  end

  def diagonal_match_symbol
    forward_coords = []
    backward_coords = []
    value_count = @grid.values.count
    value_count.times do |t|
      forward_coords.push([t + 1, t + 1])
    end

    value_count.times do |t|
      backward_coords.push([value_count - t, t + 1])
    end

    [forward_coords, backward_coords].each do |arr|
      vals = arr.map do |sub_arr|
        @grid[sub_arr[0].to_s][sub_arr[1].to_s]
      end

      uniq_vals = vals.uniq
      return uniq_vals.first if uniq_vals.count == 1 && !uniq_vals.first.nil?
    end
    nil
  end

  def grid_to_array_of_values
    arr = []
    @grid.each do |_k, v|
      arr.push(v.values)
    end
    arr
  end

  private

  def generate_grid(width)
    ret_hsh = {}
    width.times do |t|
      col_hsh = {}
      width.times do |t2|
        col_hsh[(t2 + 1).to_s] = nil
      end
      ret_hsh[(t + 1).to_s] = col_hsh
    end
    ret_hsh
  end
end
