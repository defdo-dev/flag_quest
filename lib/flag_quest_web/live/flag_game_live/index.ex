defmodule FlagQuestWeb.FlagGameLive.Index do
  use FlagQuestWeb, :live_view

  alias FlagQuest.Flags
  alias FlagQuest.Schema.Flag

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :flags, list_flags())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Flag")
    |> assign(:flag, Flags.get_flag!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Flag")
    |> assign(:flag, %Flag{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Flags")
    |> assign(:flag, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    flag = Flags.get_flag!(id)
    {:ok, _} = Flags.delete_flag(flag)

    {:noreply, assign(socket, :flags, list_flags())}
  end

  defp list_flags do
    Flags.list_flags()
  end
end
