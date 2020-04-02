defmodule RentDivisionWeb.Router do
  use RentDivisionWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RentDivisionWeb do
    pipe_through :api

    resources "/apartments", ApartmentController, only: [:show, :create] do
      post "/renters", RenterController, :create
      post "/rooms", RoomController, :create
    end

    get "/renters/:renter_id", RenterController, :show
    post "/renters/:renter_id/valuations", ValuationController, :create
  end
end
