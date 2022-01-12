defmodule Postgres.Repo.Migrations.CreateStopsTableSearchIndex do
  use Ecto.Migration

  def change do
    to_tsvector = "to_tsvector('simple', stop_name)"

    execute("""
    CREATE INDEX stops_search_index
      ON stops
      USING GIN (#{to_tsvector});
    """)
  end
end
