defmodule FindmeaparkingspaceBackend.GuardianSerializer do
    @behaviour Guardian.Serializer
    
    def for_token(%FindmeaparkingspaceBackend.User{} = user), do: {:ok, "User:#{user.id}"}
    def for_token(_), do: {:error, "Unknown Resource"}

    def from_token("User:"<>user_id), do: {:ok, FindmeaparkingspaceBackend.Repo.get(FindmeaparkingspaceBackend.User, user_id)}
    def from_token(_), do: {:error, "Unknown Resource"}
  end