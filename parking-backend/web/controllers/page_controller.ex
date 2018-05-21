defmodule FindmeaparkingspaceBackend.PageController do
  use FindmeaparkingspaceBackend.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
