defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  alias MyApp.Account

  def signup(conn, %{"email" => email, "password" => password}) do
    with {:ok, token, _claims} <- Account.sign_up(%{email: email, password: password}) do
      conn
      |> put_status(:created)
      |> render("jwt.json", token: token)
    end
  end
end
