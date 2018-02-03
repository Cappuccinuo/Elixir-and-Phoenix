defmodule Tick do
  def start() do
    state0 = %{ text: "hello" }
    spawn(__MODULE__, :init, [state0])
  end

  def schedule_tick() do
    Process.send_after(self(), :tick, 2000)
  end

  def init(state) do
    schedule_tick()
    loop(state)
  end

  def loop(state) do
    # send(pid, {:set_text, "New text goes here"})
    receive do
      :tick ->
        IO.puts "tick: #{state.text}"
        schedule_tick()
        loop(state)
      {:set_text, new_text} ->
        loop( %{ state | text: new_text })
    end

  end
end
