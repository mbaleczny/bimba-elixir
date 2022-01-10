defmodule Postgres.Repo do
  use Ecto.Repo,
    otp_app: :postgres,
    adapter: Ecto.Adapters.Postgres
end
