defmodule Memory.Game do
  def new do
    %{
      squares: shuffle_deck(),
      cards: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
      selected: [],   # selected index
      scard: [],      # selected card
      pairs: [],      # pairs card
      indices: [],    # pairs index
      moves: 0,
    }
  end

  def client_view(game) do
    sq = game.squares
    sl = game.selected
    si = game.scard
    pa = game.pairs
    ind = game.indices
    ca = game.cards
    mv = game.moves
    %{
      tests: skeleton(sq, ca, ind, sl),
      turned: pa,
      index: ind,
      show: sl,
      step: mv
    }
  end

  def set(game, flag) do
    if flag == true do
      game = Map.put(game, :selected, [])
      Map.put(game, :scard, [])
    end
  end

  def reset(game, flag) do
    if flag == true do
      game = new() 
    end
  end

  def skeleton(squares, cards, indices, selected) do
    Enum.map cards, fn i ->
      if Enum.member?(selected, i) or Enum.member?(indices, i) do
        Enum.at(squares, i)
      else
        "?"
      end
    end
  end

  def test(game, card) do
    sq = game.squares
    ind = game.indices
    mv = game.moves
    if length(game.selected) == 2 do
      se = [card]
      sc = [Enum.at(sq, card)]
    else
      se = game.selected ++ [card]
      sc = game.scard ++ [Enum.at(sq, card)]
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
          ind = ind ++ [first] ++ [second]
        end
      end
    end
    game = Map.put(game, :pairs, pa)
    game = Map.put(game, :indices, ind)
    game = Map.put(game, :selected, se)
    game = Map.put(game, :moves, mv + 1)
    Map.put(game, :scard, sc)
  end

  def shuffle_deck do
    deck = ~w(
      A B C D E F G H
    )
    deck ++ deck
    Enum.shuffle(deck ++ deck)
  end
end
