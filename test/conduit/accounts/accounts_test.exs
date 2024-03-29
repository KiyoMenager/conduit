defmodule Conduit.AccountsTest do
  use Conduit.DataCase

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User
  alias Conduit.Auth

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      attrs = build(:user_aggregate)
      assert {:ok, %User{} = user} = Accounts.register_user(attrs)

      assert user.email == attrs.email
      assert user.username == attrs.username
      assert user.hashed_password
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

      assert {:error, reason} =
               Accounts.register_user(Map.put(attrs, :email, "unique@example.com"))

      assert {:validation_failure, errors} = reason
      assert errors == %{username: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical username at same time and return error" do
      1..2
      |> Enum.map(fn _ ->
        Task.async(fn ->
          Accounts.register_user(build(:user_aggregate))
        end)
      end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when username format is invalid and return error" do
      attrs = build(:user_aggregate, username: "addr@example.com")
      assert {:error, reason} = Accounts.register_user(attrs)

      assert {:validation_failure, errors} = reason
      assert errors == %{username: ["is invalid"]}
    end

    @tag :integration
    test "should convert username to lowercase" do
      attrs = build(:user_aggregate, username: "UPPERCASE")
      assert {:ok, %User{} = user} = Accounts.register_user(attrs)

      assert user.username == "uppercase"
    end

    @tag :integration
    test "should fail when email already taken and return error" do
      attrs = build(:user_aggregate, email: "taken@example.com")

      assert {:ok, %User{}} = Accounts.register_user(attrs)
      assert {:error, reason} = Accounts.register_user(Map.put(attrs, :username, "unique0"))

      assert {:validation_failure, errors} = reason
      assert errors == %{email: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical email at same time and return error" do
      1..2
      |> Enum.map(fn x ->
        Task.async(fn ->
          Accounts.register_user(build(:user_aggregate, username: "unique#{x}"))
        end)
      end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when email format is invalid and return error" do
      attrs = build(:user_aggregate, email: "invalid")
      assert {:error, reason} = Accounts.register_user(attrs)

      assert {:validation_failure, errors} = reason
      assert errors == %{email: ["is invalid"]}
    end

    @tag :integration
    test "should convert email to lowercase" do
      attrs = build(:user_aggregate, email: "UPPERCASE@example.com")
      assert {:ok, %User{} = user} = Accounts.register_user(attrs)

      assert user.email == "uppercase@example.com"
    end

    @tag :integration
    test "should should hash password" do
      attrs = build(:user_aggregate)
      assert {:ok, %User{} = user} = Accounts.register_user(attrs)

      assert Auth.validate_password(attrs.password, user.hashed_password)
    end
  end
end
