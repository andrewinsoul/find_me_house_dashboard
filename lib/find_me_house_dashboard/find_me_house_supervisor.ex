defmodule FindMeHouseDashboard.FindMeHouseSupervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      {
        DynamicSupervisor,
        strategy: :one_for_one, name: FindMeHouseDashboard.FindMeHouseDynamicSupervisor
      },
      {
        Registry,
        keys: :unique, name: FindMeHouseDashboard.RegistryService
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_service_checker(service) do
    child_spec = {
      FindMeHouseDashboard.ServiceHealthChecker,
      service
    }

    DynamicSupervisor.start_child(FindMeHouseDashboard.FindMeHouseDynamicSupervisor, child_spec)
  end
end
