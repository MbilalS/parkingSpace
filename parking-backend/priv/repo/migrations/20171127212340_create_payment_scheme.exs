defmodule FindmeaparkingspaceBackend.Repo.Migrations.CreatePaymentScheme do
  use Ecto.Migration

  def change do
    create table(:payment_schemes) do
      add :type, :string
      add :amount, :float
      add :limit, :integer

      timestamps()
    end
  end
end
