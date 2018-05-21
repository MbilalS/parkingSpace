defmodule FindmeaparkingspaceBackend.ZoneAPIController do
    use FindmeaparkingspaceBackend.Web, :controller
    alias FindmeaparkingspaceBackend.{Zone,PaymentScheme}

    def index(conn, _params) do
        zones = Repo.all(Zone) |> Enum.map(fn zone -> %{id: zone.id, name: zone.name} end)
       
        conn
        |> put_status(201)
        |> json(zones) 
    end

    def payment_schemes(conn, %{"id" => id}) do
        
        query = from p in PaymentScheme, where: p.zone_id == ^id, select: p
        payments = Repo.all(query) |> Enum.map(fn scheme -> %{id: scheme.id, type: scheme.type, amount: scheme.amount, limit: scheme.limit} end)
        if payments && length(payments)>0 do
            conn
            |> put_status(201)
            |> json(payments)
        else
            conn
            |> put_status(204)
            |> json(%{message: "Zone not found"})
        end
        

    end

    def show(conn, %{"id" => id}) do

        zone = Repo.get(Zone,id)
        if zone do
            conn
            |> put_status(201)
            |> json(%{id: zone.id, name: zone.name})
        else
            conn
            |> put_status(204)
            |> json(%{message: "Zone not found"})
        end
    end

end
