defmodule Pooly do
  use Application

  def start(_type, _args) do
    # This is an example on how to start the Pooly
    pool_config = [mfa: {SampleWorker, :start_link, []},
                   size: 50]

    Pooly.Supervisor.start_link(pool_config)
  end

end
