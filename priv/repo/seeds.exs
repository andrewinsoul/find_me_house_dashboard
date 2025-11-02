alias FindMeHouseDashboard.Repo
alias FindMeHouseDashboard.Monitoring.ServiceStatus


Repo.delete_all(ServiceStatus)

services = [
  %{
    name: "Auth Service",
    status: "healthy",
    last_checked: NaiveDateTime.local_now()
  },
  %{
    name: "Payment Service",
    status: "healthy",
    last_checked: NaiveDateTime.local_now()
  },
  %{
    name: "AI Agent Service",
    status: "degraded",
    last_checked: NaiveDateTime.local_now()
  },
  %{
    name: "Media Storage Service",
    status: "healthy",
    last_checked: NaiveDateTime.local_now()
  },
  %{
    name: "Database Service",
    status: "down",
    last_checked: NaiveDateTime.local_now()
  }
]

Enum.each(services, fn service_attrs ->
  %ServiceStatus{}
  |> ServiceStatus.changeset(service_attrs)
  |> Repo.insert!()
end)

IO.puts "Seeded #{length(services)} services"
