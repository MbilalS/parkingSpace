defmodule StartParkingContext do
  use WhiteBread.Context
  use Hound.Helpers
  alias FindmeaparkingspaceBackend.{Repo, Parking, Zone}

  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)    
    %{}
  end
  scenario_starting_state fn state ->
    Hound.start_session
    Ecto.Adapters.SQL.Sandbox.checkout(FindmeaparkingspaceBackend.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(FindmeaparkingspaceBackend.Repo, {:shared, self()})
    %{}
  end
  scenario_finalize fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(FindmeaparkingspaceBackend.Repo)
    #Hound.end_session
  end 

  given_ ~r/^the following parking areas are available$/,
  fn state, %{table_data: table} ->
    
    # Adding the various parking zones to the database
    # Adding the paid zones
    zone_params = [
      %{name: "A"},
      %{name: "B"},
      %{name: "C"},
      %{name: "D"}
    ]
    
    Enum.each(zone_params, fn(zone) ->
      Zone.changeset(%Zone{}, zone)
      |> Repo.insert!()
    end)
    
    table = Enum.map(table, fn parking -> 
                coord = String.split(parking.multipoint, ["!"]) 
                  |> Enum.map(fn i -> String.replace(i, "{","") 
                  |> String.replace("}","") 
                  |> String.split(",")end) 
                  |> Enum.map(fn x -> Enum.map(x, fn z-> Float.parse(String.trim(z)) |> elem(0)end) end) 
                  |> Enum.map(fn x -> List.to_tuple(x)end)
                
                Map.put(parking, :multi_point, %Geo.MultiPoint{coordinates: coord, srid: 4326}) |> Map.drop([:multipoint])
            end)
    {:ok, state |> Map.put(:table, table)}
  end

  and_ ~r/^the parking are located in "(?<zones>[^"]+)"$/,
  fn state, %{zones: zones} ->
    IO.inspect state[:table]
    String.split(zones, ",")
    |> Enum.with_index
    |> Enum.map(fn {zone_id, index} -> 
    
      zone = Repo.get_by!(Zone, name: zone_id)
      Ecto.build_assoc(zone, :parkings, Enum.at(state[:table], index))
      |> Parking.changeset()
      |> Repo.insert!
      end)

    {:ok, state}
  end

  and_ ~r/^I want to go to "(?<longitude>[^"]+)", "(?<latitude>[^"]+)"$/,
  fn state,%{longitude: longitude, latitude: latitude} ->
    {:ok, state |> Map.put(:longitude, longitude) |> Map.put(:latitude, latitude)}
  end

  and_ ~r/^I open the FindMeAParkingSpace application$/, 
  fn state ->
    navigate_to "/bookings"
    {:ok, state}
  end

  and_ ~r/^I enter my destination address$/, 
  fn state ->
    fill_field({:id, "longitude"}, state[:longitude])
    fill_field({:id, "latitude"}, state[:latitude])
    {:ok, state}
  end

  when_ ~r/^I summit the request$/, 
  fn state ->
    click({:id, "submit_button"})
    {:ok, state}
  end
  
  then_ ~r/^I should be notified "(?<notification>[^"]+)"$/, 
  fn state, %{notification: notification} ->
    assert visible_in_page? Regex.compile! notification    
    {:ok, state}
  end

end
