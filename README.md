# Remote Challenge

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Seed database with `mix run priv/repo/seeds.exs`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Arquitecture 
![Image of Flow Chart](https://github.com/joaoabotelho/Remote-Challenge/blob/master/flow_chart.png)

### Use of GenServer

It's only used one GenServer and with this every request is handled in sequential order. This can be a bootleneck and should be avoided by using a pool of GenServers, reducing the cluster of requests.

### Cron Job

A cron job it's implemented to assign the state of `max_number`, in the GenServer, to a random number each minute while it's running and also to make a update in the database for each `user.points` attribute by assigning a different random number between 0-100.

This is implemented by using a private function called `schedule_work` in `AccountManagment` module to program the Process to trigger `handle_info(:work)` each minute. In `handle_info(:work)` we update the state, make the query and finally call the method `schedule_work` one more time to trigger this method in the next minute. 

### Update Users

Users points are all updated with diferent random values with this query:
`update users set points = (select floor(random() * 100) where users.id=users.id)`

### Fetch Users

Users are fetched with the condition of their points being bigger than the max_number value in the state of the GenServer and it's only asked a max of 2 users.
`Repo.all(from u in MyApp.Account.User, where: u.points > ^max_number, select: u, limit: 2)`

## Features do add

In the future, it should be added the use of multiple GenServers instead of one.
