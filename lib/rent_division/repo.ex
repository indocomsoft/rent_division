defmodule RentDivision.Repo do
  use Ecto.Repo,
    otp_app: :rent_division,
    adapter: Ecto.Adapters.Postgres
end
