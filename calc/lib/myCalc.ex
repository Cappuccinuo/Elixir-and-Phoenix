defmodule MyCalculator do
  @moduledoc """
  This is a calculator that can deal with `+`, `-`, `*`, `/` support negative
  number and parentheses.
  https://leetcode.com/problems/basic-calculator-iii/discuss/113590
  """
  @operator ["+", "-", "*", "/"]
  @round_precision 3

  @doc """
  Main function of the application.
  """
  def main do
    exp = IO.gets("Please input the expression: > ")
    exp
    |> eval()
    |> IO.puts
    main()
  end

  @doc """
  Function to evaluate the string expression.
  GIVEN   : a string expression \n
  RETURNS : the result of the string expression
  """
  def eval(exp) do
    exp
    |> String.replace(" ", "")             # remove all the space
    |> String.codepoints                   # return all the characters in
                                           # the exp string as a list
    |> List.delete("\n")                   # Delete the "\n"
    |> build(0, "+", Stack.new, Stack.new) # First stack: store digit and "("
                                           # Second stack: store op before "("
    |> get_sum                             # Sum up all the num in numStack
  end

  @doc """
  The function to build the number stack and operation stack.\n
  GIVEN   : the expression list (like the character array in Java), current num,
  current operation, a number stack, an operation stack \n
  RETURNS : a stack of numbers

  ## Examples

      iex> MyCalculator.build(["1", "-", "2", "+", "3"], 0, "+", %Stack{elements: []}, %Stack{elements: []})
      %Stack{elements: [3, -2, 1]}

  """
  def build(exp_list, num, op, numStack, opStack) do
    if length(exp_list) == 0 do
      compute(op, num, numStack)
    else
      stack_establish(exp_list, num, op, numStack, opStack)
    end
  end

  @doc """
  Get the sum of all the elements in the stack\n
  GIVEN   :  a stack of numbers \n
  RETURNS :  the rounded sum of all the numbers in the stack

  ## Examples

      iex> MyCalculator.get_sum(%Stack{elements: [1,2,3,4]})
      10

      iex> MyCalculator.get_sum(%Stack{elements: [1,2,3,4.5578]})
      10.558
  """
  def get_sum(numStack) do
    numStack
    |> Stack.getSum(0, Stack.size(numStack))
    |> round_number
  end

  @doc """
  Round a number.\n
  GIVEN    : a number \n
  RETURNS  : the rounded result of the number \n
  Note     : when the num is integer, just return the num.
  """
  def round_number(num) do
    case is_integer(num) do
      :true -> num
      :false -> Float.round(num, @round_precision)
    end
  end

  @doc """
  Parse a string to integer if possible.
  GIVEN   : a string\n
  RETURNS :
  1. If the string contains an integer, return the integer;\n
  2. Else return the original string.

  ## Examples

      iex> MyCalculator.str_parse("1")
      1

      iex> MyCalculator.str_parse("(")
      "("

  """
  def str_parse(str) do
    case Integer.parse(str) do
      {num, _} -> num
      :error -> str
    end
  end

  @doc """
  Deal with different situation when build the stack.\n
  Case 1 : Keep adding digit * base + num based on current num\n
  Case 2 : `(` push operator in opStack, push `(` in numStack\n
  Case 3 : `)` sum value before `(` in the numStack\n
  Case 4 : Operator: update stack based on operator\n
  Case 4.1 : `+` push num\n
  Case 4.2 : `-` push -num\n
  Case 4.3 : `*` push (numStack.pop() * num)\n
  Case 4.4 : `/` push (numStack.pop() / num)\n
  Case 5 : Space, continue to the rest of exp_list, although I handle this situation before by replace the space in exp_list
  """
  def stack_establish(exp_list, num, op, numStack, opStack) do
    [current | tail] = exp_list
    parse_curr = str_parse(current)
    is_operator = Enum.member?(@operator, parse_curr)
    case parse_curr do
      int when is_integer(int) ->
        deal_int(tail, num, op, numStack, opStack, parse_curr)
      "(" -> deal_left_para(tail, num, op, numStack, opStack)
      ")" -> deal_right_para(tail, num, op, numStack, opStack)
      # " " -> build(tail, num, op, numStack, opStack)
      _operat when is_operator ->
        deal_operator(tail, num, op, numStack, opStack, parse_curr)
    end
  end

  @doc """
  Deal with the situation when come up with operators
  """
  def deal_operator(exp_list, num, op, numStack, opStack, next_op) do
    # Calculate current operator's result, then use the next_op for next build
    current_stack = compute(op, num, numStack)
    build(exp_list, 0, next_op, current_stack, opStack)
  end

  @doc """
  Deal with the situation when come up with `(`
  """
  def deal_left_para(exp_list, num, op, numStack, opStack) do
    # Push "(" in the stack for the future calculation of expression in ()
    update_numStack = Stack.push(numStack, "(")
    # Push the operator before "(" for the future calculation
    update_opStack = Stack.push(opStack, op)
    build(exp_list, num, "+", update_numStack, update_opStack)
  end

  @doc """
  Deal with the situation when come up with a integer
  """
  def deal_int(exp_list, num, op, numStack, opStack, current_digit) do
    # Deal with the situation ["1", "2", "3", "+", "4", "5", "6"]
    update_num = 10 * num + current_digit
    build(exp_list, update_num, op, numStack, opStack)
  end

  @doc """
  Deal with the situation when come up with `)`
  """
  def deal_right_para(exp_list, num, op, numStack, opStack) do
    current_stack = compute(op, num, numStack)
    left_para_index = Stack.find_index(current_stack, "(")
    value_in_para = Stack.getSum(current_stack, 0, left_para_index)
    update_stack = Stack.popFirstK(current_stack, left_para_index + 1)
    update_op = Stack.peek(opStack)
    build(exp_list, value_in_para, update_op, update_stack, Stack.pop(opStack))
  end

  @doc """
  Compute next number to push into stack.
  GIVEN   : an operation string, current number, and the nums stack\n
  RETURNS : The new stack after execute the operation\n
  Note    : If the operation is `+`, push the num to numStack, cause we will add all the number in the numStack together \n
  If the operation is `-`, it is equal to add a negative number, so push the inverse sign number to numStack \n
  If the operation is `*` or `/`, we need to calculate first, so first operate with current numStack top, then push the result to the numStack

  ## Examples

      iex> MyCalculator.compute("+", 2, %Stack{elements: [10,20,30,40]})
      %Stack{elements: [2, 10, 20, 30, 40]}

      iex> MyCalculator.compute("-", 2, %Stack{elements: [10,20,30,40]})
      %Stack{elements: [-2, 10, 20, 30, 40]}

      iex> MyCalculator.compute("*", 2, %Stack{elements: [10,20,30,40]})
      %Stack{elements: [20, 20, 30, 40]}

      iex> MyCalculator.compute("/", 2, %Stack{elements: [10,20,30,40]})
      %Stack{elements: [5.0, 20, 30, 40]}

  """
  def compute(op, number, numStack) do
    case op do
      "+" ->
        num = number
        Stack.push(numStack, num)
      "-" ->
        num = -number
        Stack.push(numStack, num)
      "*" ->
        update_num = multiply(number, numStack)
        Stack.push(Stack.pop(numStack), update_num)
      "/" ->
        update_num = divide(number, numStack)
        Stack.push(Stack.pop(numStack), update_num)
    end
  end

  @doc """
  Execute the multiplication result.
  GIVEN   : a number and a stack\n
  WHERE   : the top of the stack is a integer\n
  RETURNS : The product of given number and the top element of the stack

  ## Examples

      iex> MyCalculator.multiply(1, %Stack{elements: [10,2,3,4]})
      10

  """
  def multiply(number, numStack) do
    Stack.peek(numStack) * number
  end

  @doc """
  Execute the division result.
  GIVEN   : a number and a stack\n
  WHERE   : the top of the stack is a integer\n
  RETURNS : The quotient of given number and the top element of the stack

  ## Examples

      iex> MyCalculator.divide(5, %Stack{elements: [10,3,4]})
      2.0

  """
  def divide(number, numStack) do
    Stack.peek(numStack) / number
  end
end
