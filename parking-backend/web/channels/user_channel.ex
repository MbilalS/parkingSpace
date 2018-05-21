defmodule FindmeaparkingspaceBackend.UserChannel do
  use FindmeaparkingspaceBackend.Web, :channel
  use Guardian.Channel

  def join("user:"<>owner, %{claims: _, resource: %{email: username}}, socket)
  when username == owner do
    {:ok, socket}
  end
  
  def join(_room, _, _socket) do
    {:error, :unauthorized}
  end
end