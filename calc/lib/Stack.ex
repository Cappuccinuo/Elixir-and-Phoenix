defmodule Stack do
  defstruct elements: []

  def new, do: %Stack{}

  def push(stack, element) do
    %Stack{stack | elements: [element | stack.elements]}
  end

  def pop(%Stack{elements: []}), do: raise("Stack is empty!")
  def pop(%Stack{elements: [_top | rest]}) do
    %Stack{elements: rest}
  end

  def peek(%Stack{elements: elements}) do
    if length(elements) == 0 do
      :nil
    else
      [top | _rest] = elements
      top
    end
  end

  def isEmpty?(%Stack{elements: elements}) do
    if length(elements) == 0 do
      :true
    else
      :false
    end
  end

  def depth(%Stack{elements: elements}), do: length(elements)
end
