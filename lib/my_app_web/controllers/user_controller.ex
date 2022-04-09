defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  alias MyApp.Account
  alias MyApp.Guardian

  action_fallback MyAppWeb.FallbackController

  def signup(conn, %{"email" => email, "password" => password}) do
    with {:ok, token, _claims} <- Account.sign_up(%{email: email, password: password}) do
      conn
      |> put_status(:created)
      |> render("jwt.json", token: token)
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, token, _claims} <- Account.sign_in(email, password) do
      conn
      |> render("jwt.json", token: token)
    end
  end

  def me(conn, _) do
    token = conn
    |> get_req_header("authorization")
    |> List.first("")
    |> String.split
    |> List.last
    result = Guardian.resource_from_token(token)

    case result do
      {:ok, resource, _claims} -> conn |> render("me.json", user: resource)
      {:error, _reason} -> {:error, :unauthorized}
    end
  end
end
