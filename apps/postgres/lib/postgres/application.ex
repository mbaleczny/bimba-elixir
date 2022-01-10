defmodule Postgres.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Postgres.Repo,
      {Phoenix.PubSub, name: Postgres.PubSub}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Postgres.Supervisor)
  end
end
