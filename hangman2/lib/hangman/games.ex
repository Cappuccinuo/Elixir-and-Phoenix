defmodule Hangman.Game do
  # Plan A : Store the game as part of the state of the channel.
  # (Game is in socket.assigns map)

  # Advantages:
  #  - Game lasts exactly as long as channel
  #    - No resource leak.
  #  - Scales well - games are entirely independent
  # Disadvantages:
  #  - Crash kills channel, resets game.
  #  - Game lasts exactly as long as channel.
  #    - Data loss on disconnect

  # Plan B : GenServer, registered name, Get / Put ops
  # Advantages:
  #  - Game state is stored independantly from channel.
  #    - Immune to crashes, persistant across disconnects.
  # Disadvantages:
  #  - Scales poorly. All data in one process.
  #    - Update still happens in channel, so could be worse
  #  - We have data races. A = get, B = get, put A, put B
  #  - Memory leak. Games are never deleted.

  # Plan C : One global Agent with a map.
  # Just like plan B except:
  #  - Modifications are sequential in Agent process.
  #  - No data races.
  #  - Slower

  # Plan D : One Agent Per Game, Global game => Agent PID map
  #  - Only need to access global map once/channel
  #    - Otherwise, entirely independant.
  #  - Resource leaks are slightly worse than before.
  #  - Crash still kills that game's data

  # Plan E : One global agent with a map, put/get ops, treat as backup.
  #  - Primary game copy stored in channel.
  #  - Can recover from crash or disconnect.
  #  - Still leak resources.
  #  - There's an edge case data race.
  #  - Different players of the same game get separate states.
  def new do
    %{
      word: next_word(),
      guesses: [],
    }
  end

  def client_view(game) do
    ws = String.graphemes(game.word)
    gs = game.guesses
    %{
      skel: skeleton(ws, gs),
      goods: Enum.filter(gs, &(Enum.member?(ws, &1))),
      bads: Enum.filter(gs, &(!Enum.member?(ws, &1))),
      max: max_guesses(),
    }
  end

  def skeleton(word, guesses) do
    Enum.map word, fn cc ->
      if Enum.member?(guesses, cc) do
        cc
      else
        "_"
      end
    end
  end

  def guess(game, letter) do
    if letter == "z" do
      raise "That's not a real letter"
    end

    gs = game.guesses
    |> MapSet.new()
    |> MapSet.put(letter)
    |> MapSet.to_list

    Map.put(game, :guesses, gs)
  end

  def max_guesses do
    10
  end

  def next_word do
    # ~w() generate lists of words
    words = ~w(
      horse snake jazz violin
      muffin cookie pizza sandwich
      house train clock
      parsnip marshmallow
    )
    Enum.random(words)
  end
end
