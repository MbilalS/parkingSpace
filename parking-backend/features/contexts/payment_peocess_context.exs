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
  

    given_ ~r/^the following start times$/, fn state ->
        {:ok, state}
    end

    and_ ~r/^i am parked at a "(?<point>[^"]+)"$/,fn state ->
  
      {:ok, state}
    end


    and_ ~r/^I open the start page$/, 
    fn state ->
        {:ok, state}
    end

    and_ ~r/^select payment scheme "<scheme>"$/, fn state ->
        {:ok, state}
    end

    and_ ~r/^enter$/, fn state ->
        fill_field({:id, "leaving_time"}, state[:leaving_time])
        {:ok, state}
    end

    and_ ~r/^press submit$/, fn state ->
        click({:id, "submit_button"})
        {:ok, state}
    end

    when_ ~r/^I confirm the parking$/, fn state ->
        click({:id, "submit_button"})
        {:ok, state}
    end

    then_ ~r/^I should see a total amount of "(?<total>[^"]+)"$/,
    fn state, %{total: total} ->
        #assert visible_in_page? ~r/Your total amount is "(?<total>[^"]+)" euros/
    {:ok, state}
    end

    and_ ~r/^I pay$/, fn state ->
        {:ok, state}
    end

    then_ ~r/^I should see a "Successully paid" notification"$/, fn state ->
       # assert visible_in_page? ~r/Successully paid/
    {:ok, state}
    end


end  