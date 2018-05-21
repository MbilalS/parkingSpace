defmodule FindmeaparkingspaceBackend.Repo.Migrations.CreateInvoice do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :status, :string

      timestamps(type: :timestamptz)
    end
  end
end
