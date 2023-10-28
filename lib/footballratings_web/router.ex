defmodule FootballratingsWeb.Router do
  use FootballratingsWeb, :router

  import FootballratingsWeb.UsersAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {FootballratingsWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_users)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", FootballratingsWeb do
    pipe_through([:browser, :redirect_if_users_is_authenticated])

    get("/auth/:provider", UserOauthController, :request)
    get("/auth/:provider/callback", UserOauthController, :callback)
  end

  scope "/", FootballratingsWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
    get("/ratings/show/:match_ratings_id", MatchRatingsController, :show)

    live_session :main do
      live("/teams", TeamLive.Index, :index)
      live("/teams/:team_id", TeamLive.Show, :show)
      live("/teams/:team_id/matches", TeamLive.Matches, :show)
      live("/teams/:team_id/players", TeamLive.Players, :players)
      live("/available-matches", MatchLive.Available, :index)
      live("/matches", MatchLive.Index, :index)
      live("/matches/:match_id", MatchLive.Show, :index)
      live("/matches/:match_id/statistics", RatingLive.MatchStatistics, :match_statistics)
      live("/players", PlayerLive.Index, :index)
      live("/players/:player_id", PlayerLive.Show, :show)
      live("/ratings/users/:users_id", RatingLive.Users, :index)
      live("/ratings/player/:player_id", RatingLive.PlayerStatistics, :show)
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", FootballratingsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:footballratings, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: FootballratingsWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes
  scope "/", FootballratingsWeb do
    pipe_through([:browser, :require_authenticated_users])

    live_session :require_authenticated_users,
      on_mount: [{FootballratingsWeb.UsersAuth, :ensure_authenticated}] do
      live("/user/settings", UsersSetUsernameLive, :set_username)
    end

    live_session :ensure_username_set,
      on_mount: [{FootballratingsWeb.UsersAuth, :ensure_username_set}] do
      live("/matches/:match_id/rate/:team_id", MatchLive.Rate, :rate)
    end
  end

  scope "/", FootballratingsWeb do
    pipe_through([:browser])

    delete("/users/log_out", UsersSessionController, :delete)
  end
end
