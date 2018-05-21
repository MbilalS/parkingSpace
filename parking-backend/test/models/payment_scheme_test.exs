defmodule FindmeaparkingspaceBackend.PaymentSchemeTest do
  use FindmeaparkingspaceBackend.ModelCase

  alias FindmeaparkingspaceBackend.PaymentScheme

  @valid_attrs %{amount: 120.5, limit: 42, type: "some type"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PaymentScheme.changeset(%PaymentScheme{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PaymentScheme.changeset(%PaymentScheme{}, @invalid_attrs)
    refute changeset.valid?
  end
end
