defmodule Ztm.Stop do
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

  def changeset(stop, attrs) do
    stop
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end

  @spec create(map()) :: {:ok, __MODULE__.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    __MODULE__
    |> cast(params, @fields)
    |> Repo.insert()
  end

  @spec delete_by_id(binary()) :: {integer(), [term()]}
  def delete_by_id(id) do
    __MODULE__
    |> where(id: ^id)
    |> Repo.delete_all()
  end

  def update_stops(stops) when is_list(stops) do
    case Enum.filter(stops, &match?(%Ecto.Changeset{}, &1)) do
      [] ->
        {:error, "No changesets to insert"}

      changesets ->
        Repo.transaction(fn ->
          Repo.delete_all(__MODULE__)
          Enum.map(changesets, &Repo.insert(&1))
        end)
    end
  end
end
