defmodule FindmeaparkingspaceBackend.Allocation do
  use FindmeaparkingspaceBackend.Web, :model

  schema "allocations" do
    field :longitude, :float
    field :latitude, :float
    field :start_time, :string
    field :end_time, :string
    field :status, :string
    field :extension, :boolean, default: false
    field :payment_scheme, :string

    belongs_to :user, FindmeaparkingspaceBackend.User, foreign_key: :user_id
    belongs_to :parking, FindmeaparkingspaceBackend.Parking, foreign_key: :parking_id

    has_many :invoice_details, FindmeaparkingspaceBackend.InvoiceDetail
    
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:longitude, :latitude, :user_id, :parking_id, :status, :extension, :start_time, :end_time, :payment_scheme])
    |> validate_required([:longitude, :latitude, :user_id, :parking_id, :status, :extension, :start_time, :end_time, :payment_scheme])
  end
end
