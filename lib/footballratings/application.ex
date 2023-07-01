defmodule Footballratings.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FootballratingsWeb.Telemetry,
      # Start the Ecto repository
      Footballratings.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Footballratings.PubSub},
      # Start Finch
      {Finch, name: Footballratings.Finch},
      # Start the Endpoint (http/https)
      FootballratingsWeb.Endpoint,
      # Start a worker by calling: Footballratings.Worker.start_link(arg)
      # {Footballratings.Worker, arg}
      {Oban, Application.fetch_env!(:footballratings, Oban)},
      Footballratings.LiveStats
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Footballratings.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FootballratingsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
