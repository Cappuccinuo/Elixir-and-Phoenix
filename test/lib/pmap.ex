defmodule Pmap do
  def pmap(xs, op) do
    tasks = Enum.map xs, fn x -> Task.async(fn -> op.(x) end) end
    Enums.map tasks, fn t -> Task.await(t, 10000) end
  end

  def work(x) do
    {text, _} = System.cmd("sh", ["-c", "(sleep 2 && echo hi #{x})"])
    IO.puts(text)
  end

  def seq_demo() do
    Enum.map [1,2,3,4], fn x -> work(x) end
  end

  # :timer.tc(&Pmap.par_demo/0)
  def par_demo() do
    pmap [1,2,3,4], fn x -> work(x) end
  end
end
