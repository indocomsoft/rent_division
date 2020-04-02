defmodule RentDivision.Repo.Migrations.CreateValuationsTable do
  use Ecto.Migration

  def change do
    create table("valuations") do
      add :apartment_id, references("apartments", on_delete: :delete_all), null: false
      add :renter_id, references("renters", on_delete: :delete_all), null: false
      add :room_id, references("rooms", on_delete: :delete_all), null: false
      add :value, :integer, null: false

      timestamps()
    end

    create index("valuations", [:apartment_id])
    create unique_index("valuations", [:apartment_id, :renter_id, :room_id])
  end
end
