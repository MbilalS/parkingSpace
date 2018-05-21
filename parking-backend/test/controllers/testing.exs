defmodule FindmeaparkingspaceBackend.ServicesTest do
    use ExUnit.Case
    alias FindmeaparkingspaceBackend.{Repo, Parking}
    
     test "Find parking place by destination address"do
        destination = "Ulikooli 18, 51005 Tartu, Estonia"
        {status,{longitude, latitude}} = FindmeaparkingspaceBackend.GeoLocator.get_parking_place(destination)

        assert status == :ok
        assert latitude == 58.3810459
        assert longitude == 26.7195562
     end
  
  end