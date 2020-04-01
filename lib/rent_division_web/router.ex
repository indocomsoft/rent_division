defmodule RentDivisionWeb.Router do
  use RentDivisionWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RentDivisionWeb do
    pipe_through :api
  end
end
