defmodule FindmeaparkingspaceBackend.PageControllerTest do
  use FindmeaparkingspaceBackend.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to FindMeAParkingSpace!"
  end
end
