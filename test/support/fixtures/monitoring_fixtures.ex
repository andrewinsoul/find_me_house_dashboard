defmodule FindMeHouseDashboard.MonitoringFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindMeHouseDashboard.Monitoring` context.
  """

  @doc """
  Generate a service_status.
  """
  def service_status_fixture(attrs \\ %{}) do
    {:ok, service_status} =
      attrs
      |> Enum.into(%{
        last_checked: ~U[2025-10-30 02:54:00Z],
        name: "some name",
        status: "some status"
      })
      |> FindMeHouseDashboard.Monitoring.create_service_status()

    service_status
  end
end
