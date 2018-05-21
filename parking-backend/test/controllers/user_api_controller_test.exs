defmodule FindmeaparkingspaceBackend.UserAPIControllerTest do
    use FindmeaparkingspaceBackend.ConnCase
    alias FindmeaparkingspaceBackend.{Repo, User}
    
    setup %{conn: conn} = config do
        cond do
          config[:login] ->
            user = Repo.get_by!(User, email: "alex@greys.com")
            signed_conn = Guardian.Plug.api_sign_in(conn, user)
            {:ok, conn: signed_conn}
          true ->
            :ok
        end
      end
     
      @tag :login
      test "Get all users", %{conn: conn} do
        conn = get(conn, "/api/users")
        assert conn.status == 200
      end

      test "User successfully created", %{conn: conn} do
        conn = post(conn, "/api/users", %{name: "name", email: "name@email.com", password: "password", password_confirmation: "password"})
        %{"msg" => msg} = json_response(conn, 201)
        assert conn.status == 201
        assert msg == "User successfully created"
      end

      test "User creation with missing name", %{conn: conn} do
        conn = post(conn, "/api/users", %{email: "name@email.com", password: "password", password_confirmation: "password"})
        %{"msg" => msg} = json_response(conn, 406)
        assert conn.status == 406
        assert msg == "Something went wrong"
      end

      test "User creation with wrong email format", %{conn: conn} do
        conn = post(conn, "/api/users", %{name: "name",  email: "name", password: "password", password_confirmation: "password"})
        %{"msg" => msg} = json_response(conn, 406)
        assert conn.status == 406
        assert msg == "Something went wrong"
      end

      test "User creation with wrong password confirmation", %{conn: conn} do
        conn = post(conn, "/api/users", %{name: "name",  email: "name@email.com", password: "password", password_confirmation: "passwordd"})
        %{"msg" => msg} = json_response(conn, 406)
        assert conn.status == 406
        assert msg == "Something went wrong"
      end

      @tag :login
      test "get current user", %{conn: conn} do
        conn = get(conn, "/api/users/current")
        user = json_response(conn, 200)
        assert conn.status == 200
        assert Map.get(user, "id") == 2
        assert Map.get(user, "email") == "alex@greys.com"
      end

      @tag :login
      test "Update user details", %{conn: conn} do
        user = %{"email" => "alex@greys.com", "id" => 2, "invoiced" => "IMMEDIATELY",
        "name" => "Alex Karev", "payment_scheme" => "HOURLY", "role" => "customer"}
        assert Map.get(user, "invoiced") == "IMMEDIATELY"
        user = %{user | "invoiced" => "MONTHLY"}
        conn = patch(conn, "/api/users/2", user)
        %{"msg" => msg} = json_response(conn, 201)
        assert conn.status == 201
        assert msg == "User successfully updated"
      end

      @tag :login
      test "Get user by id", %{conn: conn} do
        conn = get(conn, "/api/users/2")
        user = json_response(conn, 200)
        assert conn.status == 200
        assert Map.get(user, "name") == "Alex Karev"
        assert Map.get(user, "email") == "alex@greys.com"
      end

      @tag :login
      test "Successful user password change", %{conn: conn} do
        conn = patch(conn, "/api/users/2/change-password", %{password: "password", password_confirmation: "password"})
        %{"msg" => msg} = json_response(conn, 201)
        assert conn.status == 201
        assert msg == "Password successfully changed"
      end

      @tag :login
      test "Unsuccessful user password change, (different password confirmation)", %{conn: conn} do
        conn = patch(conn, "/api/users/2/change-password", %{password: "password", password_confirmation: "passwords"})
        %{"msg" => msg} = json_response(conn, 406)
        assert conn.status == 406
        assert msg == "Something went wrong"
      end
  
  end