defmodule Verve.Repo do
  use Ecto.Repo,
    otp_app: :verve,
    adapter: Ecto.Adapters.Postgres
end
