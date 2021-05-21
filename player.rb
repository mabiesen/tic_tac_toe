class Player
  attr_accessor :game_string, :player_ordinal

  # game string traditionally X/O
  # player ordinal indicates order of moves
  def initialize(game_string, player_ordinal)
    @game_string = game_string
    @player_ordinal = player_ordinal
  end
end
