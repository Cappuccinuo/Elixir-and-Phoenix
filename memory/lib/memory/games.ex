defmodule Memory.Game do
  def new do
    %{
      squares: shuffle_deck(),
      selected: [],
      pairs: [],
    }
  end

  def client_view(game) do
    sq = game.squares
    sl = game.selected
    pa = game.pairs
    %{
      turned: pa,
      card_num: length(sq),
      show: sl,
    }
  end

  def match(game, squares, selected, pairs) do
    if (length(selected) == 2) do
      [first | tail1] = selected
      [second | tail2] = tail1
      if (Enum.at(squares, first) == Enum.at(squares, second)) do
        pairs = pairs ++ [Enum.at(squares, first)] ++ [Enum.at(squares, second)]
      end
    end
    pairs
  end

  def test(game, card) do
    sq = game.squares
    if length(game.selected) == 2 do
      se = [card]
    else
      se = game.selected ++ [card]
    end
    pa = game.pairs
    if (length(se) == 2) do
      [first | tail1] = se
      [second | tail2] = tail1
      f = Enum.at(sq, first)
      s = Enum.at(sq, second)
      if (!Enum.member?(pa, f) and !Enum.member?(pa, s)) do
        if (Enum.at(sq, first) == Enum.at(sq, second)) do
          pa = pa ++ [Enum.at(sq, first)] ++ [Enum.at(sq, second)]
        end
      end
    end
    game = Map.put(game, :pairs, pa)
    Map.put(game, :selected, se)
  end

  def shuffle_deck do
    deck = ~w(
      A B C D E F G H
    )
    deck ++ deck
    #Enum.shuffle(deck ++ deck)
  end
end
