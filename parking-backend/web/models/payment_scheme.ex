defmodule FindmeaparkingspaceBackend.PaymentScheme do
  use FindmeaparkingspaceBackend.Web, :model

  schema "payment_schemes" do
    field :type, :string
    field :amount, :float
    field :limit, :integer

    belongs_to :zone, FindmeaparkingspaceBackend.Zone, foreign_key: :zone_id
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :amount, :limit])
    |> validate_required([:type, :amount, :limit])
  end
end
