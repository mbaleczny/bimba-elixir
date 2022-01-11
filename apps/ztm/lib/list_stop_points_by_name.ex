defmodule Ztm.ListStopPointsByName do
  alias Ztm.Stop

  def call(pattern, distinct_names \\ false) do
    pattern
    |> stop_points_by_name(distinct_names)
    |> Postgres.Repo.all()
  end

  defp stop_points_by_name(pattern, distinct_names) do
    base_query =
      from(s in Stop,
        order_by:
          fragment(
            "(CASE WHEN ? LIKE ? THEN 1 ELSE 2 END)",
            s.stop_name,
            ^"#{String.first(pattern)}%"
          )
      )

    query =
      case distinct_names do
        true -> from(s in base_query, distinct: s.stop_name)
        false -> base_query
      end

    case any_ascii_122?(pattern) do
      true ->
        from(s in query,
          where: fragment("lower(?) like lower(?)", s.stop_name, ^"%#{pattern}%"),
          select: s
        )

      false ->
        from(s in query,
          where:
            fragment("lower(unaccent(?)) like lower(unaccent(?))", s.stop_name, ^"%#{pattern}%"),
          select: s
        )
    end
  end

  defp any_ascii_122?(pattern) do
    pattern
    |> String.graphemes()
    |> Enum.map(&(String.to_charlist(&1) |> hd()))
    |> Enum.any?(&(&1 > 122))
  end
end
