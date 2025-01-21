defmodule TuneshgWeb.ArtistLive.Index do
  use TuneshgWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Artists
      <:actions>
        <.link patch={~p"/artists/new"}>
          <.button>New Artist</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="artists"
      rows={@streams.artists}
      row_click={fn {_id, artist} -> JS.navigate(~p"/artists/#{artist}") end}
    >
      <:col :let={{_id, artist}} label="Name">{artist.name}</:col>

      <:action :let={{_id, artist}}>
        <div class="sr-only">
          <.link navigate={~p"/artists/#{artist}"}>Show</.link>
        </div>

        <.link patch={~p"/artists/#{artist}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, artist}}>
        <.link
          phx-click={JS.push("delete", value: %{id: artist.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="artist-modal"
      show
      on_cancel={JS.patch(~p"/artists")}
    >
      <.live_component
        module={TuneshgWeb.ArtistLive.FormComponent}
        id={(@artist && @artist.id) || :new}
        title={@page_title}
        action={@live_action}
        artist={@artist}
        patch={~p"/artists"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :artists, Ash.read!(Tuneshg.Music.Artist))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Artist")
    |> assign(:artist, Ash.get!(Tuneshg.Music.Artist, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Artist")
    |> assign(:artist, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Artists")
    |> assign(:artist, nil)
  end

  @impl true
  def handle_info({TuneshgWeb.ArtistLive.FormComponent, {:saved, artist}}, socket) do
    {:noreply, stream_insert(socket, :artists, artist)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    artist = Ash.get!(Tuneshg.Music.Artist, id)
    Ash.destroy!(artist)

    {:noreply, stream_delete(socket, :artists, artist)}
  end
end
