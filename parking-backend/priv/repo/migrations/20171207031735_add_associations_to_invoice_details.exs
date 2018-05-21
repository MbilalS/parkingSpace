defmodule FindmeaparkingspaceBackend.Repo.Migrations.AddAssociationsToInvoiceDetails do
  use Ecto.Migration

  def change do
    alter table(:invoice_details) do
      add :invoice_id, references(:invoices), null: false
      add :allocation_id, references(:allocations), null: false
    end
  end
end
