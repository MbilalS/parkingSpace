defmodule FindmeaparkingspaceBackend.Authentication do
  def check_credentials(_conn, user, password) do
    Comeonin.Pbkdf2.check_pass(user, password)
  end
end