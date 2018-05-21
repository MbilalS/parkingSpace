defmodule FindmeaparkingspaceBackend.UserTest do
  use FindmeaparkingspaceBackend.ModelCase

  alias FindmeaparkingspaceBackend.User

  @valid_attrs %{password: "some password", name: "some name", role: "some role",
   email: "email@domail.com", password_confirmation: "some password", payment_scheme: "scheme",
   invoiced: "when"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
