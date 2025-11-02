defmodule FindMeHouseDashboard.ServiceStarterTest do
  use FindMeHouseDashboard.DataCase, async: false

  alias FindMeHouseDashboard.Monitoring.ServiceStatus
  alias FindMeHouseDashboard.Repo

  setup do
    Repo.delete_all(ServiceStatus)

    now = DateTime.truncate(DateTime.utc_now(), :second)

    ai_service =
      %ServiceStatus{name: "AI Service", status: "healthy", last_checked: now} |> Repo.insert!()

    db_service =
      %ServiceStatus{name: "DB Service", status: "degraded", last_checked: now} |> Repo.insert!()

    %{services: [ai_service, db_service]}
  end

  test "application starts with health checkers for each service in the DB" do
    Process.sleep(1200)

    dynamic_children =
      DynamicSupervisor.which_children(FindMeHouseDashboard.FindMeHouseDynamicSupervisor)

    child_count = length(dynamic_children)
    assert child_count == 2
  end
end
