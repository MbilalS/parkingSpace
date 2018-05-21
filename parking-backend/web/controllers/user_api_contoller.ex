defmodule FindmeaparkingspaceBackend.UserAPIController do
  use FindmeaparkingspaceBackend.Web, :controller

  alias FindmeaparkingspaceBackend.{User}

  def index(conn, _params) do
    users = Repo.all(User) 
            |> Enum.map(fn user -> %{id: user.id, email: user.email, name: user.name, role: user.role, invoiced: user.invoiced, payment_scheme: user.payment_scheme } end)
    conn
    |> put_status(200)
    |> json(users)
  end

  def create(conn, user_params) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
          {:ok, _user} ->
            conn
            |> put_status(201)
            |> json(%{msg: "User successfully created"})
          {:error, _changeset} ->
            conn
            |> put_status(406)
            |> json(%{msg: "Something went wrong"})
    end
  end

  def update(conn, user_params) do
    user = Repo.get!(User, user_params["id"])
    changeset = User.update_changeset(user, user_params)
    update_user(conn,changeset, "User successfully updated")
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    conn
    |> put_status(200)
    |> json(%{id: user.id, email: user.email, name: user.name, role: user.role, invoiced: user.invoiced, payment_scheme: user.payment_scheme })
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id) 
    Repo.delete!(user)

    conn
    |> put_status(201)
    |> json(%{msg: "User successfully deleted"})
  end

  def current(conn, _params) do
    user = Guardian.Plug.current_resource(conn) 
    conn
    |> put_status(200)
    |> json(%{id: user.id, email: user.email, name: user.name, role: user.role, invoiced: user.invoiced, payment_scheme: user.payment_scheme})
  end

  def change_password(conn, user_params) do
    user = Repo.get!(User, user_params["id"])
    changeset = User.changeset(user, user_params)
    update_user(conn, changeset, "Password successfully changed")
  end

  defp update_user(conn,changeset, msg) do
    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_status(201)
        |> json(%{msg: msg})
      {:error, _changeset} ->
        conn
        |> put_status(406)
        |> json(%{msg: "Something went wrong"})
    end
  end


end
