defmodule FindmeaparkingspaceBackend.Repo.Migrations.CreateBooking do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :destination_address, :string
      add :leaving_hour, :string
      add :payment_type, :string

      timestamps()
    end
  end
end
