defmodule Postgres.TSQuery do
  def to_tsquery_string(input) do
    input
    |> split_words()
    |> build_tsquery()
  end

  defp split_words(string), do: string |> String.split(~r/\s+/) |> Enum.reject(&(&1 == ""))
  defp build_tsquery(words), do: words |> Enum.map_join(" & ", &(&1 <> ":*"))
end
