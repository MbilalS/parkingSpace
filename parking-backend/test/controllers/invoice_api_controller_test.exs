defmodule FindmeaparkingspaceBackend.InvoiceAPIControllerTest do
    use FindmeaparkingspaceBackend.ConnCase
    alias FindmeaparkingspaceBackend.{Repo, User}
    
    setup %{conn: conn} = config do
        cond do
          config[:WithCorrectInvoice] ->
            user = Repo.get_by!(User, email: "christina@greys.com")
            signed_conn = Guardian.Plug.api_sign_in(conn, user)
            {:ok, conn: signed_conn}
          true ->
            :ok
        end
      end

    setup %{conn: conn} = config do
        cond do
          config[:WithWrongInvoice] ->
            user = Repo.get_by!(User, email: "alex@greys.com")
            signed_conn = Guardian.Plug.api_sign_in(conn, user)
            {:ok, conn: signed_conn}
          true ->
            :ok
        end
      end

    
      @tag :WithCorrectInvoice
      test "invoices loaded", %{conn: conn} do
        startTime = "2017-12-01"
        endTime = "2017-12-31"
        conn = get conn, "/api/invoices?start_time=#{startTime}&end_time=#{endTime}"
        assert conn.status == 200
      end

      @tag :WithWrongInvoice
      test "No invoices available yet", %{conn: conn} do
        startTime = "2017-12-01"
        endTime = "2017-12-31"
        conn = get conn, "/api/invoices?start_time=#{startTime}&end_time=#{endTime}"
        %{"msg" => msg} = json_response(conn, 404)
        assert conn.status == 404
        assert msg == "No invoices available yet"
      end

      @tag :WithWrongInvoice
      test "Bad request", %{conn: conn} do
        startTime = "2017-12-01"
        endTime = "2017-12-31"
        conn = get conn, "/api/invoices?start_time=#{startTime}&end_time=#{endTime}"
        assert conn.status == 404
      end

      @tag :WithCorrectInvoice
      test "show invoice", %{conn: conn} do
        conn = get(conn, "/api/invoices/1")
        invoice = json_response(conn, 200)
        assert conn.status == 200
        assert Map.get(invoice, "id") == 1
      end

      @tag :WithCorrectInvoice
      test "pay invoice successfully", %{conn: conn} do
        conn = patch(conn, "/api/invoices/1/pay")
        %{"msg" => msg} = json_response(conn, 201)
        assert conn.status == 201
        assert msg == "Payment successfull"
      end

end