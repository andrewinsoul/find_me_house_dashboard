defmodule FindMeHouseDashboardWeb.DashboardLiveTest do
  use FindMeHouseDashboardWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias FindMeHouseDashboard.Monitoring.ServiceStatus
  alias FindMeHouseDashboard.Repo

  describe "mount/3" do
    test "renders the dashboard with services", %{conn: conn} do
      now = DateTime.truncate(DateTime.utc_now(), :second)

      %ServiceStatus{
        name: "Test Service",
        status: "healthy",
        last_checked: now
      }
      |> Repo.insert!()

      {:ok, _view, html} = live(conn, "/")

      assert html =~ "FindMeHouse Health Dashboard"
      assert html =~ "Test Service"
      assert html =~ "Healthy"
      assert html =~ "Operating normally"
    end

    test "renders empty state when no services", %{conn: conn} do
      Repo.delete_all(ServiceStatus)

      {:ok, _view, html} = live(conn, "/")

      assert html =~ "No services"
      assert html =~ "Get started by adding some services to monitor"
    end
  end

  describe "handle_info for real-time updates" do
    test "updates service status when receiving PubSub message", %{conn: conn} do
      now = DateTime.truncate(DateTime.utc_now(), :second)

      service =
        %ServiceStatus{
          name: "Test Service",
          status: "healthy",
          last_checked: now
        }
        |> Repo.insert!()

      {:ok, view, _html} = live(conn, "/")

      assert render(view) =~ "Healthy"
      assert render(view) =~ "Operating normally"

      updated_service = %{service | status: "degraded", last_checked: now}

      send(view.pid, %{
        topic: "service_updates",
        event: "status_updated",
        payload: %{service: updated_service}
      })

      assert render(view) =~ "Degraded"
      assert render(view) =~ "Performance issues detected"
    end
  end

  describe "navigation" do
    test "page title is set correctly", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      assert has_element?(view, "h1", "FindMeHouse Health Dashboard")
    end
  end
end
