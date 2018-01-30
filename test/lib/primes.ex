defmodule Primes do
  def is_prime?(x) do
    Stream.take_while(stream(), &(&1 <= :math.sqrt(x)))
    |> Enum.all?(&(rem(x, &1) != 0))
  end

  def stream() do
    a = [2,3,5,7]
    b = Stream.iterate(8, &(&1+1))  # & first argument of the function
        |> Stream.filter(&is_prime?/1)  # /1 Take one argument
    Stream.concat(a, b)
  end
end
