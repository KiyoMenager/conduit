defmodule Conduit.AccountsTest do
  use Conduit.DataCase

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      attrs = build(:user_aggregate)
      assert {:ok, %User{} = user} = Accounts.register_user(attrs)

      assert user.email == attrs.email
      assert user.hashed_password == attrs.hashed_password
      assert user.username == attrs.username
      assert user.image == nil
      assert user.bio == nil
    end

    @tag :integration
    test "should fail with invalid data and return error" do
      attrs = build(:user_aggregate, username: "")
      assert {:error, reason} = Accounts.register_user(attrs)

      assert {:validation_failure, errors} = reason
      assert errors == %{username: ["can't be empty"]}
    end

    @tag :integration
    test "should fail when username already taken and return error" do
      attrs = build(:user_aggregate)

      assert {:ok, %User{}} = Accounts.register_user(attrs)
      assert {:error, reason} = Accounts.register_user(attrs)

      assert {:validation_failure, errors} = reason
      assert errors == %{username: ["has already been taken"]}
    end
  end
end
