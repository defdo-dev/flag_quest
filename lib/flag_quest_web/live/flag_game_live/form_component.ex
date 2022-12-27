defmodule FlagQuestWeb.FlagGameLive.FormComponent do
  use FlagQuestWeb, :live_component

  alias FlagQuest.Flags

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage flag records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="flag-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :image}} type="text" label="image" />
        <.input field={{f, :name}} type="text" label="name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Flag</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{flag: flag} = assigns, socket) do
    changeset = Flags.change_flag(flag)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"flag" => game_params}, socket) do
    changeset =
      socket.assigns.flag
      |> Flags.change_flag(game_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"flag" => game_params}, socket) do
    save_game(socket, socket.assigns.action, game_params)
  end

  defp save_game(socket, :edit, game_params) do
    case Flags.update_flag(socket.assigns.flag, game_params) do
      {:ok, _game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Flag updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_game(socket, :new, game_params) do
    case Flags.create_flag(game_params) do
      {:ok, _game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Flag created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
