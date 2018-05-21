defmodule FindmeaparkingspaceBackend.ParkingAllocator do
    use GenServer
    alias FindmeaparkingspaceBackend.{Parking, Repo, Allocation, Invoice, InvoiceDetail, FeesService}
    alias Ecto.{Changeset,Multi}
    
    def start_link(request, reference) do
        GenServer.start_link(FindmeaparkingspaceBackend.ParkingAllocator, request, name: reference)
    end
        
    def init(request) do
        {:ok, {request, %{}}}
    end

    def allocate_parking(reference) do
        GenServer.cast(reference, :allocate_parking)
    end
    
    def end_parking(reference, username) do
        GenServer.cast(reference, {:end_parking, username})
    end
    
    def accept_allocation(reference, username) do
        GenServer.cast(reference, {:accept_allocation, username})
    end

    def reject_allocation(reference, username) do
        GenServer.cast(reference, {:reject_allocation, username})
    end

    def extend_parking(reference, username) do
        GenServer.cast(reference, {:extend_parking, username})
    end

    def end_parking(reference) do
        GenServer.cast(reference, :end_parking)
    end

    def handle_cast(:allocate_parking, {request, timers}) do
        allocation = Repo.get!(Allocation, request.id) |> Repo.preload([{:parking,[:zone]}])
        msg = %{id: allocation.id,zone_name: allocation.parking.zone.name,  location: allocation.parking.location, start_time: allocation.start_time, end_time: allocation.end_time, amount: FeesService.getAmount(allocation), payment_scheme: allocation.payment_scheme }
        
        FindmeaparkingspaceBackend.Endpoint.broadcast("user:"<> request.user.email, "requests", msg)
        timer = Process.send_after(self(), {:ignore, request.user.email}, 15000)
        {:noreply, {request, timers |> Map.put(request.user.email, timer)}}
    end

    def handle_cast({:accept_allocation, username}, {request, timers}) do
        if (Map.has_key?(timers, username)) do
            timer = timers[username]
            Process.cancel_timer(timer)
            #compute duration to set timer

            leaving_time = Timex.parse!(request.end_time, "%Y-%m-%d %H:%M:%S", :strftime)
            start_time = Timex.parse!(request.start_time, "%Y-%m-%d %H:%M:%S", :strftime)
            diff_mins =  Timex.diff(leaving_time, start_time, :minutes) |> round

            #update allocation status
            allocation = Repo.get!(Allocation, request.id) |> Repo.preload([:user, :parking])
            Multi.new
            |> Multi.update(:allocation, Allocation.changeset(allocation) |> Changeset.put_change(:status, "OPEN"))
            |> Multi.update(:parking, Parking.changeset(allocation.parking) |> Changeset.put_change(:available_lots, allocation.parking.available_lots - 1))
            |> Repo.transaction
            #update allocation status
            payload =  if allocation.payment_scheme == "HOURLY" do
                            invoice = create_invoice(allocation)
                            %{msg: "Parking Started", invoice_id: invoice.id}
                       else
                            %{msg: "Parking Started"}
                       end

           FindmeaparkingspaceBackend.Endpoint.broadcast("user:"<>request.user.email, "notifications", payload)
           request = Repo.get!(Allocation, request.id) |> Repo.preload([:user, :parking])
           timers = 
           if allocation.payment_scheme == "HOURLY" do
               case diff_mins >= 10.0 do
                    true -> 
                        timer = Process.send_after(self(), {:notify_user, allocation.parking.location}, (diff_mins - 10) * 60 * 1000)  
                        timers |> Map.delete(username) |> Map.put(allocation.parking.location, timer) 
                    false -> 
                        timer_1 = Process.send_after(self(), {:notify_user, allocation.parking.location}, diff_mins * 60 * 1000) 
                        timer_2 = Process.send_after(self(), :update_parking, (diff_mins-2) * 60 * 1000)
                        timers = timers |> Map.put(allocation.parking.location, timer_1)  |> Map.put(request.user.email, timer_2) 
               end
           end 
          {:noreply, {request, timers}}
        end
    end

    def handle_cast({:extend_parking, username}, {request, timers}) do
        
        IO.inspect "extending parking >>>>>>>>>>>>>>>>>>>>>"
        allocation = Repo.get!(Allocation, request.id)  |> Repo.preload([:user, :parking])
        
        {_, time_left} = FeesService.getElapsedTime(allocation)
        
        IO.inspect "#{time_left}  Left"
        if Map.has_key?(timers, allocation.parking.location) do
            timer = timers[allocation.parking.location]
            Process.cancel_timer(timer)
        end
        if Map.has_key?(timers, username) do
            timer = timers[username]
            Process.cancel_timer(timer)
        end
        
        new_allocation =
        Allocation.changeset(%Allocation{}, 
            %{longitude: allocation.longitude, 
            latitude: allocation.latitude,
            status: "PENDING",
            extension: true,
            start_time: allocation.end_time ,
            end_time: Timex.parse!(allocation.end_time, "%Y-%m-%d %H:%M:%S", :strftime) 
                    |> Timex.shift(hours: 1) 
                    |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime),
            payment_scheme: allocation.payment_scheme,
            user_id: allocation.user.id,
            parking_id: allocation.parking.id}) 
        |> Repo.insert! |> Repo.preload([:user, :parking])

        request = request |> Map.put(:new_id, new_allocation.id)

        #update allocation status
        new_invoice = create_invoice(new_allocation)
        
        payload = %{msg: "Parking extension scheduled", invoice_id: new_invoice.id}
        
        FindmeaparkingspaceBackend.Endpoint.broadcast("user:"<>request.user.email, "extension", payload)  
        Process.send_after(self(), {:extend_allocation, request.parking.location},  round(time_left) * 60 * 1000)  


        {:noreply, {request, timers}}
    end

    def handle_cast(:scheduled_end_parking, {request, timers}) do
        #update allocation status
        allocation = Repo.get!(Allocation, request.id) |> Repo.preload([:user, :parking])
        Repo.update(Allocation.changeset(allocation) |> Changeset.put_change(:status, "CLOSED"))

        request = Repo.get!(Allocation, request.id) |> Repo.preload([:user, :parking])
        FindmeaparkingspaceBackend.Endpoint.broadcast("user:"<>request.user.email, "notifications", %{msg: "Parking Ended"})
        {:noreply, {request, timers}}
    end

    def handle_cast({:end_parking, _username}, {request, timers}) do
        current_time = Timex.local() |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime)
        #update allocation status
        allocation = Repo.get!(Allocation, request.id) |> Repo.preload([:user, :parking])
        Multi.new
        |> Multi.update(:allocation, Allocation.changeset(allocation) |> Changeset.put_change(:status, "CLOSED") |> Changeset.put_change(:end_time, current_time))
        |> Multi.update(:parking, Parking.changeset(allocation.parking) |> Changeset.put_change(:available_lots, allocation.parking.available_lots + 1))
        |> Repo.transaction

        #update allocation status
        payload =  if allocation.user.invoiced == "IMMEDIATELY" && allocation.payment_scheme == "REAL_TIME" do #invoice = 
                        invoice = create_invoice(allocation)
                        %{msg: "Parking Ended", invoice_id: invoice.id}
                   else
                        %{msg: "Parking Ended"}
                   end
        
        request = Repo.get!(Allocation, request.id) |> Repo.preload([:user, :parking])
        
        FindmeaparkingspaceBackend.Endpoint.broadcast("user:"<>request.user.email, "notifications", payload)
        
        {:noreply, {request, timers}}
    end

    def handle_cast({:reject_allocation, username}, {request, timers}) do
        if (Map.has_key?(timers, username)) do
            timer = timers[username]
            Process.cancel_timer(timer)
            FindmeaparkingspaceBackend.Endpoint.broadcast("user:"<>request.user.email, "notifications", %{msg: "Parking request discarded"})
            
            allocation = Repo.get!(Allocation, request.id)
            Repo.update(Allocation.changeset(allocation) |> Changeset.put_change(:status, "REJECTED"))

            FindmeaparkingspaceBackend.Endpoint.broadcast("user:"<>request.user.email, "notifications", %{msg: "Parking request discarded"})
            
            request = Repo.get!(Allocation, request.id) |> Repo.preload([:user, :parking])
            {:noreply, {request, timers}}
        end
    end

    def handle_info({:extend_allocation, parking_location}, {request, timers}) do
        IO.inspect "Extend >>>>>>>>>>>>>>>>>>>>>>>>"
        allocation = Repo.get!(Allocation, request.id)  |> Repo.preload([:user, :parking])
        Repo.update(Allocation.changeset(allocation) |> Changeset.put_change(:status, "CLOSED"))

        new_allocation = Repo.get!(Allocation, request.new_id)  |> Repo.preload([:user, :parking])
        Repo.update(Allocation.changeset(new_allocation) |> Changeset.put_change(:status, "OPEN"))        
        
        request = Repo.get!(Allocation, new_allocation.id) |> Repo.preload([:user, :parking])
                
        timer = Process.send_after(self(), {:notify_user, parking_location}, 50 * 60 * 1000)        
        {:noreply, {request, timers |> Map.put(request.parking.location, timer)}}
    end

    def handle_info({:notify_user, parking_location}, {request, timers}) do
        timers = timers |> Map.delete(parking_location)
        if Map.has_key?(request, :end) do
            # end allocation
            handle_cast(:scheduled_end_parking, {request |> Map.delete(:end), timers})
        else 
            IO.inspect "notifing user >>>>>>>>>>>>>>>"
            FindmeaparkingspaceBackend.Endpoint.broadcast("user:"<>request.user.email, "notifications", %{msg: "Parking finishing in 10 min"})
            timer = Process.send_after(self(), {:notify_user, parking_location}, 10 * 60 * 1000) 
            timers = timers |> Map.put(parking_location, timer) 
            timer = Process.send_after(self(), :update_parking, 8 * 60 * 1000)
            timers = timers |> Map.put(request.user.email, timer) 
            {:noreply, {request, timers}}
        end   
    end

    def handle_info(:update_parking, {request, timers}) do
        #Set allocated parking available
        allocation = Repo.get!(Allocation, request.id)  |> Repo.preload([:user, :parking])
        # parking = Repo.get!(Parking, allocation.parking_id)
        
        Repo.update(Parking.changeset(allocation.parking) |> Changeset.put_change(:available_lots, allocation.parking.available_lots + 1)) 
        request = Repo.get!(Allocation, request.id) |> Repo.preload([:user, :parking]) |> Map.put(:end, true) 
        {:noreply, {request, timers}}
    end

    def handle_info({:ignore, username}, {request, timers}) do
        handle_cast({:reject_allocation, username}, {request, timers})
    end

    def create_invoice(allocation) do
        #create invoice
        invoice_changeset = Invoice.changeset(%Invoice{}, %{user_id: allocation.user.id})
        saved_invoice = Repo.insert!(invoice_changeset)

        #add invoice details
        invoice_detail_changeset = InvoiceDetail.changeset(%InvoiceDetail{}, %{invoice_id: saved_invoice.id, allocation_id: allocation.id})
        Repo.insert!(invoice_detail_changeset)
        saved_invoice
    end
end