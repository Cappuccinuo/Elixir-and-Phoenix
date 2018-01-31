defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  @doc """
  Hello world.
  """
  @inner_parens_regex ~r/\(([^()]+)\)/
  def execute(a, b, "+") do
    a + b
  end

  def execute(a, b, "-") do
    a - b
  end

  def execute(a, b, "*") do
    a * b
  end

  def execute(a, b, "/") do
    a / b   # deal with 0
  end

  def eval(exp) do
    [a, op, b] = String.split(exp)
    a = String.to_integer(a)
    b = String.to_integer(b)
    execute(a, b, op)
  end

  def main do
    exp = IO.gets("> ")
    value = eval(exp)
    IO.puts("#{value}")
    main()
  end
end
