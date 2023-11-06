defmodule FootballratingsWeb.UserSettingsController do
  use FootballratingsWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
