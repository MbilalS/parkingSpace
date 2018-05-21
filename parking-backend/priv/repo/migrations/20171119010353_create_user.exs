defmodule FindmeaparkingspaceBackend.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :encrypted_password, :string
      add :role, :string
      add :invoiced, :string
      add :email, :string
      add :payment_scheme, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
