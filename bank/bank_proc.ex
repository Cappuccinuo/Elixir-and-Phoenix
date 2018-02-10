defmodule BankProc do
  # A bank account has
  # - Owner's name
  # - Balance

  # A bank is a set of accounts
  # %{ name => balance }

  # - deposit
  # - withdraw
  # - check balance
  # - transfer

  # elixirc *
  # bank = BankProc.start
  # send
  # in iex    c("bank_proc.ex")
  # flush()
  # :observer.start

  def start do
    spawn(__MODULE__, :init, [])
  end

  def init do
    state = %{"Yuan" => 10000}
    loop(state)
  end

  def add_balance(state, name, amt) do
    bal0 = state[name] || 0
    Map.put(state, name, bal0 + amt)
  end

  def get_balance(state, name) do
    state[name] || 0
  end

  def loop(state) do
    receive do
      {:check, name, from} ->
        IO.inspect state[name]
        send(from, {:balance, name, state[name]})
        loop(state)
      {:deposit, name, amt} ->
        add_balance(state, name, amt)
        |> loop
      {:withdraw, name, amt} ->
        add_balance(state, name, -amt)
        |> loop
      {:transfer, name1, name2, amt} ->
        if get_balance(state, name1) >= amt do
          add_balance(state, name1, -amt)
          |> add_balance(name2, amt)
          |> loop
        else
          raise "Sorry, you're broke"
        end
    end
  end
end
