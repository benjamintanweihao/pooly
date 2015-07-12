defmodule Pooly do
  use Application

  @timeout 5000

  def start(_type, _args) do
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

    start_pool(pools_config)
  end

  def start_pools(pools_config) do
    Pooly.Supervisor.start_link(pools_config)
  end

  def checkout(pool_name, block \\ true, timeout \\ @timeout) do
    Pooly.Server.checkout(pool_name, block, timeout)
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

