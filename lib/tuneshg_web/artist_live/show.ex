defmodule TuneshgWeb.ArtistLive.Show do
  use TuneshgWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Artist {@artist.id}
      <:subtitle>This is a artist record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/artists/#{@artist}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit artist</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id">{@artist.id}</:item>
    </.list>

    <.back navigate={~p"/artists"}>Back to artists</.back>

    <.modal
      :if={@live_action == :edit}
      id="artist-modal"
      show
      on_cancel={JS.patch(~p"/artists/#{@artist}")}
    >
      <.live_component
        module={TuneshgWeb.ArtistLive.FormComponent}
        id={@artist.id}
        title={@page_title}
        action={@live_action}
        artist={@artist}
        patch={~p"/artists/#{@artist}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:artist, Ash.get!(Tuneshg.Music.Artist, id))}
  end

  defp page_title(:show), do: "Show Artist"
  defp page_title(:edit), do: "Edit Artist"
end
