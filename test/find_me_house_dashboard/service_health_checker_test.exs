defmodule FindMeHouseDashboard.ServiceHealthCheckerTest do
  use FindMeHouseDashboard.DataCase, async: true
  alias FindMeHouseDashboard.ServiceHealthChecker
  alias FindMeHouseDashboard.Monitoring.ServiceStatus

  describe "status simulation" do
    test "simulate_status_check/1 transitions states correctly" do
      healthy_service = %ServiceStatus{status: "healthy"}
      degraded_service = %ServiceStatus{status: "degraded"}
      down_service = %ServiceStatus{status: "down"}

      status = ServiceHealthChecker.simulate_status_check(healthy_service)
      assert status in ["degraded", "healthy"]

      status = ServiceHealthChecker.simulate_status_check(degraded_service)
      assert status in ["degraded", "healthy", "down"]

      status = ServiceHealthChecker.simulate_status_check(down_service)
      assert status in ["degraded", "down"]
    end
  end

  describe "GenServer lifecycle" do
    test "that service is started and registered in the registry" do
      service = %ServiceStatus{
        id: 1,
        name: "Test Service",
        status: "healthy",
        last_checked: DateTime.truncate(DateTime.utc_now(), :second)
      }

      {:ok, pid} = ServiceHealthChecker.start_link(service)

      process_registry = Registry.lookup(FindMeHouseDashboard.RegistryService, service.id)
      assert process_registry != []
      [{registered_pid, _}] = process_registry
      assert Process.alive?(pid)
      assert registered_pid == pid
      Process.exit(pid, :normal)
    end
  end
end
