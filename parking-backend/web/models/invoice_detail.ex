defmodule FindmeaparkingspaceBackend.InvoiceDetail do
  use FindmeaparkingspaceBackend.Web, :model

  schema "invoice_details" do

    belongs_to :invoice, FindmeaparkingspaceBackend.Invoice, foreign_key: :invoice_id
    belongs_to :allocation, FindmeaparkingspaceBackend.Allocation, foreign_key: :allocation_id
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:invoice_id, :allocation_id])
    |> validate_required([:invoice_id, :allocation_id])
  end
end
