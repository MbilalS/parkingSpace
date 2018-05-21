defmodule WhiteBreadContext do
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

  given_ ~r/^I want to go to "(?<destination>[^"]+)"$/,
  fn state,%{destination: destination} ->
    {:ok, state |> Map.put(:destination, destination)}
  end

  and_ ~r/^I open the FindMeAParkingSpace application$/, 
  fn state ->
    navigate_to "http://localhost:8080/"
    {:ok, state}
  end

  and_ ~r/^I enter my destination address$/, 
  fn state ->
    fill_field({:id, "search_box"}, state[:destination])
    {:ok, state}
  end

  when_ ~r/^I summit the request$/, 
  fn state ->
    click({:class, "q-btn"})
    {:ok, state}
  end
  
  then_ ~r/^I should be to view available places on a map$/, 
  fn state ->
    assert visible_in_element?({:id, "map"}, ~r/hidden/) == false
    assert visible_in_element?({:class, "q-list"}, ~r/hidden/) == false
    {:ok, state}
  end

end
