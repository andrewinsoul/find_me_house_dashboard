defmodule FindMeHouseDashboard.ServiceStarterTest do
  use FindMeHouseDashboard.DataCase, async: false

  alias FindMeHouseDashboard.Monitoring.ServiceStatus
  alias FindMeHouseDashboard.Monitoring
  alias FindMeHouseDashboard.ServiceHealthChecker
  alias FindMeHouseDashboard.Repo

  test "that database is updated periodically after application starts" do
    service =
      %ServiceStatus{
        id: System.unique_integer([:positive]),
        name: "Periodic Test Service",
        status: "healthy",
        last_checked: NaiveDateTime.local_now() |> DateTime.from_naive!("Etc/UTC")
      }
      |> Repo.insert!()

    {:ok, pid} = ServiceHealthChecker.start_link(service)

    initial_service = Monitoring.get_service_status!(service.id)
    initial_check_time = initial_service.last_checked

    :timer.sleep(1400)

    updated_service = Monitoring.get_service_status!(service.id)
    assert DateTime.compare(updated_service.last_checked, initial_check_time) == :gt

    Process.exit(pid, :normal)
    Repo.delete(service)
  end
end
