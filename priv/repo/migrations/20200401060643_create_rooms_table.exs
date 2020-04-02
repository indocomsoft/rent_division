defmodule RentDivision.Repo.Migrations.CreateRoomsTable do
  use Ecto.Migration

  def change do
    create table("rooms") do
      add :name, :string, null: false
      add :apartment_id, references("apartments", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("rooms", [:apartment_id])
    create unique_index("rooms", [:name, :apartment_id])
  end
end
