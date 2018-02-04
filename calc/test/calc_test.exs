defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Calculator" do
    assert Calculator.eval("4 + 5") == 9
    assert Calculator.eval("5 * 1") == 5
    assert Calculator.eval("20 / 4") == 5
    assert Calculator.eval("24 / 6 + (5 - 4)") == 5
    assert Calculator.eval("1 + 3 * 3 + 1") == 11
    assert Calculator.eval("-1 + (2 * 3) + (4 / 2) * 3") == 11
    #assert Calculator.eval("(-3 - 6)*5+7-8/2") == -42
    assert Calculator.eval("(2+6* 3+5- (3*14/7+2)*5)+3") == -12
    assert Calculator.eval("2*(5+5*2)/3+(6/2+8)") == 21
    assert Calculator.eval("6-4 / 2") == 4
  end
end
