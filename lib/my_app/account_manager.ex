defmodule AccountManagment do
  use GenServer

  # Client

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_) do
    schedule_work()
    {:ok, %{max_number: Enum.random(0..100), timestamp: nil}}
  end

  def handle_info(:work, state) do
    # Update max_number
    update_state = %{max_number: Enum.random(0..100), timestamp: state.timestamp}

    # Update every user.points with a random number from 0 to 100
    Ecto.Adapters.SQL.query!(MyApp.Repo, "update users set points = (select floor(random() * 100) where users.id=users.id)")

    schedule_work()  # Reschedule once more
    {:noreply, update_state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 60 * 1000) # In 1 min
  end
end
