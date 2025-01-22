defmodule TuneshgWeb.AlbumLive.Show do
  use TuneshgWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Album {@album.id}
      <:subtitle>This is a album record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/albums/#{@album}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit album</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id">{@album.id}</:item>
    </.list>

    <.back navigate={~p"/albums"}>Back to albums</.back>

    <.modal
      :if={@live_action == :edit}
      id="album-modal"
      show
      on_cancel={JS.patch(~p"/albums/#{@album}")}
    >
      <.live_component
        module={TuneshgWeb.AlbumLive.FormComponent}
        id={@album.id}
        title={@page_title}
        action={@live_action}
        album={@album}
        patch={~p"/albums/#{@album}"}
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
     |> assign(:album, Ash.get!(Tuneshg.Music.Album, id))}
  end

  defp page_title(:show), do: "Show Album"
  defp page_title(:edit), do: "Edit Album"
end
