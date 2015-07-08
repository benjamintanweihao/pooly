defmodule Pooly do
  use Application

  def start(_type, _args) do
    # This is an example on how to start the Pooly
    pools_config =
      [
        [name: "Pool1",
         mfa: {SampleWorker, :start_link, []},
         size: 2,
         max_overflow: 10
        ],
        [name: "Pool2",
         mfa: {SampleWorker, :start_link, []},
         size: 2,
         max_overflow: 0
        ],
      ]

    Pooly.Supervisor.start_link(pools_config)
  end

  def start_pools(pools_config) do
    Pooly.Supervisor.start_link(pools_config)
  end

  def checkout(pool_name) do
    Pooly.Server.checkout(pool_name)
  end

  def checkin(pool_name, worker_pid) do
    Pooly.Server.checkin(pool_name, worker_pid)
  end

  def transaction(pool_name, fun, timeout) do
    Pooly.Server.transaction(pool_name, fun, timeout)
  end

  def status(pool_name) do
    Pooly.Server.status(pool_name)
  end

end

