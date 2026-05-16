defmodule Inventory do
  defmodule Item do
    defstruct [:name, :price, :stock]
  end

  def new(), do: []

  def add_item(inventory, name, price, stock)
      when is_list(inventory) and is_binary(name) and is_number(price) and is_integer(stock) and
             stock >= 0 do
    item = %Item{name: name, price: price, stock: stock}
    inventory ++ [item]
  end

  def add_item(_inventory, _name, _price, _stock) do
    {:error, "Datos inválidos"}
  end

  def total_items(inventory) when is_list(inventory) do
    Enum.reduce(inventory, 0, fn item, acc -> acc + item.stock end)
  end

  def total_value(inventory) when is_list(inventory) do
    Enum.reduce(inventory, 0, fn item, acc -> acc + item.price * item.stock end)
  end

  def find_item(inventory, name) when is_list(inventory) and is_binary(name) do
    Enum.find(inventory, fn item -> item.name == name end)
  end

  def update_stock(inventory, name, new_stock)
      when is_list(inventory) and is_binary(name) and is_integer(new_stock) and new_stock >= 0 do
    Enum.map(inventory, fn item ->
      if item.name == name do
        %{item | stock: new_stock}
      else
        item
      end
    end)
  end

  def update_stock(_inventory, _name, _new_stock) do
    {:error, "Stock inválido"}
  end

  def low_stock(inventory, limit) when is_list(inventory) and is_integer(limit) and limit >= 0 do
    Enum.filter(inventory, fn item -> item.stock <= limit end)
  end

  def remove_item(inventory, name) when is_list(inventory) and is_binary(name) do
    Enum.reject(inventory, fn item -> item.name == name end)
  end
end
