defmodule ClienteService do
  def fetch(cliente_id) do
    Process.sleep(800)
    %{cliente_id: cliente_id, nombre: "Cliente #{cliente_id}"}
  end
end

defmodule EnvioService do
  def cotizar(producto_id) do
    Process.sleep(1200)

    %{
      producto_id: producto_id,
      costo_envio: producto_id |> rem(5) |> Kernel.+(1) |> Kernel.*(100)
    }
  end
end

defmodule InventarioService do
  def stock(producto_id) do
    Process.sleep(1000)
    %{producto_id: producto_id, disponible: rem(producto_id, 2) == 0}
  end
end

defmodule PedidoEnricher do
  def enriquecer_secuencial(pedidos) do
    Enum.map(pedidos, fn pedido ->
      cliente = ClienteService.fetch(pedido.cliente_id)
      envio = EnvioService.cotizar(pedido.producto_id)
      inventario = InventarioService.stock(pedido.producto_id)

      %{
        id: pedido.id,
        cliente: cliente,
        envio: envio,
        inventario: inventario
      }
    end)
  end

  def enriquecer_concurrente(pedidos) do
    Enum.map(pedidos, fn pedido ->
      cliente_task =
        Task.async(fn ->
          ClienteService.fetch(pedido.cliente_id)
        end)

      envio_task =
        Task.async(fn ->
          EnvioService.cotizar(pedido.producto_id)
        end)

      inventario_task =
        Task.async(fn ->
          InventarioService.stock(pedido.producto_id)
        end)

      %{
        id: pedido.id,
        cliente: Task.await(cliente_task),
        envio: Task.await(envio_task),
        inventario: Task.await(inventario_task)
      }
    end)
  end

  def enriquecer_full_concurrente(pedidos) do
    pedidos
    |> Task.async_stream(
      fn pedido ->
        cliente = ClienteService.fetch(pedido.cliente_id)
        envio = EnvioService.cotizar(pedido.producto_id)
        inventario = InventarioService.stock(pedido.producto_id)

        %{
          id: pedido.id,
          cliente: cliente,
          envio: envio,
          inventario: inventario
        }
      end,
      max_concurrency: 3
    )
    |> Enum.map(fn {:ok, resultado} -> resultado end)
  end
end

pedidos = [
  %{id: 1, cliente_id: 101, producto_id: 501},
  %{id: 2, cliente_id: 102, producto_id: 502},
  %{id: 3, cliente_id: 103, producto_id: 503}
]

IO.puts("Secuencial:")
IO.inspect(PedidoEnricher.enriquecer_secuencial(pedidos))

IO.puts("\nConcurrente por pedido:")
IO.inspect(PedidoEnricher.enriquecer_concurrente(pedidos))

IO.puts("\nTotalmente concurrente:")
IO.inspect(PedidoEnricher.enriquecer_full_concurrente(pedidos))
