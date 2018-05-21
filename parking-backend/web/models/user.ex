defmodule FindmeaparkingspaceBackend.User do
  use FindmeaparkingspaceBackend.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :role, :string, default: "customer"
    field :invoiced, :string, default: "IMMEDIATELY"
    field :payment_scheme, :string, default: "HOURLY"
    field :password_confirmation, :string, virtual: true

    has_many :allocations, FindmeaparkingspaceBackend.Allocation
    has_many :invoices, FindmeaparkingspaceBackend.Invoice
    
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password, :role, :password_confirmation, :payment_scheme])
    |> validate_required([:name, :email, :password, :role, :password_confirmation, :payment_scheme])
    |> validate_format(:email, ~r/@/)
    |> validate_confirmation(:password)
    |> encrypt_password()
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :role, :invoiced, :payment_scheme])
  end

  def encrypt_password(changeset) do
    if changeset.valid? do
      put_change(changeset, :encrypted_password, Comeonin.Pbkdf2.hashpwsalt(changeset.changes[:password]))
    else
      changeset
    end
  end
end
