defmodule TuneshgWeb.AlbumLive.FormComponent do
  use TuneshgWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage album records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="album-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
          <.input field={@form[:name]} type="text" label="Name" />
          <.input field={@form[:year_released]} type="number" label="Year released" />
          <.input field={@form[:cover_image_url]} type="text" label="Cover image url" />
          <.form :let={f} for={@form} phx-change="change">
            <.live_select
              field={f[:artist_id]}
              id="live_select_id"
              phx-target={@myself}
              label="Artist"
            />
          </.form>
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input field={@form[:name]} type="text" label="Name" />
          <.input field={@form[:year_released]} type="number" label="Year released" />
          <.input field={@form[:cover_image_url]} type="text" label="Cover image url" />
          <.form :let={f} for={@form} phx-change="change">
            <.live_select
              field={f[:artist_id]}
              id="live_select_id"
              phx-target={@myself}
              label="Artist"
            />
          </.form>
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Album</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"form" => form_data}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, form_data))}
  end

  def handle_event("save", %{"form" => form_data}, socket) do
    IO.inspect(form_data, label: "form_data")
    IO.inspect(socket.assigns.form, label: "form")

    case AshPhoenix.Form.submit(socket.assigns.form, params: form_data) do
      {:ok, album} ->
        notify_parent({:saved, album})

        socket =
          socket
          |> put_flash(:info, "Album #{socket.assigns.form.source.type} saved successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  @impl true
  def handle_event("live_select_change", %{"text" => text, "id" => live_select_id}, socket) do
    artists =
      Tuneshg.Music.search_artists!(text, query: [sort_input: "name"])
      |> Enum.map(fn artist -> {artist.name, artist.id} end)

    send_update(LiveSelect.Component, id: live_select_id, options: artists)

    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{album: album}} = socket) do
    if album do
      artist = Tuneshg.Music.get_artist_by_id!(album.artist_id)
      form = Tuneshg.Music.form_to_update_album(album)
      send_update(LiveSelect.Component, id: "live_select_id", value: {artist.name, artist.id})

      socket
      |> assign(artist: artist)
      |> assign(form: to_form(form))
    else
      form = Tuneshg.Music.form_to_create_album()
      assign(socket, form: to_form(form))
    end
  end
end
