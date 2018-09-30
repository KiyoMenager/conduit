defmodule Conduit.Factory do
  use ExMachina

  def user_factory do
    %{
      email: "seb@example.com",
      username: "sebastian",
      hashed_password: "password",
      bio: "I like music",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end
end
