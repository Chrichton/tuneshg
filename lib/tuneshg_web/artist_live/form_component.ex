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
  def handle_event("validate", %{"form" => form_data}, socket) do
    socket =
      update(socket, :form, fn form ->
        AshPhoenix.Form.validate(form, form_data)
      end)

    {:noreply, socket}
  end

  def handle_event("save", %{"form" => form_data}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_data) do
      {:ok, artist} ->
        notify_parent({:saved, artist})

        socket =
          socket
          |> put_flash(:info, "Artist #{socket.assigns.form.source.type} saved successfully")
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
        Tuneshg.Music.form_to_update_artist(artist)

        # instead of
        # AshPhoenix.Form.for_update(artist, :update, as: "artist")

        # doesn't work. Different Params to Validate
        # HANDLE EVENT "validate" in TuneshgWeb.ArtistLive.Index
        # Component: TuneshgWeb.ArtistLive.FormComponent
        # Parameters: %{"_target" => ["form", "name"], "form" => %{"_unused_biography" => "", "_unused_name" => "", "biography" => "", "name" => "m"}}
        # Why does that happen?

        # when using
        # AshPhoenix.Form.for_update(artist, :update, as: "artist")
        # the params are:
        # HANDLE EVENT "validate" in TuneshgWeb.ArtistLive.Index
        # Component: TuneshgWeb.ArtistLive.FormComponent
        # Parameters: %{"_target" => ["artist", "biography"], "artist" => %{"biography" => "my_biography", "name" => "my_name"}}

        # AshPhoenix.Form.for_update(artist, :update)
      else
        Tuneshg.Music.form_to_create_artist()

        # AshPhoenix.Form.for_create(Tuneshg.Music.Artist, :create)
      end

    assign(socket, form: to_form(form))
  end
end
