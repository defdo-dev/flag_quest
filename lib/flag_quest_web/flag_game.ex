defmodule FlagQuestWeb.FlagGameLive do
  @moduledoc """

  """
  use FlagQuestWeb, :live_view
  alias FlagQuest.Flags

  def render(assigns) do
    ~H"""
    <section class="flex flex-col justify-center space-y-6">
      <nav class="flex justify-between">
        <h2 class="text-lg font-medium">Guess the flag</h2>
        <div>
          <span class="rounded-full bg-success/5 px-2 text-[0.8125rem] font-medium leading-6 text-success">Guesses: <%= @score.guesses %></span>
          <span class="rounded-full bg-error/5 px-2 text-[0.8125rem] font-medium leading-6 text-error">Mistakes: <%= @score.errors %></span>
          <span class="rounded-full bg-info/5 px-2 text-[0.8125rem] font-medium leading-6 text-info">Revealed: <%= @score.revealed %></span>
        </div>
      </nav>
      <div class="grid md:grid-cols-2 justify-center">
        <%= if @guess_flag do %>
          <img src={@guess_flag.image} class="h-32 place-self-center" />
        <% else %>
          <svg class="h-32 place-self-center bg-black rounded-md" viewBox="0 0 500 250" xmlns="http://www.w3.org/2000/svg">
            <rect />
            <text x="50%" y="50%" alignment-baseline="middle" text-anchor="middle" font-size="42" stroke-width="2" stroke="#fff">...</text>
          </svg>
        <% end %>
        <%= if @reveal_name do %>
          <h3 class="place-self-center"><%= @guess_flag.name %></h3>
        <% end %>
      </div>

      <%= if @reveal_name do %>
        <.button phx-click="new_guess">Try another</.button>
      <% else %>
        <.simple_form :let={f} for={:guess_flag} phx-submit="guess">
          <.input field={{f, :guess}} label="Whose flag is it?" autocomplete="off"/>
          <:actions>
            <.button>Guess the flag</.button>
          </:actions>
        </.simple_form>

        <.button phx-click="reveal">I'm loss, give me the name.</.button>
      <% end %>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    flag = if connected?(socket) do
      Flags.list_flags() |> Enum.take_random(1) |> hd()
    else
      nil
    end

    {:ok, assign(socket, guess_flag: flag, reveal_name: false, score: %{guesses: 0, errors: 0, revealed: 0})}
  end

  def handle_event("guess", %{"guess_flag" => %{"guess" => answer}}, socket) do
    answer = String.downcase(answer)
    flag_name = String.downcase(socket.assigns.guess_flag.name)

    socket = if answer == flag_name do
      new_flag = get_new_flag(socket.assigns.guess_flag)

      socket
      |> update(:score, &(%{&1 | guesses: &1.guesses + 1}))
      |> assign(:guess_flag, new_flag)
    else
      socket
      |> update(:score, &(%{&1 | errors: &1.errors + 1}))
    end

    {:noreply, socket}
  end

  def handle_event("reveal", _params, socket) do
    socket =
      socket
      |> assign(reveal_name: true)
      |> update(:score, &(%{&1 | revealed: &1.revealed + 1}))

    {:noreply, socket}
  end

  def handle_event("new_guess", _params, socket) do
    new_flag = get_new_flag(socket.assigns.guess_flag)

    socket =
      socket
      |> assign(reveal_name: false)
      |> assign(:guess_flag, new_flag)

    {:noreply, socket}
  end

  def get_new_flag(previous_flag) do
    flag = Flags.list_flags() |> Enum.take_random(1) |> hd()

    if previous_flag == flag do
      get_new_flag(previous_flag)
    else
      flag
    end
  end
end
