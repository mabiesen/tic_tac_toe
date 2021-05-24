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
  def start_game
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

  def game_still_going?
    !@grid.symbol_if_match_exists && @grid.count_blank_squares.positive?
  end

  def coordinates_from_player
    loop do
      puts 'Please supply the row to update (hint: first row is 1)'
      row = gets.chomp
      puts 'Please supply the column to update (hint: first col is 1)'
      col = gets.chomp

      return row, col unless @grid.square_already_occupied?(row, col)

      puts 'Whoops! Looks like that square is already occupied'
      puts 'OR maybe there was a typo with your coordinate selection'
      puts 'Lets try again'
    end
  end

  def intro
    puts 'You are about to play a game of tic tac toe!'
  end

  def outro
    puts "\n\n\nTHE GAME HAS COMPLETED"
    winner = @grid.symbol_if_match_exists
    if winner
      puts "The winner is player #{@players.find { |p| p.game_string == winner }.player_ordinal}"
    else
      puts 'Tie game!'
    end
    puts 'Thanks for playing!'
  end
end

if __FILE__ == $PROGRAM_NAME
  game = TicTacToe.new
  game.start_game
end
