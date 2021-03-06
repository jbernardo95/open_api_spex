defmodule PhoenixAppWeb.Router do
  use Phoenix.Router

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(OpenApiSpex.Plug.PutApiSpec, module: PhoenixAppWeb.ApiSpec)
  end

  scope "/" do
    pipe_through(:browser)

    get("/swaggerui", OpenApiSpex.Plug.SwaggerUI,
      path: "/api/openapi",
      default_model_expand_depth: 3,
      display_operation_id: true
    )
  end

  scope "/api" do
    pipe_through(:api)
    resources("/users", PhoenixAppWeb.UserController, only: [:index, :show, :update])
    post("/users/:group_id", PhoenixAppWeb.UserController, :create)
    get("/openapi", OpenApiSpex.Plug.RenderSpec, :show)
  end
end
