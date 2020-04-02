# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RentDivision.Repo.insert!(%RentDivision.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
import RentDivision.Data

IO.puts("Creating apartment")
{:ok, apartment} = create_apartment(%{"name" => "asd", "rent" => 2400})

IO.puts("Creating rooms")

{:ok, [%{id: master}, %{id: common1}, %{id: common2}]} =
  create_rooms(apartment, ["master", "common1", "common2"])

IO.puts("Creating renters")
{:ok, [alice, charlie, bob]} = create_renters(apartment, ["alice", "bob", "charlie"])

IO.puts("Creating valuation for Alice")
{:ok, _} = create_valuations(alice, %{master => 800, common1 => 800, common2 => 800})
IO.puts("Creating valuation for Bob")
{:ok, _} = create_valuations(bob, %{master => 900, common1 => 750, common2 => 750})
IO.puts("Creating valuation for Charlie")
{:ok, _} = create_valuations(charlie, %{master => 850, common1 => 775, common2 => 775})
