defmodule FindmeaparkingspaceBackend.Repo.Migrations.CreateAllocation do
  use Ecto.Migration

  def change do
    create table(:allocations) do
      add :longitude, :float
      add :latitude, :float
      add :status, :string
      add :extension, :boolean
      add :start_time, :string
      add :end_time, :string
      add :payment_scheme, :string

      timestamps()
    end
  end
end
