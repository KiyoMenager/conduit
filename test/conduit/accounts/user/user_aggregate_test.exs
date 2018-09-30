defmodule Conduit.Accounts.UserAggregateTest do
  use Conduit.AggregateCase, aggregate: Conduit.Accounts.UserAggregate

  alias Conduit.Accounts.User.Events.UserRegistered

  describe "register user" do
    @tag :unit
    test "should succeed when valid" do
      user_uuid = UUID.uuid4()
      command = build(:register_user, user_uuid: user_uuid)

      assert_events(command, [
        %UserRegistered{
          user_uuid: command.user_uuid,
          email: command.email,
          username: command.username,
          hashed_password: command.hashed_password
        }
      ])
    end
  end
end
