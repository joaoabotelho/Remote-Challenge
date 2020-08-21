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

In this current implementation, only one GenServer is used, which means that every single request will be handle in sequential order. This can be a bootleneck in the future and can be mitigated by instead spawning multiple GenServers to handle requests in parallel.

### Cron Job

A cron job is implemented in the GenServer for each minute with te objective to assign the state of `max_number` to a random integer from 0-100 and also to update the users table for each `user` and assign different random numbers between 0-100 to their `points` attribute.

It uses a private function called `schedule_work` in `AccountManagment` module to set the Process to trigger the method `handle_info(:work)` each minute it passes. 
In `handle_info(:work)` we update the state, make the query and finally call the method `schedule_work` to trigger this method again in the next minute. 

### Update Users

All Users points are updated with diferent random values with the following query:
`update users set points = (select floor(random() * 100) where users.id=users.id)`

### Fetch Users

2 users must be fetched at most and both of them must have a `points` value higher than the `max_number` set as the state of the GenServer. The following is the query used:
`Repo.all(from u in MyApp.Account.User, where: u.points > ^max_number, select: u, limit: 2)`

