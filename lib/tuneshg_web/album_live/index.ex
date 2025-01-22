defmodule TuneshgWeb.AlbumLive.Index do
  use TuneshgWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Albums
      <:actions>
        <.link patch={~p"/albums/new"}>
          <.button>New Album</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="albums"
      rows={@streams.albums}
      row_click={fn {_id, album} -> JS.navigate(~p"/albums/#{album}") end}
    >
      <:col :let={{_id, album}} label="Name">{album.name}</:col>

      <:action :let={{_id, album}}>
        <div class="sr-only">
          <.link navigate={~p"/albums/#{album}"}>Show</.link>
        </div>

        <.link patch={~p"/albums/#{album}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, album}}>
        <.link
          phx-click={JS.push("delete", value: %{id: album.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="album-modal"
      show
      on_cancel={JS.patch(~p"/albums")}
    >
      <.live_component
        module={TuneshgWeb.AlbumLive.FormComponent}
        id={(@album && @album.id) || :new}
        title={@page_title}
        action={@live_action}
        album={@album}
        patch={~p"/albums"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :albums, Ash.read!(Tuneshg.Music.Album))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Album")
    |> assign(:album, Ash.get!(Tuneshg.Music.Album, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Album")
    |> assign(:album, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Albums")
    |> assign(:album, nil)
  end

  @impl true
  def handle_info({TuneshgWeb.AlbumLive.FormComponent, {:saved, album}}, socket) do
    {:noreply, stream_insert(socket, :albums, album)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    album = Ash.get!(Tuneshg.Music.Album, id)
    Ash.destroy!(album)

    {:noreply, stream_delete(socket, :albums, album)}
  end
end
