defmodule Pooly.Server do
  use GenServer
  import Supervisor.Spec

  defmodule State do
    defstruct sup: nil
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init([sup, mfa]) do
    # Don't do this! (But see the deadlock in action!)
    # Supervisor.start_child(sup, mfa)
    send(self, {:start_worker_supervisor}, sup, mfa)
    # Note, the `sup` is for the worker pool supervisor,
    # not the top level supervisor
    {:ok, %State{}}
  end

  def handle_info({:start_worker_supervisor, sup, mfa}, state) do
    opts = [shutdown: 10000, restart: :temporary]
    child_spec = supervisor(Pooly.WorkerSupervisor, mfa, opts)
    {:ok, worker_sup} = Supervisor.start_child(sup, child_spec)

    {:noreply, %{state | sup: worker_sup}}
  end
end
