defmodule TuneshgWeb.ArtistLive.FormComponent do
  use TuneshgWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage artist records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="artist-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" /><.input
          field={@form[:biography]}
          type="text"
          label="Biography"
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Artist</.button>
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
  def handle_event("validate", %{"artist" => artist_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, artist_params))}
  end

  def handle_event("save", %{"artist" => artist_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: artist_params) do
      {:ok, artist} ->
        notify_parent({:saved, artist})

        socket =
          socket
          |> put_flash(:info, "Artist #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{artist: artist}} = socket) do
    form =
      if artist do
        AshPhoenix.Form.for_update(artist, :update, as: "artist")
      else
        AshPhoenix.Form.for_create(Tuneshg.Music.Artist, :create, as: "artist")
      end

    assign(socket, form: to_form(form))
  end
end
