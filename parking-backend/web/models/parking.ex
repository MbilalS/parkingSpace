defmodule FindmeaparkingspaceBackend.Parking do
  use FindmeaparkingspaceBackend.Web, :model

  schema "parkings" do
    field :location, :string
    field :lot_number, :integer
    field :multi_point, Geo.MultiPoint
    field :distance, :float, virtual: true
    field :available_lots, :integer

    belongs_to :zone, FindmeaparkingspaceBackend.Zone, foreign_key: :zone_id
    has_many :allocations, FindmeaparkingspaceBackend.Allocation
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:location, :multi_point, :lot_number, :available_lots])
    |> validate_required([:location, :multi_point, :lot_number, :available_lots])
  end

  def within(query, point, radius_in_m) do
    {lng, lat} = point.coordinates
    from(parking in query, where: parking.available_lots > 0 and fragment("ST_DWithin(?::geography, ST_SetSRID(ST_MakePoint(?, ?), ?), ?)", parking.multi_point, ^lng, ^lat, ^point.srid, ^radius_in_m))
  end

  def order_by_nearest(query, point) do
    {lng, lat} = point.coordinates
    from(parking in query, order_by: fragment("? <-> ST_SetSRID(ST_MakePoint(?,?), ?)", parking.multi_point, ^lng, ^lat, ^point.srid))
  end

  def select_with_distance(query, point) do
    {lng, lat} = point.coordinates
    from(parking in query,
         select: %{parking | distance: fragment("ST_Distance_Sphere(?, ST_SetSRID(ST_MakePoint(?,?), ?))", parking.multi_point, ^lng, ^lat, ^point.srid)})
  end
end
