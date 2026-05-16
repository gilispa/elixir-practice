defmodule UserStore do
  use GenServer

  def start_link(initial \\ %{}) do
    GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def put(username, age) do
    GenServer.cast(__MODULE__, {:put, username, age})
  end

  def get(username) do
    GenServer.call(__MODULE__, {:get, username})
  end

  def delete(username) do
    GenServer.call(__MODULE__, {:delete, username})
  end

  def all() do
    GenServer.call(__MODULE__, :all)
  end

  def init(initial) do
    {:ok, initial}
  end

  def handle_cast({:put, username, age}, state) do
    new_state = Map.put(state, username, age)
    {:noreply, new_state}
  end

  def handle_call({:get, username}, _from, state) do
    {:reply, Map.get(state, username), state}
  end

  def handle_call({:delete, username}, _from, state) do
    {value, new_state} = Map.pop(state, username)
    {:reply, value, new_state}
  end

  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end
end

defmodule UserStoreSupervisor do
  use Supervisor

  def start_link(init_arg \\ %{}) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(initial) do
    children = [
      {UserStore, initial}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
