defmodule Ztm.Stops.Stop do
  use Postgres.Schema
  import Ecto.Query

  @type t() :: %__MODULE__{}

  @primary_key {:stop_id, :integer, autogenerate: false}
  schema "stops" do
    field(:stop_code, :string)
    field(:stop_lat, :decimal)
    field(:stop_lon, :decimal)
    field(:stop_name, :string)
    field(:zone_id, :string)

    timestamps()
  end

  @fields [:stop_id, :stop_code, :stop_name, :stop_lat, :stop_lon, :zone_id]

  @spec get_all_by_name_pattern(binary()) :: list(__MODULE__.t())
  def get_all_by_name_pattern(pattern) do
    tsquery_string = to_tsquery_string(pattern)

    __MODULE__
    |> where(
      [s],
      fragment(
        "to_tsvector('simple', unaccent(?)) @@ to_tsquery('simple', unaccent(?))",
        s.stop_name,
        ^tsquery_string
      )
    )
    |> order_by(asc: :stop_name)
    |> Repo.all()
  end

  @spec delete_by_id(binary()) :: {integer(), [term()]}
  def delete_by_id(id) do
    __MODULE__
    |> where(id: ^id)
    |> Repo.delete_all()
  end

  @spec replace_all_with(list(map)) :: {:ok, :success} | {:error, :incorrect_items_count}
  def replace_all_with(items) when is_list(items) do
    items_count = length(items)
    changeset_list = Enum.map(items, &changeset(%__MODULE__{}, &1))

    Repo.transaction(fn repo ->
      _ = repo.delete_all(__MODULE__)

      results_count =
        changeset_list
        |> Enum.map(&repo.insert(&1))
        |> Enum.filter(fn result -> elem(result, 0) == :ok end)
        |> Enum.count()

      if results_count == items_count do
        :success
      else
        repo.rollback(:incorrect_items_count)
      end
    end)
  end

  defp changeset(stop, attrs) do
    stop
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
