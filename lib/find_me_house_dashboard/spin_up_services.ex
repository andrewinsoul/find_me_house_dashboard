defmodule FindMeHouseDashboard.SpinUpServices do
  use GenServer
  alias FindMeHouseDashboard.Monitoring
  alias FindMeHouseDashboard.FindMeHouseSupervisor

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    # Start checkers for all existing services
    :timer.send_after(1000, :start_services)
    {:ok, %{}}
  end

  def handle_info(:start_services, state) do
    services = Monitoring.list_service_statuses()

    Enum.each(services, fn service ->
      FindMeHouseSupervisor.start_service_checker(service)
    end)

    {:noreply, state}
  end

  # Could also handle starting checkers for newly created services
end
