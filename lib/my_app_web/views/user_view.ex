defmodule MyAppWeb.UserView do
  use MyAppWeb, :view

  def render("jwt.json", %{token: token}) do
    %{token: token}
  end

  def render("me.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
