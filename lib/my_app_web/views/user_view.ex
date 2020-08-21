defmodule MyAppWeb.UserView do
  use MyAppWeb, :view
  alias MyAppWeb.UserView

  def render("user.json", %{user: user}) do
    %{id: user.id, points: user.points}
  end
end
