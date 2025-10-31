defmodule FindMeHouseDashboard.MonitoringTest do
  use FindMeHouseDashboard.DataCase

  alias FindMeHouseDashboard.Monitoring

  describe "service_statuses" do
    alias FindMeHouseDashboard.Monitoring.ServiceStatus

    import FindMeHouseDashboard.MonitoringFixtures

    @invalid_attrs %{name: nil, status: nil, last_checked: nil}

    test "list_service_statuses/0 returns all service_statuses" do
      service_status = service_status_fixture()
      assert Monitoring.list_service_statuses() == [service_status]
    end

    test "get_service_status!/1 returns the service_status with given id" do
      service_status = service_status_fixture()
      assert Monitoring.get_service_status!(service_status.id) == service_status
    end

    test "create_service_status/1 with valid data creates a service_status" do
      valid_attrs = %{name: "some name", status: "some status", last_checked: ~U[2025-10-30 02:54:00Z]}

      assert {:ok, %ServiceStatus{} = service_status} = Monitoring.create_service_status(valid_attrs)
      assert service_status.name == "some name"
      assert service_status.status == "some status"
      assert service_status.last_checked == ~U[2025-10-30 02:54:00Z]
    end

    test "create_service_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_service_status(@invalid_attrs)
    end

    test "update_service_status/2 with valid data updates the service_status" do
      service_status = service_status_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", last_checked: ~U[2025-10-31 02:54:00Z]}

      assert {:ok, %ServiceStatus{} = service_status} = Monitoring.update_service_status(service_status, update_attrs)
      assert service_status.name == "some updated name"
      assert service_status.status == "some updated status"
      assert service_status.last_checked == ~U[2025-10-31 02:54:00Z]
    end

    test "update_service_status/2 with invalid data returns error changeset" do
      service_status = service_status_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitoring.update_service_status(service_status, @invalid_attrs)
      assert service_status == Monitoring.get_service_status!(service_status.id)
    end

    test "delete_service_status/1 deletes the service_status" do
      service_status = service_status_fixture()
      assert {:ok, %ServiceStatus{}} = Monitoring.delete_service_status(service_status)
      assert_raise Ecto.NoResultsError, fn -> Monitoring.get_service_status!(service_status.id) end
    end

    test "change_service_status/1 returns a service_status changeset" do
      service_status = service_status_fixture()
      assert %Ecto.Changeset{} = Monitoring.change_service_status(service_status)
    end
  end
end
