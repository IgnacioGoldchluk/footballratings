defmodule FootballratingsWeb.UsersSetUsernameLive do
  use FootballratingsWeb, :live_view

  alias Footballratings.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <%= if @current_users.username != nil do %>
      <div class="flex justify-center">You already set your username</div>
    <% else %>
      <.header class="text-center">
        Set username
        <:subtitle>Set a unique username to continue</:subtitle>
      </.header>

      <div class="mx-auto items-center">
        <div class="flex justify-center">
          <div class="flex flex-col gap-2">
            <.simple_form
              for={@username_form}
              id="username-form"
              phx-submit="update_username"
              phx-change="validate_username"
            >
              <.input
                field={@username_form[:username]}
                type="text"
                label="Username"
                class="rounded-lg max-w-xs"
                required
              />
              <:actions>
                <%= if @username_valid? do %>
                  <.button
                    disabled={not @username_valid?}
                    phx-disable-with="Changing..."
                    class="btn-primary disabled:bg-zinc-200 w-28"
                    id="set-username-button"
                  >
                    Set username
                  </.button>
                <% end %>
              </:actions>
            </.simple_form>

            <%= if not @username_valid? do %>
              <.button
                disabled={not @can_validate?}
                phx-disabled-with="Checking..."
                phx-click="check-username-available"
                class="btn-primary disabled:bg-zinc-200 w-28"
                id="validate-username-available"
              >
                Check for availability
              </.button>
            <% end %>
            <div>
              <%= @valid_message %>
            </div>
          </div>
        </div>
      </div>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    users = socket.assigns.current_users
    username_changeset = Accounts.change_users_username(users)

    socket =
      socket
      |> assign_form(username_changeset)
      |> assign_can_validate(false)
      |> assign_username_valid?(false)
      |> assign_valid_message("")

    {:ok, socket}
  end

  defp assign_can_validate(socket, can_validate) do
    assign(socket, :can_validate?, can_validate)
  end

  defp assign_username_valid?(socket, username_valid?) do
    assign(socket, :username_valid?, username_valid?)
  end

  defp assign_valid_message(socket, message) do
    assign(socket, :valid_message, message)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "set-username")

    socket =
      if changeset.valid? do
        assign(socket, username_form: form, check_errors: false)
      else
        assign(socket, username_form: form)
      end

    socket
    |> assign_can_validate(changeset.valid?)
  end

  @impl true
  def handle_event("validate_username", %{"set-username" => changes}, socket) do
    changeset = Accounts.change_users_username(socket.assigns.current_users, changes)

    socket =
      socket
      |> assign_form(Map.put(changeset, :action, :validate))
      |> assign_username_valid?(false)
      |> assign_valid_message("")

    {:noreply, socket}
  end

  @impl true
  def handle_event("check-username-available", _params, socket) do
    %{"username" => proposed_username} = socket.assigns.username_form.params

    user = Accounts.get_users_by_username(proposed_username)

    case user do
      nil ->
        {:noreply,
         socket
         |> assign_can_validate(false)
         |> assign_username_valid?(true)
         |> assign_valid_message("Username is available!")}

      _ ->
        {:noreply,
         socket
         |> assign_can_validate(false)
         |> assign_username_valid?(false)
         |> assign_valid_message("Username already taken :(")}
    end
  end

  @impl true
  def handle_event("update_username", %{"set-username" => %{"username" => username}}, socket) do
    users = socket.assigns.current_users

    case Accounts.update_users_username(users, username) do
      {:ok, _} ->
        {:noreply,
         socket |> put_flash(:info, "Username updated successfully!") |> redirect(to: ~p"/")}

      {:error, _, _, _} ->
        {:noreply,
         socket |> put_flash(:error, "An error ocurred while setting your username. Try again.")}
    end
  end
end
