defmodule FindmeaparkingspaceBackend.ParkingController do
    use FindmeaparkingspaceBackend.Web, :controller
    alias FindmeaparkingspaceBackend.{GeoLocator}
  
    def index(conn, _params) do
      spaces = GeoLocator.all_parking()
      render conn, "index.html", changeset: %{}, spaces: spaces, map_data: get_map_data(spaces)
    end


    def create(conn, booking_params) do
      longitude = Float.parse(booking_params["longitude"]) |> elem(0)
      latitude = Float.parse(booking_params["latitude"]) |> elem(0)
      destination = %Geo.Point{coordinates: { longitude, latitude}, srid: 4326}
      spaces = GeoLocator.available_parking(destination, 100)
      messages = Enum.map(spaces, fn space -> 
          cond do
            space.zone.name == "A" || space.zone.name == "B" ->
              "Zone #{space.zone.name} paid parking available at #{space.location}"
            
            space.zone.name == "C"->
              "Free Limited parking available at #{space.location}"

            space.zone.name == "D" ->
              "Free unlimited parking available at #{space.location}" 
          end
        end)
      conn = conn |> put_flash(:info, List.first(messages))
      render conn, "index.html", changeset: %{}, spaces: spaces, map_data: get_map_data(spaces)
    end

    defp get_map_data(spaces) do
      cond  do
        length(spaces) > 0  -> GeoLocator.map_data(spaces)
        true -> [] 
      end
    end
  end
  