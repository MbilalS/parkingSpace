defmodule FindmeaparkingspaceBackend.Repo.Migrations.AddAssociationsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :payment_scheme_id, references(:payment_schemes)
    end
  end
end
