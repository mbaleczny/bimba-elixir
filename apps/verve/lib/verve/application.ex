defmodule Verve.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Verve.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Verve.PubSub}
      # Start a worker by calling: Verve.Worker.start_link(arg)
      # {Verve.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Verve.Supervisor)
  end
end
