defmodule Ztm.Application do
  use Application

  def start(_type, _args) do
    children = [Ztm.Scheduler]

    opts = [strategy: :one_for_one, name: Ztm.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
