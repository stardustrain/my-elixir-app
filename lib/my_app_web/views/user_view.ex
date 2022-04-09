defmodule MyAppWeb.UserView do
  use MyAppWeb, :view

  def render("jwt.json", %{token: token}) do
    %{token: token}
  end
end
