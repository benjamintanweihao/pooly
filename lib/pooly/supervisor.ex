defmodule Pooly.Supervisor do
  use Supervisor

  def start_link(pool_config) do
    Supervisor.start_link(__MODULE__, pool_config)
  end

  def init(pool_config) do
    children = [
      worker(Pooly.Server, [self, pool_config])
    ]

    opts = [strategy: :one_for_all,
            max_restart: 1,
            max_time: 3600]

    supervise(children, opts)
  end

  def handle_info({:start_worker_supervisor, sup, mfa, server}, state) do
    {:ok, _worker} = Supervisor.start_child(sup, supervisor_spec(mfa))
    {:noreply, state}
  end

  #####################
  # Private Functions #
  #####################

  defp supervisor_spec(mfa) do
    opts = [shutdown: 10000, restart: :temporary]
    supervisor(Pooly.WorkerSupervisor, [mfa], opts)
  end

end
