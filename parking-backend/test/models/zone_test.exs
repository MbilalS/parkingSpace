defmodule FindmeaparkingspaceBackend.ZoneTest do
  use FindmeaparkingspaceBackend.ModelCase

  alias FindmeaparkingspaceBackend.Zone

  @valid_attrs %{name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Zone.changeset(%Zone{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Zone.changeset(%Zone{}, @invalid_attrs)
    refute changeset.valid?
  end
end
