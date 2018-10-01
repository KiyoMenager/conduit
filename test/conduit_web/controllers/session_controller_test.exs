defmodule ConduitWeb.SessionControllerTest do
  use ConduitWeb.ConnCase

  alias Conduit.Accounts

  def fixture(:user, attrs \\ []) do
    Accounts.register_user(build(:user_aggregate, attrs))
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "authenticate user" do
    @tag :web
    test "creates a session and renders session when data is valid", %{conn: conn} do
      user_attrs = build(:user_aggregate)
      register_user(user_attrs)

      params = %{
        email: user_attrs.email,
        password: user_attrs.password
      }

      conn = post(conn, session_path(conn, :create), user: params)
      json = json_response(conn, 201)["user"]
      token = json["token"]

      assert json == %{
               "email" => user_attrs.email,
               "username" => user_attrs.username,
               "token" => token,
               "bio" => nil,
               "image" => nil
             }

      refute token == ""
    end

    @tag :web
    test "does not creates a session and renders errors when password does not match", %{
      conn: conn
    } do
      user_attrs = build(:user_aggregate)
      register_user(user_attrs)

      params = %{
        email: user_attrs.email,
        password: "missmatching"
      }

      conn = post(conn, session_path(conn, :create), user: params)

      assert json_response(conn, 422)["errors"] == %{
               "email or password" => ["is invalid"]
             }
    end

    @tag :web
    test "does not creates a session and renders errors when user does not exists", %{
      conn: conn
    } do
      params = %{
        email: "unknown@example.com",
        password: "password"
      }

      conn = post(conn, session_path(conn, :create), user: params)

      assert json_response(conn, 422)["errors"] == %{
               "email or password" => ["is invalid"]
             }
    end
  end

  defp register_user(attrs) do
    fixture(:user, attrs)
  end
end
