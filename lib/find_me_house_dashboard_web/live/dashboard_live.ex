defmodule FindMeHouseDashboardWeb.DashboardLive do
  use FindMeHouseDashboardWeb, :live_view
  alias FindMeHouseDashboard.Monitoring
  import FindMeHouseDashboardWeb.DashboardComponents

  @impl true
  def mount(_params, _session, socket) do
    # Subscribe to service updates
    if connected?(socket) do
      FindMeHouseDashboardWeb.Endpoint.subscribe("service_updates")
    end

    services = Monitoring.list_service_statuses()

    {:ok,
     socket
     |> assign(:services, services)
     |> assign(:last_updated, DateTime.utc_now())
     |> assign(:page_title, "FindMeHouse Health Dashboard")}
  end

  @impl true
  def handle_info(
        %{
          topic: "service_updates",
          event: "status_updated",
          payload: %{service: updated_service}
        },
        socket
      ) do
    # Update the specific service in the list
    updated_services =
      socket.assigns.services
      |> Enum.map(fn service ->
        if service.id == updated_service.id do
          updated_service
        else
          service
        end
      end)

    {:noreply,
     socket
     |> assign(:services, updated_services)
     |> assign(:last_updated, DateTime.utc_now())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-gray-50 border-gray-200 border-1 rounded-md">
      <.dashboard_header last_updated={@last_updated} />

      <div class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <%= for service <- @services do %>
            <.service_card service={service} />
          <% end %>
        </div>

        <%= if Enum.empty?(@services) do %>
          <.empty_services_state />
        <% end %>
      </div>
    </div>
    """
  end
end
