defmodule FindmeaparkingspaceBackend.InvoiceAPIController do
	use FindmeaparkingspaceBackend.Web, :controller
	use Timex

    import Ecto.Query, only: [from: 2]
    alias FindmeaparkingspaceBackend.{Invoice, Allocation, User, FeesService, InvoiceDetail}
    alias Ecto.{Changeset}
  
    def index(conn, params) do
    	user = Guardian.Plug.current_resource(conn)
      
    	if params["start_time"] && String.length(params["start_time"]) > 0 || params["end_time"] && String.length(params["end_time"])> 0 do
			start_time =  Timex.parse!(params["start_time"], "%Y-%m-%d", :strftime)
			end_time =  Timex.parse!(params["end_time"], "%Y-%m-%d", :strftime) 
			query = from i in Invoice, where: i.user_id == ^user.id, where: i.inserted_at >= ^Timex.beginning_of_day(start_time), where: i.inserted_at <= ^Timex.end_of_day(end_time), select: i
        	invoices = Repo.all(query) |> Repo.preload([{:invoice_details, [{:allocation, [{:parking, [:zone]}]}]}])
			if length(invoices) > 0 do
			conn
			|> put_status(200)
			|> json(invoices |> Enum.map(fn invoice ->  prepare(invoice) end))
			else
			conn
			|> put_status(404)
			|> json(%{msg: "No invoices available yet"})
			end    
      	else
			conn
			|> put_status(400)
			|> json(%{msg: "Bad request"})
		end
    end

    def show(conn, %{"id" => id}) do
    	invoice = Repo.get!(Invoice, id) |> Repo.preload([{:invoice_details, [{:allocation, [{:parking, [:zone]}]}]}])
    	conn
      	|> put_status(200)
      	|> json(prepare(invoice))
    end

    def pay(conn, %{"id" => id}) do
    	invoice = Repo.get!(Invoice, id) |> Repo.preload([{:invoice_details, [{:allocation, [{:parking, [:zone]}]}]}])
    	changeset = Invoice.changeset(invoice) |> Changeset.put_change(:status, "paid")
    	case Repo.update(changeset) do
        	{:ok, _invoice} ->
          		conn
          		|> put_status(201)
          		|> json(%{msg: "Payment successfull"})
			{:error, _changeset} ->
				conn
				|> put_status(406)
				|> json(%{msg: "Something went wrong"})
      	end
    end

	def prepare(invoice) do
    	%{id: invoice.id, date: invoice.inserted_at |> Timezone.convert(Timex.Timezone.local) |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime), status: invoice.status, details: Enum.map(invoice.invoice_details, fn detail ->
        	%{location: detail.allocation.parking.location, payment_scheme: detail.allocation.payment_scheme, date: detail.inserted_at |> Timezone.convert(Timex.Timezone.local) |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime),
         	extension: detail.allocation.extension, start_time: detail.allocation.start_time, 
          	end_time:  detail.allocation.end_time, unit_price: FeesService.get_scheme(detail.allocation).amount, amount: FeesService.getAmount(detail.allocation)}
      	end), total: FeesService.getTotalAmount(invoice.invoice_details)}
    end
 
	def monthly_bill() do
		start_date = Timex.local |>Timex.shift(months: -1) |> Timex.beginning_of_month #
		end_date = Timex.local |> Timex.shift(months: -1) |> Timex.end_of_month #

		query = from(allocation in Allocation,
			join: user in User, on: allocation.user_id == user.id,
			where: user.invoiced == "MONTHLY",
			where: allocation.inserted_at >= ^start_date,
			where: allocation.inserted_at <= ^end_date,
			select: allocation
		)

		allocations = Repo.all(query) |> Repo.preload([:user, :parking]) |> Enum.group_by(fn allocation -> allocation.user_id end)

		
		Enum.map(allocations, 
			fn {id, details} -> 
				#create invoice
				invoice = Invoice.changeset(%Invoice{}, %{user_id: id}) |> Repo.insert!
				Enum.each(details,
					#add invoice details 
					fn detail -> 
						InvoiceDetail.changeset(%InvoiceDetail{}, %{invoice_id: invoice.id, allocation_id: detail.id}) 
						|> Repo.insert! 
						#notify user
						FindmeaparkingspaceBackend.Endpoint.broadcast("user:"<>detail.user.email, "notifications", %{msg: "Your invoice is ready, Please consult the invoice page"})						
					end
				)
			end
		)
	end
end
  