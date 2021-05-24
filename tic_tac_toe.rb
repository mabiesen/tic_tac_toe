#!/usr/bin/env ruby
# frozen_string_literal: true

require './grid'
require './player'

# simple tic-tac-toe game, cli based
class TicTacToe
  attr_accessor :grid, :players

  def initialize(player_one_str = 'X', player_two_str = 'O', grid_width = 3)
    raise 'Players cannot share the same game string' if player_one_str == player_two_str

    @grid = Grid.new(grid_width)
    @players = [Player.new(player_one_str, 1), Player.new(player_two_str, 2)]
  end

  # rubocop:disable Metrics/MethodLength
  def start
    intro
    puts @grid.to_table
    round = 1
    while game_still_going?
      current_player = which_player(round)
      puts "\n\nPlayer #{current_player.player_ordinal}, your move"
      row, col = coordinates_from_player
      @grid.update_square(row, col, current_player.game_string)
      puts @grid.to_table
      round += 1
    end
    outro
  end
  # rubocop:enable Metrics/MethodLength

  # Player 1 always starts
  def which_player(round)
    player_ordinal = (round % 2).positive? ? 1 : 2
    @players.find { |p| p.player_ordinal == player_ordinal }
  end

  # look for match across tic tac toe axes
  # if match exists, return the symbol of the match to indicate game 'winner'
  def symbol_if_winner_found
    match_across('horizontal') || match_across('vertical') || match_across('diagonal')
  end

  def game_still_going?
    !symbol_if_winner_found && @grid.count_blank_squares.positive?
  end

  # rubocop:disable Metrics/MethodLength
  def coordinates_from_player
    loop do
      puts 'Please supply the row to update (hint: first row is 1)'
      row = gets.chomp.to_i
      puts 'Please supply the column to update (hint: first col is 1)'
      col = gets.chomp.to_i
      begin
        validate_coordinates(row, col)
        return row, col
      rescue StandardError => e
        puts "#{e}\nLets try again"
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def validate_coordinates(row, col)
    raise 'Uh Oh! Rows and columns begin at 1.' if row.zero? || col.zero?

    raise 'Bummer! Column or row out of range' if row > @grid.width || col > @grid.width

    raise 'Whoops! Square is already occupied' if @grid.square_already_occupied?(row, col)
  end

  def intro
    puts 'You are about to play a game of tic tac toe!'
  end

  def outro
    puts "\n\n\nTHE GAME HAS COMPLETED"
    winner = symbol_if_winner_found
    if winner
      puts "The winner is player #{@players.find { |p| p.game_string == winner }.player_ordinal}"
    else
      puts 'Tie game!'
    end
    puts 'Thanks for playing!'
  end

  # look in grid for an axis that has all the same symbol
  # return that symbol, if match was found; else nil
  def match_across(which_axis = 'vertical')
    method_to_call = "#{which_axis}_data"
    @grid.send(method_to_call).each_value do |arr|
      uniq_vals = arr.uniq
      return uniq_vals.first if uniq_vals.count == 1 && !uniq_vals.first.nil?
    end
    nil
  end
end

if __FILE__ == $PROGRAM_NAME
  game = TicTacToe.new
  game.start
end
