defmodule MsmarketWeb.Router do
  use MsmarketWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug MsmarketWeb.Context
  end

  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
      schema: MsmarketWeb.Schema,
      json_codec: Jason,
      document_providers: [Absinthe.Plug.DocumentProvider.Default],
      context: %{pubsub: MsmarketWeb.Endpoint}


    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: MsmarketWeb.Schema,
      interface: :playground,
      context: %{pubsub: MsmarketWeb.Endpoint}
  end

end
