defmodule Pooly.Server do
  use GenServer
  import Supervisor.Spec

  @timeout 5000

  #######
  # API #
  #######

  def start_link(pools_config) do
    GenServer.start_link(__MODULE__, pools_config, name: __MODULE__)
  end

  def checkout(pool_name) do
    GenServer.call(:"#{pool_name}Server", :checkout, @timeout)
  end

  def checkout(pool_name, timeout) do
    GenServer.call(:"#{pool_name}Server", :checkout, timeout)
  end

  def checkin(pool_name, worker_pid) do
    GenServer.cast(:"#{pool_name}Server", {:checkin, worker_pid})
  end

  def transaction(pool_name, fun, timeout \\ @timeout) do
    worker = checkout(pool_name, timeout)
    try do
      fun.(worker)
    after
      checkin(pool_name, worker)
    end
  end

  def status(pool_name) do
    GenServer.call(:"#{pool_name}Server", :status)
  end

  #############
  # Callbacks #
  #############

  def init(pools_config) do
    pools_config |> Enum.each(fn(pool_config) ->
      send(self, {:start_pool, pool_config})
    end)

    {:ok, pools_config}
  end

  def handle_info({:start_pool, pool_config}, state) do
    {:ok, _pool_sup} = Supervisor.start_child(Pooly.PoolsSupervisor, supervisor_spec(pool_config))

    {:noreply, state}
  end

  #####################
  # Private Functions #
  #####################

  defp supervisor_spec(pool_config) do
    # TODO: WHAT SHOULD BE GOOD VALUES
    # NOTE: This needs to be random because by de
    opts = [id: :"#{pool_config[:name]}Supervisor"]
    supervisor(Pooly.PoolSupervisor, [pool_config], opts)
  end

end
