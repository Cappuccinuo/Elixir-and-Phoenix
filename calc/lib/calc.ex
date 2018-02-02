defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  @doc """
  Hello world.
  """
  @extract_non_parenthesis ~r/\(([^()]+)\)/    # capture the string without ()
  @extract_add ~r/(\d+)(\+)(\d+)/
  @extract_add2 ~r/(\d+)(\-\-)(\d+)/
  @extract_subtract ~r/(\d+)(\-)(\d+)/
  @extract_subtract2 ~r/(\d+)(\+\-)(\d+)/
  @extract_multiply ~r/(\d+)(\*)(\d+)/
  @extract_division ~r/(\d+)(\/)(\d+)/

  def compute_portion(portion) do
    Regex.replace(@extract_non_parenthesis, portion, fn _, portion -> solve_portion(portion, :begin) end)
  end

  def compute_expression(portion, op) do
    regex = op_regex(op)
    Regex.replace(regex, portion, fn _, a, op, b -> "#{compute(a, b, op)}" end)
  end

  def compute(a, b, op) do
    if op == "+-" do
      op = "-"
    end
    if op == "--" do
      op = "+"
    end
    apply(Kernel, String.to_atom(op), [String.to_integer(a), String.to_integer(b)])
    |> round()
  end

  def solve_equation(equation, :unmatch) do
    equation
  end

  def solve_equation(equation, :match) do
    solve_equation(compute_portion(equation), match_regex?(equation, @extract_non_parenthesis))
  end

  def solve_portion(portion, :begin) do
    solve_portion(portion, "*", :on)
  end

  def solve_portion(portion, :off) do
    portion
  end

  def solve_portion(portion, op, :on) do
    solve_portion(portion, op, match_regex?(portion, op_regex(op)))
  end

  def solve_portion(portion, op, :match) do
    solve_portion(compute_expression(portion, op), op, :on)
  end

  def solve_portion(portion, "*", :unmatch) do
    solve_portion(portion, "/", :on)
  end

  def solve_portion(portion, "/", :unmatch) do
    solve_portion(portion, "+", :on)
  end

  def solve_portion(portion, "+", :unmatch) do
    solve_portion(portion, "+-", :on)
  end

  def solve_portion(portion, "+-", :unmatch) do
    solve_portion(portion, "--", :on)
  end

  def solve_portion(portion, "--", :unmatch) do
    solve_portion(portion, "-", :on)
  end

  def solve_portion(portion, "-", :unmatch) do
    solve_portion(portion, :off)
  end

  def match_regex?(portion, regex) do
    case Regex.match?(regex, portion) do
      true -> :match
      false -> :unmatch
    end
  end

  def op_regex(op) do
    case op do
      "+" -> @extract_add
      "+-" -> @extract_subtract2
      "--" -> @extract_add2
      "-" -> @extract_subtract
      "*" -> @extract_multiply
      "/" -> @extract_division
    end
  end

  def eval(exp) do
    "(#{exp})"
    |> String.replace(" ", "")               # eliminate the space in expression
    |> solve_equation(:match)
  end

  def main do
    exp = IO.gets("> ")
    value = eval(exp)
    IO.puts("#{value}")
    main()
  end
end
