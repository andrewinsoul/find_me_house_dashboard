defmodule FindMeHouseDashboard.Monitoring do
  @moduledoc """
  The Monitoring context.
  """

  import Ecto.Query, warn: false
  alias FindMeHouseDashboard.Repo

  alias FindMeHouseDashboard.Monitoring.ServiceStatus

  @doc """
  Returns the list of service_statuses.

  ## Examples

      iex> list_service_statuses()
      [%ServiceStatus{}, ...]

  """
  def list_service_statuses do
    Repo.all(ServiceStatus)
  end

  @doc """
  Updates a service status and broadcasts the change to all connected clients.
  """
  def update_service_status_and_broadcast(%ServiceStatus{} = service_status, attrs) do
    case update_service_status(service_status, attrs) do
      {:ok, updated_service} ->

        FindMeHouseDashboardWeb.Endpoint.broadcast!("service_updates", "status_updated", %{
          service: updated_service
        })
        {:ok, updated_service}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Gets a single service_status.

  Raises `Ecto.NoResultsError` if the Service status does not exist.

  ## Examples

      iex> get_service_status!(123)
      %ServiceStatus{}

      iex> get_service_status!(456)
      ** (Ecto.NoResultsError)

  """
  def get_service_status!(id), do: Repo.get!(ServiceStatus, id)


  @doc """
  Updates a service_status.

  ## Examples

      iex> update_service_status(service_status, %{field: new_value})
      {:ok, %ServiceStatus{}}

      iex> update_service_status(service_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_service_status(%ServiceStatus{} = service_status, attrs) do
    service_status
    |> ServiceStatus.changeset(attrs)
    |> Repo.update()
  end

end
