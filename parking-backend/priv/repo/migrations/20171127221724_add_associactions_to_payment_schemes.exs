defmodule FindmeaparkingspaceBackend.Repo.Migrations.AddAssociactionsToPaymentSchemes do
  use Ecto.Migration

  def change do
    alter table(:payment_schemes) do
      add :zone_id, references(:zones)
    end
  end
end
