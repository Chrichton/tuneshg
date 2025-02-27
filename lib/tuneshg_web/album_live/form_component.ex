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
          <.form for={@form} phx-change="change">
            <.live_select field={@form[:city_search]} phx-target={@myself} label="City" />
          </.form>
          <.input field={@form[:name]} type="text" label="Name" /><.input
            field={@form[:year_released]}
            type="number"
            label="Year released"
          /><.input field={@form[:cover_image_url]} type="text" Label="Cover image url" /><.input
            field={@form[:artist_id]}
            type="text"
            label="Artist"
          />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input field={@form[:name]} type="text" label="Name" />
          <.input field={@form[:year_released]} type="number" label="Year released" /><.input
            field={@form[:cover_image_url]}
            type="text"
            label="Cover image url"
          /><.input field={@form[:artist_id]} type="text" label="Artist_Id" />
          <.input name="artist_id" value={@artist.name} label="Artist" disabled />
          <%!-- <pre><%= inspect(@form, pretty: true) %></pre> --%>
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
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_data) do
      {:ok, album} ->
        notify_parent({:saved, album})

        socket =
          socket
          |> put_flash(:info, "Album #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  @impl true
  def handle_event("live_select_change", %{"text" => text, "id" => live_select_id}, socket) do
    # cities = City.search(text)
    cities = [
      {"New York City", [-74.00597, 40.71427]},
      {"New Kingston", [-76.78319, 18.00747]}
      # ...
    ]

    send_update(LiveSelect.Component, id: live_select_id, options: cities)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "change",
        %{"my_form" => %{"city_search_text_input" => city_name, "city_search" => city_coords}},
        socket
      ) do
    IO.puts("You selected city #{city_name} located at: #{city_coords}")

    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{album: album}} = socket) do
    if album do
      artist = Tuneshg.Music.get_artist_by_id!(album.artist_id)
      form = Tuneshg.Music.form_to_update_album(album)

      socket
      |> assign(artist: artist)
      |> assign(form: to_form(form))
    else
      form = Tuneshg.Music.form_to_create_album()
      assign(socket, form: to_form(form))
    end
  end
end
