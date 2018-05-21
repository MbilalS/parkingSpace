defmodule FindmeaparkingspaceBackend.Invoice do
  use FindmeaparkingspaceBackend.Web, :model

  schema "invoices" do
    field :status, :string, default: "not paid"

    belongs_to :user, FindmeaparkingspaceBackend.User, foreign_key: :user_id
    has_many :invoice_details, FindmeaparkingspaceBackend.InvoiceDetail
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [ :status, :user_id])
    |> validate_required([ :status, :user_id])
  end
end
