defmodule FindmeaparkingspaceBackend.Router do
  use FindmeaparkingspaceBackend.Web, :router
  
  def guardian_current_user(conn, _) do
    Plug.Conn.assign(conn, :current_user, Guardian.Plug.current_resource(conn))
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do  
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  scope "/", FindmeaparkingspaceBackend do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/parkings", ParkingController 
    
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :auth_api do
    plug Guardian.Plug.EnsureAuthenticated, handler: FindmeaparkingspaceBackend.SessionAPIController   
  end
  
  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated, handler: FindmeaparkingspaceBackend.SessionController    
    plug :guardian_current_user
  end

  #Other scopes may use custom stacks.
  scope "/api", FindmeaparkingspaceBackend do
    pipe_through :api
    post "/users", UserAPIController, :create
    post "/sessions", SessionAPIController, :create
    get "/parkings", ParkingAPIController, :index
    get "/payment-schemes", PaymentSchemeAPIController, :index
    get "/payment-schemes/:id", PaymentSchemeAPIController, :show
    get "/zones/:id/payment-schemes", ZoneAPIController, :payment_schemes
    get "/zones", ZoneAPIController, :index
    get "/zones/:id", ZoneAPIController, :show
  end

  scope "/api", FindmeaparkingspaceBackend do
    pipe_through [:api, :auth_api]
    delete "/sessions/:id", SessionAPIController, :delete
    get "/users/current", UserAPIController, :current
    patch "/users/:id/change-password", UserAPIController, :change_password
    resources "/users", UserAPIController, [:update, :show, :delete]
    post "/parkings", ParkingAPIController, :create
    patch "/parkings/:id", ParkingAPIController, :update
    patch "/parkings/:id/extend", ParkingAPIController, :extend
    patch "/parkings/:id/end", ParkingAPIController, :ending    
    get "/parkings/status", ParkingAPIController, :status
    get "/parkings/current", ParkingAPIController, :current
    patch "/invoices/:id/pay", InvoiceAPIController, :pay
    get "/invoices", InvoiceAPIController, :index
    get "/invoices/:id", InvoiceAPIController, :show
  end

end
