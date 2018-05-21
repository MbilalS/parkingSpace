defmodule FindmeaparkingspaceBackend.ParkingTest do
  use FindmeaparkingspaceBackend.ModelCase

  alias FindmeaparkingspaceBackend.Parking

  @valid_attrs %{multi_point: %Geo.MultiPoint{coordinates: []}, location: "some location", lot_number: 10, available_lots: 10}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Parking.changeset(%Parking{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Parking.changeset(%Parking{}, @invalid_attrs)
    refute changeset.valid?
  end
end
