defmodule RentDivisionWeb.ErrorView do
  use RentDivisionWeb, :view

  alias Ecto.Changeset

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  def render("changeset.json", %{changeset: changeset = %Changeset{}}) do
    error_detail =
      changeset
      |> Changeset.traverse_errors(fn {msg, _} -> msg end)
      |> Enum.map(fn {k, v} -> "#{k} #{v}" end)
      |> Enum.join(", ")

    %{errors: %{detail: error_detail}}
  end

  def render("bad_sum.json", %{}) do
    %{errors: %{detail: "Does not sum up to total rent"}}
  end

  def render("already_done.json", %{}) do
    %{errors: %{detail: "This action can only be performed once"}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
