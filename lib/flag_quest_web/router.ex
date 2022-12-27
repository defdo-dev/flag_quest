defmodule FlagQuestWeb.Router do
  use FlagQuestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FlagQuestWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FlagQuestWeb do
    pipe_through :browser

    live "/", FlagGameLive, :new_game

    live "/flags", FlagGameLive.Index, :index
    live "/flags/new", FlagGameLive.Index, :new
    live "/flags/:id/edit", FlagGameLive.Index, :edit

    live "/flags/:id", FlagGameLive.Show, :show
    live "/flags/:id/show/edit", FlagGameLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", FlagQuestWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:flag_quest, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FlagQuestWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
