defmodule FindmeaparkingspaceBackend.ParkingApiControllerTest do
  use FindmeaparkingspaceBackend.ConnCase
  alias FindmeaparkingspaceBackend.{Repo, Parking, User}
  setup %{conn: conn} = config do
    cond do
      config[:login] ->
        user = Repo.get_by!(User, email: "christina@greys.com")
        signed_conn = Guardian.Plug.api_sign_in(conn, user)
        {:ok, conn: signed_conn}
      true ->
        :ok
    end
  end

   test "GET /api/parkings (Parking not available near a specific destination)", %{conn: conn} do
    destination = ""
    conn = get conn, "/api/parkings?destination=#{destination}"
    assert conn.status == 404
    assert json_response(conn, 404) == %{"msg" => "Our apologies, there is no available parking near your destination"}
   end

  test "GET /api/parkings (available parking near a specific destination)", %{conn: conn} do
      destination = "Ulikooli 18"
      conn = get conn, "/api/parkings?destination=#{destination}"
      %{"spaces" => spaces} = json_response(conn, 200)
      assert conn.status == 200
      assert length(spaces) == 3
  end

  test "GET /api/parkings (Avalable parking with fee estimations)", %{conn: conn} do
    leaving_time = Timex.shift(Timex.local(), hours: 2)  |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime)
    destination = "Ulikooli 18"
    conn = get conn, "/api/parkings?destination=#{destination}&leaving_time=#{leaving_time}"
    %{"spaces"=>spaces} = json_response(conn, 200)
    assert conn.status == 200
    assert length(spaces) == 3
    assert Map.has_key?(List.first(spaces), "fee") == true
  end

  @tag :login
  test "GET /api/parkings/current (Detect a zone A or B parking)", %{conn: conn} do
    longitude = 26.71096622943878
    latitude = 58.376139954301934
    conn = get conn, "/api/parkings/current?longitude=#{longitude}&latitude=#{latitude}"
    parking =  json_response(conn, 200)
    assert conn.status == 200
    assert parking["location"]  == "Kastani"
  end

  @tag :login
  test "GET /api/parkings/current (Detect a zone C or D parking)", %{conn: conn} do
    longitude = 26.730154752731323
    latitude = 58.381877422207005
    conn = get conn, "/api/parkings/current?longitude=#{longitude}&latitude=#{latitude}"
    parking =  json_response(conn, 200)
    assert conn.status == 200
    assert parking["location"] == "Raatuse 20"
  end
end