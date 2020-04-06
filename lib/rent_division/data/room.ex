defmodule RentDivision.Data.Room do
  @moduledoc """
  Represents a room in an apartment
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias RentDivision.Data.Apartment

  schema "rooms" do
    field :name, :string
    belongs_to :apartment, Apartment

    timestamps()
  end

  @required_fields [:name, :apartment_id]

  def changeset(%__MODULE__{} = room, params \\ %{}) do
    room
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:apartment_id)
    |> unique_constraint(:name, name: :rooms_name_apartment_id_index, message: "must be unique")
  end
end
