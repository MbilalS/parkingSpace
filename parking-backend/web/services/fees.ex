defmodule FindmeaparkingspaceBackend.FeesService do
    alias FindmeaparkingspaceBackend.{Repo, PaymentScheme}
    import Ecto.Query, only: [from: 2]
    use Timex

    def get_fee(space, leaving_time) do 
        payment_schemes = Repo.all(from p in PaymentScheme, where: p.zone_id == ^space.zone.id, select: p)
        case space.zone.name do
            name when name in ["A", "B"] ->
                hourly = List.first(Enum.filter(payment_schemes, fn scheme -> scheme.type=="HOURLY" end))
                real_time = List.first(Enum.filter(payment_schemes, fn scheme -> scheme.type=="REAL_TIME" end))
                leaving_time = Timex.parse!(leaving_time, "%Y-%m-%d %H:%M:%S", :strftime)
                current_time = Timex.local() |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime) |> Timex.parse!("%Y-%m-%d %H:%M:%S", :strftime)
                diff_mins =  Timex.diff(leaving_time, current_time, :minutes)
                perhour = hourly.amount * Float.ceil(diff_mins/60)
                perrealtime = real_time.amount * Float.ceil(diff_mins/5)
                %{hourly_id: hourly.id, hourly_amount: perhour, realtime_id: real_time.id, realtime_amount: perrealtime}
                    
            "C" ->
                hourly = List.first(Enum.filter(payment_schemes, fn scheme -> scheme.limit==60 end))
                two_hour = List.first(Enum.filter(payment_schemes, fn scheme -> scheme.limit==120 end))
                %{option_1_id: hourly.id, option_1_limit: hourly.limit, option_2_id: two_hour.id, option_2_limit: two_hour.limit}
            _  ->
                %{free: true, unlimited: true}
        end
    end

    def getAmount(allocation) do
        end_time = Timex.parse!(allocation.end_time, "%Y-%m-%d %H:%M:%S", :strftime)
        start_time = Timex.parse!(allocation.start_time, "%Y-%m-%d %H:%M:%S", :strftime)
        calculate_amount(start_time,end_time,allocation)
      end

      def getEstimateAmount(allocation) do
        current_time = Timex.local() |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime) |> Timex.parse!("%Y-%m-%d %H:%M:%S", :strftime)       
        start_time = Timex.parse!(allocation.start_time, "%Y-%m-%d %H:%M:%S", :strftime)
        calculate_amount(start_time,current_time, allocation)
      end

      def getTotalAmount(invoice_details) do
        Enum.reduce(invoice_details,0, fn (detail,acc) ->
            acc+getAmount(detail.allocation)
          end)
      end

      def getElapsedTime(allocation) do
        current_time = Timex.local() |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime) |> Timex.parse!("%Y-%m-%d %H:%M:%S", :strftime)       
        end_time = Timex.parse!(allocation.end_time, "%Y-%m-%d %H:%M:%S", :strftime)
        start_time = Timex.parse!(allocation.start_time, "%Y-%m-%d %H:%M:%S", :strftime)

        elapsed_time = Timex.diff(current_time, start_time, :minutes)
        time_left = cond do
                        allocation.payment_scheme == "HOURLY" -> Float.ceil((Timex.diff(end_time, current_time, :seconds)/60))
                        true  -> 0
                    end
        {elapsed_time, time_left}
      end

      defp calculate_amount(start_time, end_time, allocation) do 
        diff_mins =  Timex.diff(end_time, start_time, :minutes)
        scheme = get_scheme(allocation)
        fee = if allocation.payment_scheme == "HOURLY" do
                scheme.amount * Float.ceil(diff_mins/60)
              else
                scheme.amount * Float.ceil(diff_mins/5)
              end

        if fee > 0 do
            fee 
        else
            scheme.amount
        end
      end

      def get_scheme(allocation) do
        query = from p in PaymentScheme, where: p.zone_id == ^allocation.parking.zone.id and p.type == ^allocation.payment_scheme, select: p
        Repo.all(query) |> List.first()
      end

      def get_price(space) do
        payment_schemes = Repo.all(from p in PaymentScheme, where: p.zone_id == ^space.zone.id, select: p)
        case space.zone.name do
            name when name in ["A", "B"] ->
                hourly = List.first(Enum.filter(payment_schemes, fn scheme -> scheme.type=="HOURLY" end))
                real_time = List.first(Enum.filter(payment_schemes, fn scheme -> scheme.type=="REAL_TIME" end))
                %{hourly: hourly.amount, realtime: real_time.amount}
            _  ->
                scheme = List.first(payment_schemes)
                %{free: true, limit: scheme.limit}
        end
      end
end