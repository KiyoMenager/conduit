defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase

  import Conduit.Factory

  alias Conduit.Accounts

  def fixture(:user, attrs \\ []) do
    Accounts.create_user(build(:user, attrs))
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    @tag :web
    test "should create and renders user when data is valid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: build(:user))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, user_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "bio" => "some bio",
               "email" => "some email",
               "hashed_password" => "some hashed_password",
               "image" => "some image",
               "username" => "some username"
             }
    end

    @tag :web
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: build(:user, username: ""))

      assert json_response(conn, 422)["errors"] != %{
               "username" => [
                 "can't be empty"
               ]
             }
    end

    @tag :web
    test "should not create user when username has already been created", %{conn: conn} do
      {:ok, user} = fixture(:user)

      conn = post(conn, user_path(conn, :create), user: build(:user, username: user.username))

      assert json_response(conn, 422)["errors"] != %{
               "username" => [
                 "has already been created"
               ]
             }
    end
  end
end
