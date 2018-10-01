defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase

  import Conduit.Factory

  alias Conduit.Accounts

  def fixture(:user, attrs \\ []) do
    Accounts.register_user(build(:user_aggregate, attrs))
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    @tag :web
    test "should create and renders user when data is valid", %{conn: conn} do
      attrs = build(:user_aggregate)

      conn = post(conn, user_path(conn, :create), user: attrs)
      assert json = json_response(conn, 201)["user"]

      assert json == %{
               "email" => attrs.email,
               "username" => attrs.username,
               "image" => nil,
               "bio" => nil
             }
    end

    @tag :web
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: build(:user_aggregate, username: ""))

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "can't be empty"
               ]
             }
    end

    @tag :web
    test "renders errors when username has already been created", %{conn: conn} do
      {:ok, user} = fixture(:user)

      params = build(:user_aggregate, %{username: user.username, email: "unique@example.com"})
      conn = post(conn, user_path(conn, :create), user: params)

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "has already been taken"
               ]
             }
    end
  end
end
