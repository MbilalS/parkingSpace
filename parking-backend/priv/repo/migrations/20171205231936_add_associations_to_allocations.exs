defmodule FindmeaparkingspaceBackend.Repo.Migrations.AddAssociationsToAllocations do
  use Ecto.Migration

  def change do
    alter table(:allocations) do
      add :parking_id, references(:parkings)
      add :user_id, references(:users)
    end
  end
end
