# Ms Market GraphQL API

This is an implementation of Grapql server neccessary for msmarket mobile application
In order to run this server correctly you will need all of those things:
  * **client id**, **client secret**, **redirect uri** **|** all of those can be generated on DSNET panel
  * local postgres database: you can find all neccessary database names and passowrds in config/dev file.exs
  * Elixir installed

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

To check graphql schema you can vist [`localhost:4000/api/graphiql`](http://localhost:4000/api/graphiql) in your browser.

To access images api please check ImageServer readme. This graphql api only allows you to generate tokens neccessary for authorization, images manipulation
is being done by REST endpoint.

