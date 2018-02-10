defmodule Stack do
  # maintain state
  use Agent

  def start_link do
    Agent.start_link(fn -> [] end)
  end

  def push(pid, vv) do
    Agent.update pid, fn stack ->
      [ vv | stack ]
    end
  end

  def pop(pid) do
    Agent.get_and_update pid, fn stack ->
      { hd(stack), tl(stack) }
    end
  end
end
