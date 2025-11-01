defmodule FindMeHouseDashboardWeb.DashboardComponents do
  use FindMeHouseDashboardWeb, :html

  @doc """
  Renders a service card component for the dashboard.
  """
  attr :service, :map, required: true
  attr :class, :string, default: nil

  def service_card(assigns) do
    ~H"""
    <div class={[
      "bg-white rounded-lg shadow-md border-l-4 overflow-hidden",
      status_border_color(@service.status),
      @class
    ]}>
      <div class="p-6">
        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <div class={["w-3 h-3 rounded-full mr-3", status_dot_color(@service.status)]}></div>
            <h3 class="text-lg font-semibold text-gray-900"><%= @service.name %></h3>
          </div>
          <span class={[
            "inline-flex items-center px-3 py-1 rounded-full text-sm font-medium",
            status_badge_color(@service.status)
          ]}>
            <%= String.capitalize(@service.status) %>
          </span>
        </div>

        <div class="mt-4 text-sm text-gray-600">
          <div class="flex justify-between">
            <span>Last checked:</span>
            <span class="font-mono"><%= format_time(@service.last_checked) %></span>
          </div>
          <div class="flex justify-between mt-1">
            <span>Service ID:</span>
            <span class="font-mono text-xs"><%= @service.id %></span>
          </div>
        </div>

        <div class="mt-4 text-sm">
          <p :if={@service.status == "healthy"} class="text-green-700">
            ✅ Operating normally
          </p>
          <p :if={@service.status == "degraded"} class="text-yellow-700">
            ⚠️ Performance issues detected
          </p>
          <p :if={@service.status == "down"} class="text-red-700">
            🔴 Service unavailable
          </p>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders the dashboard header.
  """
  attr :last_updated, :string, required: true
  attr :class, :string, default: nil

  def dashboard_header(assigns) do
    ~H"""
    <div class={["bg-white shadow", @class]}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-6">
          <div>
            <p class="text-gray-600 mt-1">Real-time monitoring of all services</p>
          </div>
          <div class="text-sm text-gray-500">
            Last updated: <%= format_time(@last_updated) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders an empty state when no services are available.
  """
  attr :class, :string, default: nil

  def empty_services_state(assigns) do
    ~H"""
    <div class={["text-center py-12", @class]}>
      <div class="text-gray-400">
        <svg class="mx-auto h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width={2} d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
        </svg>
        <h3 class="mt-2 text-sm font-medium text-gray-900">No services</h3>
        <p class="mt-1 text-sm text-gray-500">Get started by adding some services to monitor.</p>
      </div>
    </div>
    """
  end

  # Private helper functions
  def status_border_color("healthy"), do: "border-green-500"
  def status_border_color("degraded"), do: "border-yellow-500"
  def status_border_color("down"), do: "border-red-500"

  def status_dot_color("healthy"), do: "bg-green-500"
  def status_dot_color("degraded"), do: "bg-yellow-500"
  def status_dot_color("down"), do: "bg-red-500"

  def status_badge_color("healthy"), do: "bg-green-100 text-green-800"
  def status_badge_color("degraded"), do: "bg-yellow-100 text-yellow-800"
  def status_badge_color("down"), do: "bg-red-100 text-red-800"

  def format_time(datetime) do
    time = DateTime.to_time(datetime)
    String.pad_leading(Integer.to_string(time.hour), 2, "0") <> ":" <>
    String.pad_leading(Integer.to_string(time.minute), 2, "0") <> ":" <>
    String.pad_leading(Integer.to_string(time.second), 2, "0")
  end
end
