defmodule RentDivision.Repo.Migrations.CreateResultsTable do
  use Ecto.Migration

  def change do
    create table("results") do
      add :apartment_id, references("apartments", on_delete: :delete_all), null: false
      add :renter_id, references("renters", on_delete: :delete_all), null: false
      add :room_id, references("rooms", on_delete: :delete_all), null: false
      add :rent, :integer, null: false

      timestamps()
    end

    create index("results", [:apartment_id])
    create unique_index("results", [:apartment_id, :renter_id])
  end
end
