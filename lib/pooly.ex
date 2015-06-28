defmodule Pooly do
  use Application

  def start(_type, _args) do
    # This is an example on how to start the Pooly
    pool_config = [mfa: {SampleWorker, :start_link, []},
                   size: 5]

    Pooly.Supervisor.start_link(pool_config)
  end

  def start_pool(pool_config) do
    Pooly.Supervisor.start_link(pool_config)
  end

  def checkout do
    Pooly.Server.checkout
  end

  def checkin(worker_pid) do
    Pooly.Server.checkin(worker_pid)
  end

end

