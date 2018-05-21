defmodule FindmeaparkingspaceBackend.Repo.Migrations.CreateInvoiceDetail do
  use Ecto.Migration

  def change do
    create table(:invoice_details) do
      timestamps()
    end
  end
end
