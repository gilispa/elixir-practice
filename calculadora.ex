defmodule Calculator do
  def add(a, b), do: a + b
  def substract(a, b), do: a - b
  def multiply(a, b), do: a * b

  def divide(_a, 0), do: {:error, "no se puede dividir"}
  def divide(a, b), do: a / b

  def average([]), do: {:error, "lista vacía"}
  def average(list), do: Enum.sum(list) / length(list)

  def factorial(0), do: 1
  def factorial(n) when n > 0, do: n * factorial(n - 1)
  def factorial(_), do: {:error, "numero inválido"}

  def modulo(_a, 0), do: {:error, "no se puede dividir entre 0"}
  def modulo(a, b), do: rem(a, b)

  def calculate(:+, a, b), do: a + b
  def calculate(:-, a, b), do: a - b
  def calculate(:*, a, b), do: a * b
  def calculate(:/, a, b), do: divide(a, b)
  def calculate(:%, a, b), do: modulo(a, b)
  def calculate(_operador, _a, _b), do: {:error, "operacion invalida"}
end
