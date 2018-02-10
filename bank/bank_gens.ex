defmodule BankGens do
  use GenServer

  # Interface: runs in caller process
  def start_link() do
    st0 = %{"Yuan" => 10000}
    GenServer.start_link(__MODULE__, %{"Yuan" => 10000}, name: __MODULE__)
  end

  def deposit(name, amt) do
    GenServer.cast(__MODULE__, {:deposit, name, amt})
  end

  def withdraw(name, amt) do
    GenServer.cast(__MODULE__, {:withdraw, name, amt})
  end

  def check(name) do
    GenServer.call(__MODULE__, {:check, name})
  end

  def init(args) do
      {:ok, args}
  end

  def add_balance(state, name, amt) do
    bal0 = state[name] || 0
    Map.put(state, name, bal0 + amt)
  end

  def get_balance(state, name) do
    state[name] || 0
  end

  def handle_cast({:deposit, name, amt}, state) do
    state1 = add_balance(state, name, amt)
    {:noreply, state1}
  end

  def handle_cast({:withdraw, name, amt}, state) do
    state1 = add_balance(state, name, -amt)
    {:noreply, state1}
  end

  def handel_call({:check, name}, _from, state) do
    bal = state[name]
    {:reply, bal, state}
  end

  def handle_call({:transfer, name1, name2, amt}, _from, state) do
    if get_balance(state, name1) >= amt do
      state1 = state
      |> add_balance(name1, -amt)
      |> add_balance(name2, amt)
      {:reply, :ok, state1}
    else
      {:reply, {:error, "Sorry, you're broke"}, state}
    end
  end

  # def handle_info
end
