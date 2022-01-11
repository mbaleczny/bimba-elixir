defmodule Postgres.Repo.Migrations.CreateExtensionUnAccent do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS unaccent")
  end
end
