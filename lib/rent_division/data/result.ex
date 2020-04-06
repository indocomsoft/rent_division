defmodule RentDivision.Data.Result do
  @moduledoc """
  Represents one row in the rent division algorithm result.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias RentDivision.Data.Apartment
  alias RentDivision.Data.Renter
  alias RentDivision.Data.Room

  schema "results" do
    field :rent, :integer
    belongs_to :apartment, Apartment
    belongs_to :renter, Renter
    belongs_to :room, Room

    timestamps()
  end

  @required_fields [:rent, :apartment_id, :renter_id, :room_id]

  def changeset(%__MODULE__{} = result, params \\ %{}) do
    result
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:rent, greater_than: 0)
    |> foreign_key_constraint(:apartment_id)
    |> foreign_key_constraint(:room_id)
    |> foreign_key_constraint(:renter_id)
    |> unique_constraint(:apartment_id, name: :results_apartment_id_renter_id_index)
  end
end
