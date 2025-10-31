defmodule FindMeHouseDashboard.ServiceHealthChecker do
  use GenServer
  alias FindMeHouseDashboard.Monitoring

  def start_link(service) do
    GenServer.start_link(__MODULE__, service, name: via_tuple(service.id))
  end

  defp via_tuple(service_id) do
    {:via, Registry, {FindMeHouseDashboard.RegistryService, service_id}}
  end

  def init(service) do
    interval = Enum.random([3000, 4000, 5000, 6000])
    Process.send_after(self(), :check_service_status, interval)
    {:ok, %{service: service, interval: interval}}
  end

  def handle_info(:check_service_status, %{service: service, interval: interval} = state) do
    new_status = simulate_status_check(service)

    if new_status != service.status do
      Monitoring.update_service_status_and_broadcast(service, %{
        status: new_status,
        last_checked_at: DateTime.utc_now()
      })
    else
      Monitoring.update_service_status(service, %{
        last_checked_at: DateTime.utc_now()
      })
    end

    Process.send_after(self(), :check_service_status, interval)

    updated_service = Monitoring.get_service_status!(service.id)
    {:noreply, %{state | service: updated_service}}
  end

  defp simulate_status_check(service) do
    random = :rand.uniform(100)

    case service.status do
      "healthy" ->
        cond do
          random <= 20 -> "degraded"
          true -> "healthy"
        end

      "degraded" ->
        cond do
          random <= 30 -> "down"
          random <= 60 -> "degraded"
          true -> "healthy"
        end

      "down" ->
        cond do
          random <= 40 -> "degraded"
          true -> "down"
        end
    end
  end
end
