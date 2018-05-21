defmodule FindmeaparkingspaceBackend.GeoLocator do
    alias FindmeaparkingspaceBackend.{Repo, Parking}
    @gmaps_api_key Application.get_env(:findmeaparkingspace_backend, :gmaps_api_key)
    def available_parking(destination, radius \\ 100, origin \\ 'controller') do
        parkings = Parking.within(Parking, destination, radius) 
        |> Parking.order_by_nearest(destination) 
        |> Parking.select_with_distance(destination) 
        |> Repo.all()
        |> Repo.preload([:zone])

        if origin == 'allocator' || length(parkings) > 0 do
            parkings
        else
            Parking.within(Parking, destination, radius + 100) 
            |> Parking.order_by_nearest(destination) 
            |> Parking.select_with_distance(destination) 
            |> Repo.all()
            |> Repo.preload([:zone])
        end
    end

    def all_parking() do
        Repo.all(Parking) |> Repo.preload([:zone])
    end

    def map_data(parkings) do
            zone_a = {"A", Enum.filter(parkings, fn parking -> parking.zone.name == "A" end)}
            zone_b = {"B", Enum.filter(parkings, fn parking -> parking.zone.name == "B" end)}
            zone_c = {"C", Enum.filter(parkings, fn parking -> parking.zone.name == "C" end)}
            zone_d = {"D", Enum.filter(parkings, fn parking -> parking.zone.name == "D" end)}
            [zone_a, zone_b, zone_c, zone_d]  |> Enum.map(fn {name, parkings} -> %{name: name, coordinates:  Enum.map(parkings, fn parking -> Enum.map(parking.multi_point.coordinates, fn {x,y} -> %{lng: x, lat: y}  end) end)} end)
    end

    def get_parking_place(destination) do
        destination = String.replace(destination,",","")|> String.replace(" ","+") 
        url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{destination}&key=#{@gmaps_api_key}"
        %{body: body} = HTTPoison.get!(url)
        body = body |> Poison.decode!
        IO.inspect body
        if body["status"] == "OK" do
            %{"lat" => latitude, "lng" => longitude} = List.first(body["results"])["geometry"]["location"];
            {:ok,{longitude, latitude}}
           
        else
            {:error,{0, 0}}
        end
        #{:ok,{26.7195562, 58.3810459}}
       end

end