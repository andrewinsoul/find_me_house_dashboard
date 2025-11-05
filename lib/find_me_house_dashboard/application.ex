defmodule FindMeHouseDashboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FindMeHouseDashboardWeb.Telemetry,
      FindMeHouseDashboard.Repo,
      {DNSCluster,
       query: Application.get_env(:find_me_house_dashboard, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FindMeHouseDashboard.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FindMeHouseDashboard.Finch},
      # Start a worker by calling: FindMeHouseDashboard.Worker.start_link(arg)
      # {FindMeHouseDashboard.Worker, arg},
      # Start to serve requests, typically the last entry
      FindMeHouseDashboardWeb.Endpoint,
      FindMeHouseDashboard.FindMeHouseSupervisor,
      FindMeHouseDashboard.SpinUpServices
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FindMeHouseDashboard.Supervisor]
    result = Supervisor.start_link(children, opts)

    spawn(fn ->
      Process.sleep(2000)
      open_browser()
    end)

    result
  end

  defp format_ip(ip) when is_tuple(ip) do
    ip
    |> Tuple.to_list()
    |> Enum.join(".")
  end

  defp format_ip(ip) when is_binary(ip), do: ip
  defp format_ip(ip) when is_list(ip), do: to_string(ip)
  defp format_ip(_), do: "localhost"

  defp running_in_docker? do
    File.exists?("/.dockerenv") ||
      File.read("/proc/1/cgroup")
      |> elem(1)
      |> to_string()
      |> String.contains?("docker") ||
      System.get_env("DOCKER_CONTAINER") == "true" ||
      System.get_env("IN_DOCKER") == "true"
  rescue
    _ -> false
  end

  defp open_browser do
    config = Application.get_env(:find_me_house_dashboard, FindMeHouseDashboardWeb.Endpoint)

    if running_in_docker?() do
      IO.puts("🐳 Running in Docker - skipping browser auto-open")
    else
      ip = get_in(config, [:http, :ip]) |> format_ip()
      port = get_in(config, [:http, :port])

      url = "http://#{ip}:#{port}"
      IO.puts("🚀 Opening browser at #{url}...")

      case :os.type() do
        {:win32, _} ->
          System.cmd("cmd", ["/c", "start", "#{url}"])

        {:unix, :darwin} ->
          System.cmd("open", ["#{url}"])

        {:unix, _} ->
          System.cmd("xdg-open", ["#{url}"])
      end

      IO.puts("✅ Browser should open momentarily!")
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FindMeHouseDashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
