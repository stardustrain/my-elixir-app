defmodule MyAppWeb.FallbackController do
  use Phoenix.Controller

  alias MyAppWeb.ErrorHelpers

  def call(conn, {:error, :unauthorized}) do
    call(conn, {:error, :unauthorized, "Unauthorized"})
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    call(conn, {:error, :bad_request, changeset})
  end

  def call(conn, {:error, status_code, message}) when is_binary(message) do
    conn
    |> put_status(status_code)
    |> put_view(MyAppWeb.ErrorView)
    |> render("error.json", %{detail: message})
  end

  def call(conn, {:error, status_code, %Ecto.Changeset{} = changeset}) do
    detail = changeset
    |> Ecto.Changeset.traverse_errors(&ErrorHelpers.translate_error(&1))

    conn
    |> put_status(status_code)
    |> put_view(MyAppWeb.ErrorView)
    |> render("error.json", %{detail: detail})
  end
end
