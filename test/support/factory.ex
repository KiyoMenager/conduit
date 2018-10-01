defmodule Conduit.Factory do
  use ExMachina

  def user_aggregate_factory do
    %{
      email: "seb@example.com",
      username: "sebastian",
      password: "password",
      bio: "I like music",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end

  alias Conduit.Accounts.User.Commands.RegisterUser

  def register_user_factory do
    build(:user_aggregate)
    |> Map.put(:user_uuid, UUID.uuid4())
    |> RegisterUser.new()
  end
end
