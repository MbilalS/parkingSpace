defmodule FindmeaparkingspaceBackend.ParkingAPIController do
    use FindmeaparkingspaceBackend.Web, :controller

    import Ecto.Query, only: [from: 2]
    alias FindmeaparkingspaceBackend.{Allocation, GeoLocator, FeesService, ParkingAllocator, InvoiceDetail, Zone}
  
    def index(conn, params) do
      
      destination = if params["destination"] && String.length(params["destination"]) > 0 do
                  case FindmeaparkingspaceBackend.GeoLocator.get_parking_place(params["destination"]) do
                    {:ok,{longitude, latitude}} ->
                      %Geo.Point{coordinates: { longitude,latitude}, srid: 4326}
                      _ ->
                        nil
                  end
               end

      if destination do
        spaces = GeoLocator.available_parking(destination) |> Enum.take(3)
        IO.inspect spaces
        conn
        |> put_status(200)
        |> json(%{spaces: prepare(spaces, params["leaving_time"]), location: %{lat: elem(destination.coordinates,1), lng: elem(destination.coordinates,0)}}) #map_data: get_map_data(spaces)
      else
        conn
        |> put_status(404)
        |> json(%{msg: "Our apologies, there is no available parking near your destination"})
      end

    end

    def create(conn, params) do
      user = Guardian.Plug.current_resource(conn)
      query = from a in Allocation, where: a.user_id == ^user.id and a.status == "OPEN", select: a
      allocations = Repo.all(query) 
      if length(allocations) > 0 do
        conn
        |> put_status(400)
        |> json(%{msg: "We can't serve your request now. You have an ongoing parking!"})
      else

        position = %Geo.Point{
          coordinates: { params["longitude"], params["latitude"] }, 
          srid: 4326}
        parkings = GeoLocator.available_parking(position, 50, 'allocator')
        if length(parkings) > 0 do
            parking = List.first(parkings)
            allocation =
            Allocation.changeset(%Allocation{}, 
                %{longitude: params["longitude"], 
                latitude: params["latitude"],
                status: "PENDING",
                start_time: Timex.local() |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime) ,
                end_time: params["leaving_time"],
                payment_scheme: params["payment_scheme"],
                user_id: user.id,
                parking_id: parking.id}) 
            |> Repo.insert!
    
            reference = String.to_atom("allocation_#{allocation.id}")
    
            {:ok, _} = ParkingAllocator.start_link(allocation |> Map.put(:user, user), reference)
            ParkingAllocator.allocate_parking(reference)  

            conn
            |> put_status(201)
            |> json(%{msg: "We are processing your request"})
            
        else
          conn
          |> put_status(404)
          |> json(%{msg: "OOps, We can't identify your parking."})
        end
      end

    end

    
    def update(conn, %{"status" => decision, "id" => id}) do
      user = Guardian.Plug.current_resource(conn)    
      
      case decision do
        "rejected" ->
          ParkingAllocator.reject_allocation(String.to_atom("allocation_#{id}"), user.email)
        "accepted" ->
          ParkingAllocator.accept_allocation(String.to_atom("allocation_#{id}"), user.email)
      end
  
      conn
      |> put_status(200)
      |> json(%{msg: "Your decision has been taken into account"})
    end

    def extend(conn, %{"id" => id}) do
      user = Guardian.Plug.current_resource(conn)    
      ParkingAllocator.extend_parking(String.to_atom("allocation_#{id}"), user.email)
      conn
      |> put_status(200)
      |> json(%{msg: "Parking extension has been scheduled"})
    end

    def ending(conn, %{"status" => _status, "id" => id}) do
      user = Guardian.Plug.current_resource(conn) 
      ParkingAllocator.end_parking(String.to_atom("allocation_#{id}"), user.email)
      conn
      |> put_status(200)
      |> json(%{msg: "Thank you for using our services"})
    end

    def status(conn, _params) do
      user = Guardian.Plug.current_resource(conn)
      query = from a in Allocation, where: a.user_id == ^user.id and a.status == "OPEN", select: a
      allocations = Repo.all(query) |> Repo.preload([{:parking, [:zone]}])  
      if length(allocations) > 0 do
        current = List.first(allocations)
        {elapsed_time, time_left} = FeesService.getElapsedTime(current)
        invoices = Repo.all(from i in InvoiceDetail, where: i.allocation_id == ^current.id, select: i) |> Repo.preload([{:allocation, [{:parking, [:zone]}]}])
        if invoices && length(invoices)>0 do
          conn
          |> put_status(200)
          |> json(%{id: current.id, location: current.parking.location, elapsed_time: elapsed_time,  time_left: time_left, start_time: current.start_time, end_time: current.end_time, amount: FeesService.getTotalAmount(invoices), payment_scheme: current.payment_scheme })
        else
          conn
          |> put_status(200)
          |> json(%{id: current.id, location: current.parking.location, elapsed_time: elapsed_time,  time_left: time_left, start_time: current.start_time, end_time: current.end_time, payment_scheme: current.payment_scheme, estimate: FeesService.getEstimateAmount(current)})
        end
        
      else
        conn
        |> put_status(404)
        |> json(%{msg: "No open parkings"})
      end    
    end

    def current(conn, params) do
      longitude  = Float.parse(params["longitude"]) |> elem(0)
      latitude  = Float.parse(params["latitude"]) |> elem(0)
      position = %Geo.Point{
        coordinates: { longitude, latitude }, 
        srid: 4326}
      parkings = GeoLocator.available_parking(position, 50, 'allocator')
      if length(parkings) > 0 do
        parking = List.first(parkings)
        zone = Repo.get!(Zone, parking.zone.id) |> Repo.preload([:payment_schemes])
        conn
        |> put_status(200)
        |> json(%{id: parking.id, location: parking.location, payment_schemes: Enum.map(zone.payment_schemes, fn scheme -> %{type: scheme.type, amount: scheme.amount, limit: scheme.limit} end)})
      else
        conn
        |> put_status(404)
        |> json(%{msg: "Could not detect your parking area"})
      end
      
    end

    # def get_map_data(spaces) do
    #   cond  do
    #     length(spaces) > 0  -> GeoLocator.map_data(spaces)
    #     true -> [] 
    #   end
    # end

    def prepare(spaces, leaving_time) do
      if leaving_time && String.length(leaving_time)>0 do
        spaces |> Enum.map(fn space -> 
          %{id: space.id, distance: Float.ceil(space.distance), location: space.location, 
          available_slots: space.available_lots,  zone_id: space.zone.id, zone_name: space.zone.name, 
          fee: FeesService.get_fee(space,leaving_time), prices: FeesService.get_price(space),
          coordinates: Enum.map(space.multi_point.coordinates, fn {x,y} -> %{lng: x, lat: y}  end)} 
        end)        
      else
        spaces |> Enum.map(fn space -> 
          %{id: space.id, distance: Float.ceil(space.distance), location: space.location, prices: FeesService.get_price(space),
          available_slots: space.available_lots,  zone_id: space.zone.id, zone_name: space.zone.name,
          coordinates: Enum.map(space.multi_point.coordinates, fn {x,y} -> %{lng: x, lat: y}  end)} 
        end)
        
      end
    end
  end

  