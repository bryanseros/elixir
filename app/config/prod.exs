import Config

config :app, timezone: "America/Bogota"

config :app,
  http_port: 8083,
  enable_server: true,
  secret_name: "",
  version: "0.0.1",
  in_test: false,
  custom_metrics_prefix_name: "app"

config :logger,
  level: :warning

# tracer
config :opentelemetry,
  span_processor: :batch,
  traces_exporter: :otlp

config :opentelemetry_exporter,
  otlp_protocol: :http_protobuf,
  otlp_endpoint: "http://localhost:4318"

config :app,
  information_url: "http://localhost:3001/getInfo"

  config :app,
  get_identity: App.Infrastructure.Adapters.RestConsumer.Information.InformationAdapter
