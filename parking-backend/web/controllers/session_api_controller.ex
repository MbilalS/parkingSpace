defmodule FindmeaparkingspaceBackend.SessionAPIController do
    use FindmeaparkingspaceBackend.Web, :controller
    alias FindmeaparkingspaceBackend.{Repo, User, Authentication}
  
    def create(conn, %{"email" => email, "password" => password}) do
      user = Repo.get_by(User, email: email)    
      case Authentication.check_credentials(conn, user, password) do
      {:ok, _} ->
          {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)
          conn
          |> put_status(201)
          |> json(%{token: jwt, role: user.role})
      {:error, _} ->
          conn
          |> put_status(400)
          |> json(%{message: "Bad credentials"})
      end
    end
  
    def delete(conn, _params) do
      {:ok, claims} = Guardian.Plug.claims(conn)
      conn
      |> Guardian.Plug.current_token
      |> Guardian.revoke!(claims)
  
      conn
      |> put_status(200)
      |> json(%{msg: "Good bye"})
    end
  
    def unauthenticated(conn, _params) do
      conn
      |> put_status(403)
      |> json(%{msg: "You are not logged in"})
    end
  end