defmodule AccountManagment do
  use GenServer
  import Ecto.Query
  alias MyApp.Repo

  # Client

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end


  def more(server \\ __MODULE__) do
    GenServer.call(server, :more)
  end

  # Server

  def init(state) when is_map(state) do
    schedule_work()
    {:ok, state}
  end

  def init(_) do
    schedule_work()
    {:ok, %{max_number: Enum.random(0..100), timestamp: nil}}
  end

  def handle_call(:more, _from, state) do
    update_state = %{max_number: state.max_number, timestamp: DateTime.utc_now()}
    max_number = state.max_number
    users = Repo.all(from u in MyApp.Account.User, where: u.points > ^max_number, select: u, limit: 2)

    value = {users, state.timestamp}

    {:reply, value, update_state}
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
