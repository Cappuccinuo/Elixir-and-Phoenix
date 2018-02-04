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
      {top, _bottom} = List.pop_at(temp, 0)
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
    Concat the digit that split apart
  """
  def concat_number_str(exp_list, new_list) do
    if length(exp_list) == 0 or length(exp_list) == 1 do
      if length(exp_list) == 0 do
        new_list
      else
        [head | _tail] = exp_list
        new_list ++ [head]
      end
    else
      [head1 | tail1] = exp_list
      [head2 | tail2] = tail1
      if is_integer(str_parse(head1)) and is_integer(str_parse(head2)) do
        concat_result = Enum.join([head1, head2], "")
        concat_number_str([concat_result] ++ tail2, new_list)
      else if is_binary(str_parse(head1)) and is_integer(str_parse(head2)) do
        concat_number_str(tail1, new_list ++ [head1])
      else if is_integer(str_parse(head1)) and is_binary(str_parse(head2)) do
        concat_number_str(tail2, new_list ++ [head1] ++ [head2])
      else if is_binary(str_parse(head1)) and is_binary(str_parse(head2)) do
        concat_number_str(tail2, new_list ++ [head1] ++ [head2])
      end
      end
      end
      end
    end
  end

  @doc """
    deal with the situation that first character is a "-"
  """
  def deal_first_neg(exp_list) do
    [head1 | tail1] = exp_list
    if head1 == "-" do
      [head2 | tail2] = tail1
      if is_integer(str_parse(head2)) do
        concat_number = Enum.join([head1, head2], "")
        [concat_number] ++ tail2
      else
        ["0"] ++ exp_list
      end
    else
      exp_list
    end
  end

  def deal_other_neg(exp_list, temp_list) do
    if length(exp_list) == 0 or length(exp_list) == 1 do
      if length(exp_list) == 0 do
        temp_list
      else
        [head | _tail] = exp_list
        temp_list ++ [head]
      end
    else
      [head1 | tail1] = exp_list
      if (head1 == "(") do
        [head2 | tail2] = tail1
        if head2 == "-" do
          deal_other_neg(tail2, temp_list ++ [head1] ++ ["0"] ++ [head2])
        end
      else
        deal_other_neg(tail1, temp_list ++ [head1])
      end
    end
  end

  @doc """
  if length(exp_list) == 0 or length(exp_list) == 1 do
    if length(exp_list) == 0 do
      temp_list
    else
      [head | _tail] = exp_list
      temp_list ++ [head]
    end
  end
    Given an expression
    1. remove all the space
    2. return all the characters in the string as a list
    3. as we will hit enter in the terminal and consider as a character, remove
    the enter.
    4. Concat the integer string that split up
    5. parse each character in the list
    6. build a postfix list using current expression list, an empty postfix list
    and an empty stack
    7. compute using postfix list
  """
  def eval(exp) do
    exp
    |> String.replace(" ", "")
    |> String.codepoints()
    |> List.delete("\n")
    |> concat_number_str([])
    |> deal_first_neg()
    #|> deal_other_neg([])
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
