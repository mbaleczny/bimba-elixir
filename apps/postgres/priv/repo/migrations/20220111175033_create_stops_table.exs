defmodule Postgres.Repo.Migrations.CreateStopsTable do
  use Ecto.Migration

  def change do
    create table(:stops, primary_key: false) do
      add(:stop_id, :integer, primary_key: true)
      add(:stop_code, :string)
      add(:stop_name, :string)
      add(:stop_lat, :decimal)
      add(:stop_lon, :decimal)
      add(:zone_id, :string)

      timestamps()
    end
  end
end
