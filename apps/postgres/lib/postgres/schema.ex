defmodule Postgres.Schema do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Postgres.TSQuery
      alias Postgres.Repo

      @primary_key {:id, :binary_id, autogenerate: true}
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
