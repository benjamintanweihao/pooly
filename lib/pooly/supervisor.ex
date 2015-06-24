defmodule Pooly.Supervisor do
  use Supervisor

  def start_link({_,_,_} = mfa) do
    Supervisor.start_link(__MODULE__, mfa)
  end

  def init(args) do
    children = [
      worker(Pooly.Server, [self, args])
    ]

    opts = [strategy: :one_for_all,
            max_restart: 1,
            max_time: 3600]

    supervise(children, opts)
  end
end
