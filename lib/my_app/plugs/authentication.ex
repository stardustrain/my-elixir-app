defmodule MyApp.Authentication do
  use Guardian.Plug.Pipeline,
    otp_app: :my_app,
    module: MyApp.Guardian,
    error_handler: MyApp.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource
  plug Guardian.Plug.EnsureAuthenticated
end
