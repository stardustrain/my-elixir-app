defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authentication do
    plug MyApp.Authentication
  end

  pipeline :ensure_admin do
    plug MyApp.Authentication
    plug MyApp.Authorization
  end

  scope "/api", MyAppWeb do
    pipe_through :api

    post "/signup", UserController, :signup
    post "/signin", UserController, :signin
  end

  scope "/api", MyAppWeb do
    pipe_through [:api, :authentication]

    get "/me", UserController, :me
  end

  scope "/admin", MyAppWeb do
    pipe_through [:api, :ensure_admin]

    get "/admin-only", UserController, :admin_only
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
