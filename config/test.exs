use Mix.Config

#config :logger, level: :debug
config :river_place_client, http_client: RiverPlaceClient.HttpClientMock
