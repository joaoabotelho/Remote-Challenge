defmodule  AccountManagmentTest do
  use ExUnit.Case, async: false
  alias AccountManagment

 setup do
  :ok = Ecto.Adapters.SQL.Sandbox.checkout(MyApp.Repo)
  Ecto.Adapters.SQL.Sandbox.mode(MyApp.Repo, {:shared, self()})

  MyApp.Account.create_user(%{points: 30})
  MyApp.Account.create_user(%{points: 70})

  {:ok, server_pid} = GenServer.start_link(AccountManagment, %{max_number: 0, timestamp: nil})
  {:ok, server: server_pid}
  end

  test "more success test", %{server: pid} do
    {users, timestamp} = AccountManagment.more(pid)
    assert timestamp == nil
    assert is_list(users)
    assert length(users) == 2
  end

  # test if AccountManagment.more doesnt return users with points less than max_value

  # test if handle_info updates every user and updates max_number
end
