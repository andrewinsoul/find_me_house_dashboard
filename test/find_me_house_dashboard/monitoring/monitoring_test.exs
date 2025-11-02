defmodule FindMeHouseDashboard.MonitoringTest do
  use FindMeHouseDashboard.DataCase, async: true
  alias FindMeHouseDashboard.Monitoring
  alias FindMeHouseDashboard.Monitoring.ServiceStatus

  describe "service status operations" do
    setup do
      now = DateTime.truncate(DateTime.utc_now(), :second)

      healthy_service =
        %ServiceStatus{
          name: "Test API",
          status: "healthy",
          last_checked: now
        }
        |> Repo.insert!()

      degraded_service =
        %ServiceStatus{
          name: "Test DB",
          status: "degraded",
          last_checked: now
        }
        |> Repo.insert!()

      %{healthy_service: healthy_service, degraded_service: degraded_service}
    end

    test "list_service_statuses/0 returns all services", %{
      healthy_service: healthy,
      degraded_service: degraded
    } do
      services = Monitoring.list_service_statuses()
      assert length(services) == 2
      assert healthy in services
      assert degraded in services
    end

    test "get_service_status!/1 returns service by id", %{healthy_service: service} do
      found_service = Monitoring.get_service_status!(service.id)
      assert found_service.id == service.id
      assert found_service.name == service.name
    end

    test "update_service_status/2 updates service attributes", %{healthy_service: service} do
      assert {:ok, updated_service} =
               Monitoring.update_service_status(service, %{status: "degraded"})

      assert updated_service.status == "degraded"
      assert updated_service.id == service.id
    end

    test "update_service_status/2 returns error for invalid attributes", %{
      healthy_service: service
    } do
      assert {:error, changeset} =
               Monitoring.update_service_status(service, %{status: "invalid_status"})

      assert "is invalid" in errors_on(changeset).status
    end
  end
end
