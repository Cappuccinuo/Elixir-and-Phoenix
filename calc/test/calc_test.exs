defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Calculator" do
    assert Calc.eval("4 + 5") == 9
  end
end
