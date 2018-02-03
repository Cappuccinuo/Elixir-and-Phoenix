defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Calculator" do
    assert Calculator.eval("4 + 5") == 9
    assert Calculator.eval("5 * 1") == 5
    assert Calculator.eval("20 / 4") == 5
    assert Calculator.eval("24 / 6 + (5 - 4)") == 5
    assert Calculator.eval("1 + 3 * 3 + 1") == 11
  end
end
