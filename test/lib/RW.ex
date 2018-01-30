defmodule RW do
  # Reverse the words in a string
  def demo() do
    line = IO.gets("> ")
    revword = reverse_words(line)
    IO.puts("<<#{revword}")
    demo()   # loop the demo
  end

  def reverse_words(text) do
    String.trim(text)
    |> String.split(" ")
    |> Enum.reverse()
    |> Enum.join(" ")
    # Enum.join(Enum.reverse(String.split(String.trim(text), " ")), " ")
  end
end
