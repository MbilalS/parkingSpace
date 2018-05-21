defmodule FindmeaparkingspaceBackend.PaymentSchemeAPIController do
    use FindmeaparkingspaceBackend.Web, :controller
    alias FindmeaparkingspaceBackend.{PaymentScheme}

    def index(conn, _params) do
        schemes = Repo.all(PaymentScheme) 
                  |> Enum.map(fn scheme -> %{id: scheme.id, type: scheme.type, amount: scheme.amount, limit: scheme.limit} end)
       
        conn
        |> put_status(201)
        |> json(schemes) 
    end

    def show(conn, %{"id" => id}) do
        scheme = Repo.get(PaymentScheme,id)
        if scheme do
            conn
            |> put_status(201)
            |> json(%{id: scheme.id, type: scheme.type, amount: scheme.amount, limit: scheme.limit})
        else
            conn
            |> put_status(204)
            |> json(%{message: "Payment Scheme not found"})
        end
    end

end
