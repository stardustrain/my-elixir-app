defmodule MyAppWeb.UserControllerTest do
  @moduledoc false

  use MyAppWeb.ConnCase

  alias MyApp.Guardian
  import MyApp.UserFixture

  @user_attrs %{email: "test@test.com", password: "test1234"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "user sign up" do
    test "should render jwt token with valid attrs", %{conn: conn} do
      conn = post(
        conn,
        Routes.user_path(conn, :signup),
        @user_attrs
      )

      assert %{"token" => token} = json_response(conn, 201)
      assert is_binary(token)
    end

    test "should render 400 with invalid attributes", %{conn: conn} do
      create_user(%{})

      conn = post(conn, Routes.user_path(conn, :signup), %{email: "", password: ""})
      assert json_response(conn, 400)["errors"] !== %{}

      conn = post(conn, Routes.user_path(conn, :signup), %{email: "other-mail@test.com", password: "짧은암호"})
      assert json_response(conn, 400)["errors"] !== %{}

      conn = post(conn, Routes.user_path(conn, :signup), @user_attrs)
      assert json_response(conn, 400)["errors"] !== %{}
    end
  end

  describe "user sign in" do
    setup [:create_user]

    test "should render jwt token with valid user", %{conn: conn, user: user} do
      conn = post(
        conn,
        Routes.user_path(conn, :signin),
        @user_attrs
      )

      %{"token" => token} = json_response(conn, 200)
      {:ok, claims} = Guardian.decode_and_verify(token)

      assert claims["sub"] === user.id |> to_string
    end

    test "should render 401 with invalid attributes", %{conn: conn} do
      invalid_attrs = %{email: "invalid@test.com", password: "test1234"}

      conn = post(
        conn,
        Routes.user_path(conn, :signin),
        invalid_attrs
      )

      assert json_response(conn, 401)["errors"]["detail"] === "Unauthorized"
    end
  end

  defp create_user(_) do
    user = create_user_fixture(@user_attrs)
    %{user: user}
  end
end
