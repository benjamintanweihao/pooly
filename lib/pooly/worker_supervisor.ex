defmodule Pool.WorkerSupervisor do
  use Supervisor

  def start_link({_,_,_} = mfa) do
    Supervisor.start_link(__MODULE__, mfa)
  end

  def init({m,f,a}) do
    worker_opts = [restart:  temporary,
                   shutdown: 5000,
                   function: f]

    children = [worker(m, a, worker_opts)]
    opts     = [strategy:    :simple_one_for_one,
                max_restart: 5,
                max_time:    3600]

    supervise(children, opts)
  end
end
