defmodule FindMeHouseDashboard.Monitoring.ServiceStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "service_statuses" do
    field :name, :string
    field :status, :string
    field :last_checked, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service_status, attrs) do
    service_status
    |> cast(attrs, [:name, :status, :last_checked])
    |> validate_required([:name, :status, :last_checked])
    |> validate_inclusion(:status, ["healthy", "degraded", "down"])
  end
end
