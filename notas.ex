defmodule Notas do
  def resumen_notas(lista) do
    aprobados =
      lista
      |> Enum.filter(fn alumno -> alumno.nota >= 6 end)
      |> Enum.map(fn alumno -> alumno.nombre end)

    reprobados =
      lista
      |> Enum.filter(fn alumno -> alumno.nota < 6 end)
      |> Enum.map(fn alumno -> alumno.nombre end)

    promedio =
      lista
      |> Enum.map(fn alumno -> alumno.nota end)
      |> promedio()

    %{
      aprobados: aprobados,
      reprobados: reprobados,
      promedio: promedio
    }
  end

  defp promedio(notas) do
    Enum.sum(notas) / length(notas)
  end
end
