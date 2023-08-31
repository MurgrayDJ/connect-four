

class Player
  attr_accessor :name
  attr_accessor :game_symbol

  def initialize(name, game_symbol)
    @name = name
    @game_symbol = game_symbol
  end
end