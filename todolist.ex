defmodule TodoList do
  use Agent

  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_task(task) do
    Agent.update(__MODULE__, fn tasks ->
      tasks ++ [task]
    end)
  end

  def all() do
    Agent.get(__MODULE__, fn tasks -> tasks end)
  end

  def count() do
    Agent.get(__MODULE__, fn tasks ->
      length(tasks)
    end)
  end

  def remove_task(index) do
    Agent.update(__MODULE__, fn tasks ->
      List.delete_at(tasks, index)
    end)
  end
end
