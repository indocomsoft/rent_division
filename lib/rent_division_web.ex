defmodule RentDivisionWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use RentDivisionWeb, :controller
      use RentDivisionWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: RentDivisionWeb

      import Plug.Conn
      alias RentDivisionWeb.Router.Helpers, as: Routes

      defp error_code_for(%{valid?: false, errors: errors} = changeset) do
        all_opts = Enum.map(errors, fn {_k, {_msg, opts}} -> opts end)

        cond do
          Enum.any?(all_opts, &(Keyword.get(&1, :validation) == :required)) -> :bad_request
          Enum.any?(all_opts, &(Keyword.get(&1, :constraint) == :unique)) -> :conflict
          Enum.any?(all_opts, &(Keyword.get(&1, :constraint) == :foreign)) -> :not_found
          true -> :bad_request
        end
      end

      defp render_error_changeset(conn, changeset) do
        error_code = error_code_for(changeset)

        conn
        |> put_status(error_code)
        |> put_view(RentDivisionWeb.ErrorView)
        |> render("changeset.json", changeset: changeset)
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/rent_division_web/templates",
        namespace: RentDivisionWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      import RentDivisionWeb.ErrorHelpers
      alias RentDivisionWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
