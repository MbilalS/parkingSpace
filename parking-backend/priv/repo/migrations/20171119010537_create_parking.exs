defmodule FindmeaparkingspaceBackend.Repo.Migrations.CreateParking do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
    create table(:parkings) do
      add :location, :string
      add :lot_number, :integer
      add :available_lots, :integer
      timestamps()
    end
    execute("SELECT AddGeometryColumn ('parkings','multi_point',4326,'MULTIPOINT',2)")
    execute("CREATE INDEX parkings_multi_point_index on parkings USING gist (multi_point)")
  end
end
