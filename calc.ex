defmodule Calculadora do
  defp factorial(0), do: 1
  defp factorial(n), do: n * factorial(n - 1)

  def calculate(:+, a, b), do: a + b
  def calculate(:-, a, b), do: a - b
  def calculate(:*, a, b), do: a * b
  def calculate(:/, _a, 0), do: {:error, "No se puede dividir entre cero"}
  def calculate(:/, a, b), do: a / b
  def calculate(_operator, _a, _b), do: {:error, "Operación inválida"}

  def calculate(:factorial, n) when is_integer(n) and n >= 0, do: factorial(n)
  def calculate(:factorial, _n), do: {:error, "El factorial solo acepta enteros no negativos"}

  def calculate(:promedio, lista) when is_list(lista) and length(lista) > 0 do
    Enum.sum(lista) / length(lista)
  end

  def calculate(:promedio, []), do: {:error, "lista no puede ser vacía"}
  def calculate(:promedio, _lista), do: {:error, "Debes proporcionar una lista"}

  # MCD
  def calculate(:mcd, a, b) when is_integer(a) and is_integer(b) do
    mcd(abs(a), abs(b))
  end

  def calculate(:mcd, _a, _b), do: {:error, "deben de ser enteros"}

  defp mcd(a, 0), do: a
  defp mcd(a, b), do: mcd(b, rem(a, b))

  # Es Primo
  def calculate(:es_primo, n) when is_integer(n) and n > 1 do
    es_primo(n, 2)
  end

  def calculate(:es_primo, _n), do: false

  defp es_primo(n, i) when i * i > n, do: true

  defp es_primo(n, i) do
    if rem(n, i) == 0 do
      false
    else
      es_primo(n, i + 1)
    end
  end

  # Mediana
  def calculate(:mediana, lista) when is_list(lista) and length(lista) > 0 do
    lista_ordenada = Enum.sort(lista)
    n = length(lista_ordenada)

    if rem(n, 2) == 1 do
      Enum.at(lista_ordenada, div(n, 2))
    else
      mid1 = Enum.at(lista_ordenada, div(n, 2) - 1)
      mid2 = Enum.at(lista_ordenada, div(n, 2))
      (mid1 + mid2) / 2
    end
  end

  def calculate(:mediana, []), do: {:error, "lista no puede ser vacía"}
  def calculate(:mediana, _lista), do: {:error, "se debe dar una lista"}
end
