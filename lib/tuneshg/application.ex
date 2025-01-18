defmodule Tuneshg.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TuneshgWeb.Telemetry,
      Tuneshg.Repo,
      {DNSCluster, query: Application.get_env(:tuneshg, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tuneshg.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Tuneshg.Finch},
      # Start a worker by calling: Tuneshg.Worker.start_link(arg)
      # {Tuneshg.Worker, arg},
      # Start to serve requests, typically the last entry
      TuneshgWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tuneshg.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TuneshgWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
