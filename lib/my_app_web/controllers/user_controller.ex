defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  def max_points_users(conn, _params) do
    {users, timestamp} = AccountManagment.more
    render(conn, "max_points_users.json", users: users, timestamp: timestamp)
  end
end
