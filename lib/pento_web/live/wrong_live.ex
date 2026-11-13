defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, time: time(), given_number: given_number(), message: "Make a guess:")}
  end

  def render(assigns) do
    ~H"""
      <main class="px-4 py-20 sm:px-6 lg:px-8">
      <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>

      <h2>
        {@message}
        It's <%= @time %>
      </h2>
      <br />
      <h2>
        <%= for n <- 1..10 do %>
          <.link href="#"
            class="btn btn-secondary"
            phx-click="guess" phx-value-number={n} >
            <%= n %>
          </.link>
        <% end %>
      </h2>
      </main>
    """
  end

  def time do
    DateTime.utc_now() |> to_string()
  end

  def given_number do
    to_string(Enum.random(1..10))
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    { message, score } =
      cond do
        guess == socket.assigns.given_number -> {"You are f..ing right. How did you do it!", socket.assigns.score + 100}
        true -> {"Your guess: #{guess}. Wrong. Guess again. ", socket.assigns.score - 1}
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time()
      )
    }
  end
end
