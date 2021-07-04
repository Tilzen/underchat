defmodule UnderChatWeb.Router do
  use UnderChatWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", UnderChatWeb do
    pipe_through :api
  end

  scope "/users", UnderChatWeb do
    pipe_through :api

    resources "/", UserController, except: [:new, :edit]
  end

  scope "/account", UnderChatWeb do
    pipe_through :api

    get "/ping", SessionController, :ping
    post "/sign_in", SessionController, :create
    delete "/sign_out", SessionController, :delete
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: UnderChatWeb.Telemetry
    end
  end
end
