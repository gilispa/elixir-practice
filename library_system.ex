defmodule LibrarySystem do
  defmodule Book do
    defstruct [:id, :title, :author, available: true, borrower: nil]
  end

  defmodule Member do
    defstruct [:name, borrowed_books: []]
  end

  def new(), do: %{books: [], members: []}

  def add_book(library, id, title, author)
      when is_map(library) and is_integer(id) and is_binary(title) and is_binary(author) do
    case find_book(library, id) do
      nil ->
        book = %Book{id: id, title: title, author: author}
        %{library | books: library.books ++ [book]}

      _book ->
        {:error, "Ya existe un libro con ese id"}
    end
  end

  def add_book(_library, _id, _title, _author), do: {:error, "Datos inválidos"}

  def register_member(library, name) when is_map(library) and is_binary(name) do
    case find_member(library, name) do
      nil ->
        member = %Member{name: name}
        %{library | members: library.members ++ [member]}

      _member ->
        {:error, "Ese miembro ya está registrado"}
    end
  end

  def register_member(_library, _name), do: {:error, "Nombre inválido"}

  def borrow_book(library, member_name, book_id)
      when is_map(library) and is_binary(member_name) and is_integer(book_id) do
    book = find_book(library, book_id)
    member = find_member(library, member_name)

    cond do
      book == nil ->
        {:error, "Libro no encontrado"}

      member == nil ->
        {:error, "Miembro no encontrado"}

      not book.available ->
        {:error, "El libro ya está prestado"}

      true ->
        updated_books =
          Enum.map(library.books, fn current_book ->
            if current_book.id == book_id do
              %{current_book | available: false, borrower: member_name}
            else
              current_book
            end
          end)

        updated_members =
          Enum.map(library.members, fn current_member ->
            if current_member.name == member_name do
              %{current_member | borrowed_books: current_member.borrowed_books ++ [book_id]}
            else
              current_member
            end
          end)

        %{library | books: updated_books, members: updated_members}
    end
  end

  def borrow_book(_library, _member_name, _book_id), do: {:error, "Datos inválidos"}

  def return_book(library, member_name, book_id)
      when is_map(library) and is_binary(member_name) and is_integer(book_id) do
    book = find_book(library, book_id)
    member = find_member(library, member_name)

    cond do
      book == nil ->
        {:error, "Libro no encontrado"}

      member == nil ->
        {:error, "Miembro no encontrado"}

      book.available ->
        {:error, "El libro ya estaba disponible"}

      book.borrower != member_name ->
        {:error, "Ese libro no fue prestado a ese miembro"}

      true ->
        updated_books =
          Enum.map(library.books, fn current_book ->
            if current_book.id == book_id do
              %{current_book | available: true, borrower: nil}
            else
              current_book
            end
          end)

        updated_members =
          Enum.map(library.members, fn current_member ->
            if current_member.name == member_name do
              %{current_member | borrowed_books: List.delete(current_member.borrowed_books, book_id)}
            else
              current_member
            end
          end)

        %{library | books: updated_books, members: updated_members}
    end
  end

  def return_book(_library, _member_name, _book_id), do: {:error, "Datos inválidos"}

  def list_available_books(library) when is_map(library) do
    Enum.filter(library.books, fn book -> book.available end)
  end

  def list_borrowed_books(library) when is_map(library) do
    Enum.filter(library.books, fn book -> not book.available end)
  end

  def books_by_member(library, member_name) when is_map(library) and is_binary(member_name) do
    case find_member(library, member_name) do
      nil ->
        {:error, "Miembro no encontrado"}

      member ->
        Enum.filter(library.books, fn book -> book.id in member.borrowed_books end)
    end
  end

  def summary(library) when is_map(library) do
    %{
      total_books: length(library.books),
      available_books: length(list_available_books(library)),
      borrowed_books: length(list_borrowed_books(library)),
      total_members: length(library.members)
    }
  end

  def find_book(library, id) when is_map(library) and is_integer(id) do
    Enum.find(library.books, fn book -> book.id == id end)
  end

  def find_member(library, name) when is_map(library) and is_binary(name) do
    Enum.find(library.members, fn member -> member.name == name end)
  end
end
