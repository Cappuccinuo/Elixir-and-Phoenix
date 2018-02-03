import Stack
defmodule Calculator do
  @moduledoc """
  Basic idea: convert the infix expression to the postfix expression.
  Reference: https://leetcode.com/problems/basic-calculator-iii/discuss/113598/
  Lets look at (2+3)/(4*5)
    (1) The '(' is pushed.
    (2) The 2 is added to the output.
    (3) The '+' is pushed on the stack.
    (4) The 3 is added to the out; its now 23.
    (5) The ')' triggers the '+' to be popped and added to output; its now 23+.
    (6) The '(' is popped and discarded.
    (7) The '/' is pushed.
    (8) The '(' is pushed.
    (9) The 4 is added to the output; its now 23+4
    (10) The "*" is pushed.
    (11) The 5 is added to the output; its now 23+45
    (12) The  ')' triggers the '*' to be popped and added to output; its now 23+45*
    (13) The eoln is now true, so if no invalid characters have been encountered.
    all the tokens remaining on the stack are popped  and added to the output; its now  23+45*/
    Now that you have the postfix string, you simply compute the result every
    time you see an operator (using top 2 numbers from stack), then push the
    result back to the stack. Since the expression is guaranteed to be valid,
    the stack will eventually end up with 1 element and that is the result.
  """
  @priority %{"*" => 1, "/" => 1, "+" => 2, "-" => 2}

  @doc """
    build the postfix list
  """

  def build_postfix(exp_list, postfix, ops) do
    if length(exp_list) == 0 do
      push_ops(postfix, ops)
    else
      [head | tail] = exp_list
      if is_integer(head) do
        build_postfix(tail, postfix ++ [head], ops)
      else
        if is_binary(head) and !Stack.isEmpty?(ops) do
          build_postfix_op(exp_list, postfix, ops)
        else
          build_postfix(tail, postfix, Stack.push(ops, head))
        end
      end
    end
  end

  @doc """
    build the postfix list when the head of current expression list is an
    operation, and the ops stack is not empty
  """

  def build_postfix_op(exp_list, postfix, ops) do
    current_op = Stack.peek(ops)
    [current_val | tail] = exp_list
    if (current_val == "(") do
      build_postfix(tail, postfix, Stack.push(ops, current_val))
    else if current_val == ")" and current_op != "(" do
      build_postfix(exp_list, postfix ++ [current_op], Stack.pop(ops))
    else if current_val == ")" and current_op == "(" do
      build_postfix(tail, postfix, Stack.pop(ops))
    else if current_val != "(" and @priority[current_op] < @priority[current_val] do
      build_postfix(exp_list, postfix ++ [current_op], Stack.pop(ops))
    else
      build_postfix(tail, postfix, Stack.push(ops, current_val))
    end
    end
    end
    end
  end

  @doc """
    When the operation stack is not empty, keep pushing the peek to postfix
  """

  def push_ops(postfix, ops) do
    if Stack.isEmpty?(ops) do
      postfix
    else
      push_ops(postfix ++ [Stack.peek(ops)], Stack.pop(ops))
    end
  end

  @doc """
    Calculate using postfix
  """
  def compute(postfix, temp) do
    if length(postfix) == 0 do
      {top, bottom} = List.pop_at(temp, 0)
      top
    else
      [current_val | tail] = postfix
      if is_integer(current_val) do
        compute(tail, [current_val] ++ temp)
      else
        compute_portion(postfix, temp)
      end
    end
  end

  @doc """
    When the postfix is not empty, calculate using the top two elements in
    temp, and push the result to temp
  """
  def compute_portion(postfix, temp) do
    [op | tail] = postfix
    {top1, bottom1} = List.pop_at(temp, 0)
    {top2, bottom2} = List.pop_at(bottom1, 0)
    case op do
      "*" -> compute(tail, [top2 * top1] ++ bottom2)
      "/" -> compute(tail, [top2 / top1] ++ bottom2)
      "+" -> compute(tail, [top2 + top1] ++ bottom2)
      "-" -> compute(tail, [top2 - top1] ++ bottom2)
    end
  end

  @doc """
    If the string is a integer string, transform it to a integer
    Otherwise return current str(operation)
  """

  def str_parse(str) do
    case Integer.parse(str) do
      {num, _} -> num
      :error -> str
    end
  end

  @doc """
    Given an expression
    1. remove all the space
    2. return all the characters in the string as a list
    3. as we will hit enter in the terminal and consider as a character, remove
    the enter.
    4. parse each character in the list
    5. build a postfix list using current expression list, an empty postfix list
    and an empty stack
    6. compute using postfix list
  """
  def eval(exp) do
    exp
    |> String.replace(" ", "")
    |> String.codepoints()
    |> List.delete("\n")
    |> Enum.map(&str_parse/1)
    |> build_postfix([], Stack.new)
    |> compute([])
  end

  @doc """
    main function, loop forever
  """
  def main do
    exp = IO.gets("> ")
    exp
    |> eval()
    |> IO.puts
    main()
  end

end
