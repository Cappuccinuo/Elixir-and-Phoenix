defmodule Fib do
  def fib(0), do: 0
  def fib(1), do: 1
  def fib(x) do
    fib(x - 1) + fib(x - 2)
  end
end

defmodule Fac do
  def fact(x, acc) when x <= 1 do
    acc
  end
  def fact(x, acc) do
    fact(x - 1, x * acc)
  end
  def fact(x) do
    fact(x, 1)
  end
end
