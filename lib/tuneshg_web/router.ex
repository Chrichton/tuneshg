defmodule TuneshgWeb.Router do
  use TuneshgWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TuneshgWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TuneshgWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/artists", ArtistLive.Index, :index
    live "/artists/new", ArtistLive.Index, :new
    live "/artists/:id/edit", ArtistLive.Index, :edit

    live "/artists/:id", ArtistLive.Show, :show
    live "/artists/:id/show/edit", ArtistLive.Show, :edit

    live "/albums", AlbumLive.Index, :index
    live "/albums/new", AlbumLive.Index, :new
    live "/albums/:id/edit", AlbumLive.Index, :edit

    live "/albums/:id", AlbumLive.Show, :show
    live "/albums/:id/show/edit", AlbumLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", TuneshgWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tuneshg, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TuneshgWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
