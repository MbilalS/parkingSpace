defmodule FindmeaparkingspaceBackend.Zone do
  use FindmeaparkingspaceBackend.Web, :model

  schema "zones" do
    field :name, :string

    has_many :parkings, FindmeaparkingspaceBackend.Parking
    has_many :payment_schemes, FindmeaparkingspaceBackend.PaymentScheme
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
