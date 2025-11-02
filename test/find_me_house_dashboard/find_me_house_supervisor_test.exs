defmodule FindMeHouseDashboard.FindMeHouseSupervisorTest do
  use FindMeHouseDashboard.DataCase, async: false

  alias FindMeHouseDashboard.Monitoring.ServiceStatus
  alias FindMeHouseDashboard.Repo

  test "dynamic supervisor can start health checkers for services" do
    services = [
      %ServiceStatus{
        id: 1001,
        name: "Test Service 1",
        status: "healthy",
        last_checked: NaiveDateTime.local_now() |> DateTime.from_naive!("Etc/UTC")
      }
      |> Repo.insert!(),
      %ServiceStatus{
        id: 1002,
        name: "Test Service 2",
        status: "degraded",
        last_checked: NaiveDateTime.local_now() |> DateTime.from_naive!("Etc/UTC")
      }
      |> Repo.insert!()
    ]

    pids =
      Enum.map(services, fn service ->
        {:ok, pid} =
          DynamicSupervisor.start_child(
            FindMeHouseDashboard.FindMeHouseDynamicSupervisor,
            {FindMeHouseDashboard.ServiceHealthChecker, service}
          )

        pid
      end)

    dynamic_children =
      DynamicSupervisor.which_children(FindMeHouseDashboard.FindMeHouseDynamicSupervisor)

    child_count = length(dynamic_children)
    assert child_count == 2

    dynamic_children =
      DynamicSupervisor.which_children(FindMeHouseDashboard.FindMeHouseDynamicSupervisor)

    child_count = length(dynamic_children)
    assert child_count == 2

    Enum.each(pids, fn pid ->
      DynamicSupervisor.terminate_child(FindMeHouseDashboard.FindMeHouseDynamicSupervisor, pid)
    end)
  end
end
