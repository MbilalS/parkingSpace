defmodule FindmeaparkingspaceBackend.InvoiceDetailTest do
  use FindmeaparkingspaceBackend.ModelCase

  alias FindmeaparkingspaceBackend.InvoiceDetail

  @valid_attrs %{invoice_id: 1, allocation_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = InvoiceDetail.changeset(%InvoiceDetail{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = InvoiceDetail.changeset(%InvoiceDetail{}, @invalid_attrs)
    refute changeset.valid?
  end
end
