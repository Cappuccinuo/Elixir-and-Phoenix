defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Helper Function" do
    assert MyCalculator.build(["1", "-", "2", "+", "3"], 0, "+",
                            %Stack{elements: []}, %Stack{elements: []})
                                == %Stack{elements: [3, -2, 1]}
    assert MyCalculator.get_sum(%Stack{elements: [1,2,3,4]}) == 10
    assert MyCalculator.get_sum(%Stack{elements: [1,2,3,4.5578]}) == 10.558
    assert MyCalculator.str_parse("1") == 1
    assert MyCalculator.str_parse("(") == "("
    assert MyCalculator.compute("+", 2, %Stack{elements: [10,20,30,40]})
                         == %Stack{elements: [2, 10, 20, 30, 40]}
    assert MyCalculator.compute("-", 2, %Stack{elements: [10,20,30,40]})
                         == %Stack{elements: [-2, 10, 20, 30, 40]}
    assert MyCalculator.compute("*", 2, %Stack{elements: [10,20,30,40]})
                         == %Stack{elements: [20, 20, 30, 40]}
    assert MyCalculator.compute("/", 2, %Stack{elements: [10,20,30,40]})
                         == %Stack{elements: [5.0, 20, 30, 40]}
    assert MyCalculator.multiply(1, %Stack{elements: [10,2,3,4]}) == 10
    assert MyCalculator.divide(5, %Stack{elements: [10,3,4]}) == 2.0
  end

  test "MyCalculator" do
    assert MyCalculator.eval("4 + 5") == 9
    assert MyCalculator.eval("5 * 1") == 5
    assert MyCalculator.eval("20 / 4") == 5
    assert MyCalculator.eval("24 / 6 + (5 - 4)") == 5
    assert MyCalculator.eval("1 + 3 * 3 + 1") == 11
    assert MyCalculator.eval("-1 + (2 * 3) + (4 / 2) * 3") == 11
    assert MyCalculator.eval("(-3 - 6)*5+7-8/2") == -42
    assert MyCalculator.eval("(2+6* 3+5- (3*14/7+2)*5)+3") == -12
    assert MyCalculator.eval("2*(5+5*2)/3+(6/2+8)") == 21
    assert MyCalculator.eval("6-4 / 2") == 4
    assert MyCalculator.eval("-7-2-3     -4-5-6   +(3*6-7 -(9/3)/(4+2+(5*9)))") == -16.059
  end
end
