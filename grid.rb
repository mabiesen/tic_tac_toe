# frozen_string_literal: true

require 'terminal-table'

# a class to store a matrix in hash form
# for use with tic-tac-toe, but dynamic enough to service other needs
class Grid
  attr_accessor :grid
  attr_reader :width

  BLANK_SPACE = ' '

  def initialize(width = 3)
    @grid = generate_grid(width)
    @width = 3
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
    to_a.each do |arr|
      arr.each { |i| ct += 1 if i.nil? }
    end
    ct
  end

  def match_across(which_axis = 'vertical')
    method_to_call = "#{which_axis}_data"
    send(method_to_call).each_value do |arr|
      uniq_vals = arr.uniq
      return uniq_vals.first if uniq_vals.count == 1 && !uniq_vals.first.nil?
    end
    nil
  end

  def vertical_data
    ret_hsh = {}
    @grid.each_key do |key|
      vals = @grid.map do |_, val|
        val[key]
      end
      ret_hsh[key] = vals
    end
    ret_hsh
  end

  # returns  hash containing forward and backward diagnoal data
  def diagonal_data
    ret_hsh = {}
    diagonal_coords.each do |k, arr|
      vals = arr.map do |sub_arr|
        @grid[sub_arr[0].to_s][sub_arr[1].to_s]
      end
      ret_hsh[k] = vals
    end
    ret_hsh
  end

  # returns hash of row data (as array)
  def horizontal_data
    ret_hsh = {}
    @grid.each do |k, v|
      ret_hsh[k] = v.values
    end
    ret_hsh
  end

  def to_a
    @grid.map { |_k, v| v.values }
  end

  def to_h
    @grid
  end

  def to_table
    arr = to_a.map { |a| a.map { |i| i.nil? ? BLANK_SPACE : i } }
    ct = 0
    Terminal::Table.new do |t|
      arr.each do |row|
        ct += 1
        t.add_row row
        t.add_separator unless ct == arr.count
      end
    end
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

  # coordinates not an intended public interface
  def diagonal_coords
    data_hsh = { forward: [], backward: [] }
    @width.times do |t|
      data_hsh[:forward].push([t + 1, t + 1])
      data_hsh[:backward].push([@width - t, t + 1])
    end
    data_hsh
  end
end
