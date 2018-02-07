defmodule Memory.Game do
  def new do
    %{
      squares: shuffle_deck(),
      pairs: [],
    }
  end

  def client_view(game) do
    sq = game.squares
    sl = game.selected
    %{
      selected: [],
    }
  end

  def match(squares, selected) do
    if length(selected) == 2 do
      [first | second] = selected
      if Enum.at(squares, first) == Enum.at(squares, second) do
        pairs ++ selected
      end
    end
  end

  def shuffle_deck do
    deck = ~w(
      A B C D E F G H
    )
    Enum.shuffle(deck ++ deck)
  end
end
