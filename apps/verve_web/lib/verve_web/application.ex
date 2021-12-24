defmodule VerveWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      VerveWeb.Telemetry,
      # Start the Endpoint (http/https)
      VerveWeb.Endpoint
      # Start a worker by calling: VerveWeb.Worker.start_link(arg)
      # {VerveWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VerveWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VerveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
