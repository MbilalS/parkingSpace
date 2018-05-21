defmodule FindmeaparkingspaceBackend.Repo.Migrations.AddAssociationsToInvoices do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add :user_id, references(:users), null: false
    end
  end
end
