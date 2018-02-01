defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  @doc """
  Hello world.
  """
  @extract_non_parenthesis ~r/\(([^()]+)\)/    # capture the string without ()
  @extract_add ~r/(\d+)(\+)(\d+)/
  @extract_subtract ~r/(\d+)(\-)(\d+)/
  @extract_multiply ~r/(\d+)(\*)(\d+)/
  @extract_division ~r/(\d+)(\/)(\d+)/

  def replace_no_parathesis(equation) do
    Regex.replace(@extract_non_parenthesis, equation, fn _, portion -> compute_expression(portion) end)
  end

  def compute_expression(portion) do
    match_op(portion)
    |> Regex.replace(portion, fn _, a, op, b -> "#{compute(a, b, op)}" end)
  end

  def compute(a, b, op) do
    apply(Kernel, String.to_atom(op), [String.to_integer(a), String.to_integer(b)])
    |> round()
  end

  def op_regex(op) do
    case op do
      "+" -> @extract_add
      "-" -> @extract_subtract
      "*" -> @extract_multiply
      "/" -> @extract_division
    end
  end

  def match_op(portion) do
    cond do
      Regex.match?(@extract_add, portion) ->
        @extract_add
      Regex.match?(@extract_subtract, portion) ->
        @extract_subtract
      Regex.match?(@extract_multiply, portion) ->
        @extract_multiply
      Regex.match?(@extract_division, portion) ->
        @extract_division
    end
  end

  def eval(exp) do
    exp
    |> String.replace(" ", "")               # eliminate the space in expression
    |> replace_no_parathesis
  end

  def main do
    exp = IO.gets("> ")
    value = eval(exp)
    IO.puts("#{value}")
    main()
  end
end
