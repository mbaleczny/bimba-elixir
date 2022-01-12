defmodule Ztm.Stops.GetAllByPattern do
  import Ecto.Query

  def call(pattern) do
    pattern
    |> stops_by_pattern_query()
    |> Postgres.Repo.all()
  end

  defp stops_by_pattern_query(pattern) do
    tsquery_string = Postgres.TSQuery.to_tsquery_string(pattern)

    Ztm.Stops.Stop
    |> where(
      [s],
      fragment(
        "to_tsvector('simple', unaccent(?)) @@ to_tsquery('simple', unaccent(?))",
        s.stop_name,
        ^tsquery_string
      )
    )
    |> order_by(asc: :stop_name)
  end
end
