defmodule MyApp.Authorization do
  import Plug.Conn
  alias MyAppWeb.ErrorView
  alias MyApp.Guardian

  def init(_) do
  end

  defp send_forbidden_error(conn) do
    body = ErrorView.template_not_found("403.json", %{}) |> Jason.encode!

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:forbidden, body)
  end

  def call(conn, _) do
    with %MyApp.Account.User{} = user <- Guardian.Plug.current_resource(conn),
      {:ok, true} <- Map.fetch(user, :is_admin) do
        conn
    else
      _ -> conn |> send_forbidden_error |> halt
    end
  end
end
