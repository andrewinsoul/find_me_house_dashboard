defmodule FindMeHouseDashboard.Repo.Migrations.CreateServiceStatuses do
  use Ecto.Migration

  def change do
    create table(:service_statuses) do
      add :name, :string, null: false
      add :status, :string, null: false
      add :last_checked, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
