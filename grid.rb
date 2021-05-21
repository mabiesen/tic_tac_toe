require 'terminal-table'

class Grid
  attr_accessor :grid

  def initialize
    @grid = generate_grid
  end

  def update_square(row, col, indicator)
    @grid[row.to_s][col.to_s] = indicator 
  end

  def square_already_occupied?(row, col)
    return false if @grid[row.to_s][col.to_s] == ' '
    
    true
  end

  def count_blank_squares
    ct = 0
    @grid.each do |_,v|
      v.each do |_,v2|
        ct += 1 if v2 == ' '
      end
    end
    ct
  end

  def print_grid
    # we should print the grid with off-side numbers to illustrate coordinates
    arr = grid_to_array_of_values
    ct = 0
    table = Terminal::Table.new do |t|
      arr.each do |row|
        ct += 1
        t.add_row row
        unless ct == arr.count
          t.add_separator
        end
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
      @grid.values.each do |val|
        vals.push(val[key])
      end
      uniq_vals = vals.uniq
      if uniq_vals.count == 1 && uniq_vals.first != ' '
        return uniq_vals.first
      end
    end
    nil
  end

  def horizontal_match_symbol
    keys = @grid.keys
    keys.each do |key|
      vals = @grid[key].values
      uniq_vals = vals.uniq
      if uniq_vals.count == 1 && uniq_vals.first != ' '
        return uniq_vals.first
      end
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
      backward_coords.push([(value_count) - t, t + 1])
    end

    [forward_coords, backward_coords].each do |arr|
      vals = arr.map do |sub_arr|
               @grid[sub_arr[0].to_s][sub_arr[1].to_s]
             end

      uniq_vals = vals.uniq
      if uniq_vals.count == 1 && uniq_vals.first != ' '
        return uniq_vals.first
      end
    end
    nil
  end

  def grid_to_array_of_values
    arr = []
    @grid.each do |k,v|
      arr.push(v.values)
    end
    return arr
  end

  private

  def generate_grid
    ret_hsh = {}
    3.times do |t|
      ret_hsh[(t + 1).to_s] = {'1' => ' ', '2' => ' ', '3' => ' '}
    end
    ret_hsh
  end

end
