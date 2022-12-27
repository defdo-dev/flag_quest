defmodule FlagQuestWeb.FlagGameLive.Show do
  use FlagQuestWeb, :live_view

  alias FlagQuest.Flags

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:flag, Flags.get_flag!(id))}
  end

  defp page_title(:show), do: "Show Flag"
  defp page_title(:edit), do: "Edit Flag"
end
