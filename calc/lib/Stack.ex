defmodule Stack do
  @moduledoc """
  A Stack data structure.
  """
  defstruct elements: []

  @doc """
  Return a new Stack with empty elements

  ## Examples

      iex> Stack.new
      %Stack{elements: []}

  """
  def new, do: %Stack{}

  @doc """
  Push an element into given stack.\n
  Given   :   a stack, and an element\n
  RETURNS :   push the element in the stack's elements

  ## Examples

      iex> Stack.push(Stack.new, 2)
      %Stack{elements: [2]}

  """
  def push(stack, element) do
    %Stack{stack | elements: [element | stack.elements]}
  end

  @doc """
  Pop the top element of given stack.\n
  GIVEN    :  a stack\n
  RETURNS  :  the stack with the original top one removed

  ## Examples

      iex> Stack.pop(%Stack{elements: [2, 1]})
      %Stack{elements: [1]}

      iex> Stack.pop(%Stack{elements: []})
      ** (RuntimeError) Stack is empty!

  """
  def pop(%Stack{elements: []}), do: raise("Stack is empty!")
  def pop(%Stack{elements: [_top | rest]}) do
    %Stack{elements: rest}
  end

  @doc """
  Pop the top k elements of given stack.\n
  GIVEN    :  a stack and a number k\n
  RETURNS  :  the stack with the original top k elements removed

  ## Examples

      iex> Stack.popFirstK(%Stack{elements: [2, 1, 4, 7, 8]}, 3)
      %Stack{elements: [7, 8]}

  """
  def popFirstK(%Stack{elements: elements}, k) do
    {_, tail} = Enum.split(elements, k)
    %Stack{elements: tail}
  end

  @doc """
  Get the top element of given stack.\n
  GIVEN    :  a stack\n
  RETURNS  :  the top element of the stack

  ## Examples

      iex> Stack.peek(%Stack{elements: [2, 1, 4, 7, 8]})
      2

  """
  def peek(%Stack{elements: elements}) do
    if length(elements) == 0 do
      :nil
    else
      [top | _rest] = elements
      top
    end
  end

  @doc """
  Get the index of given target in the stack.\n
  GIVEN   : a stack, and the target to find\n
  RETURNS : the index of the first target(0 index-based)

  ## Examples

      iex> Stack.find_index(%Stack{elements: [2, 1, 4, 7, 8]}, 4)
      2

  """
  def find_index(%Stack{elements: elements}, target) do
    Enum.find_index(elements, fn x -> x == target end)
  end

  @doc """
  Get the sum of the elements in stack from index a to index b.\n
  GIVEN   : a stack and a range start a, a range end b\n
  RETURNS : the sum of elements between a and b

  ## Examples

      iex> Stack.getSum(%Stack{elements: [2, 1, 4, 7, 8]}, 1,3)
      12

  """
  def getSum(%Stack{elements: elements}, a, b) do
    Enum.slice(elements, a, b)
    |> Enum.sum
  end

  @doc """
  Judge if the stack is empty or not.\n
  GIVEN   : a stack\n
  RETURNS : true iff the stack is empty

  ## Examples

      iex> Stack.isEmpty?(%Stack{elements: [2, 1, 4, 7, 8]})
      false

      iex> Stack.isEmpty?(%Stack{elements: []})
      true

  """
  def isEmpty?(%Stack{elements: elements}) do
    if length(elements) == 0 do
      :true
    else
      :false
    end
  end

  @doc """
  Get the size of given stack.\n
  GIVEN   : a stack\n
  RETURNS : the size of the stack

  ## Examples

      iex> Stack.size(%Stack{elements: [2, 1, 4, 7, 8]})
      5

  """
  def size(%Stack{elements: elements}), do: length(elements)
end
