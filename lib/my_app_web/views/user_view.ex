defmodule MyAppWeb.UserView do
  use MyAppWeb, :view
  alias MyAppWeb.UserView

  def render("max_points_users.json", %{users: users, timestamp: timestamp}) do
    %{users: render_many(users, UserView, "user.json"), timestamp: timestamp}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, points: user.points}
  end
end
