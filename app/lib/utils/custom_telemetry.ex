defmodule App.Utils.CustomTelemetry do
  alias App.Utils.DataTypeUtils
  alias App.Utils.CustomTelemetry
  import Telemetry.Metrics

  @service_non_required Application.compile_env!(:app, :custom_metrics_prefix_name)

  @moduledoc """
  Provides functions for custom telemetry events
  """

  def custom_telemetry_events() do
    :telemetry.attach("app-plug-stop", [:app, :plug, :stop], &CustomTelemetry.handle_custom_event/4, nil)
    :telemetry.attach("app-vm-memory", [:vm, :memory], &CustomTelemetry.handle_custom_event/4, nil)
    :telemetry.attach("vm-total_run_queue_lengths", [:vm, :total_run_queue_lengths], &CustomTelemetry.handle_custom_event/4, nil)
  end

  def execute_custom_event(metric, value, metadata \\ %{})
  def execute_custom_event(metric, value, metadata) when is_list(metric) do
    metadata = Map.put(metadata, :service, @service_non_required)
    :telemetry.execute([:elixir | metric], %{duration: value}, metadata)
  end
  def execute_custom_event(metric, value, metadata) when is_atom(metric) do
    execute_custom_event([metric], value, metadata)
  end

  def handle_custom_event([:app, :plug, :stop], measures, metadata, _) do
    :telemetry.execute(
      [:elixir, :http_request_duration_milliseconds],
      %{duration: DataTypeUtils.monotonic_time_to_milliseconds(measures.duration)},
      %{request_path: metadata.conn.request_path, service: @service_non_required}
    )
  end

  def handle_custom_event(metric, measures, metadata, _) do
    metadata = Map.put(metadata, :service, @service_non_required)
    :telemetry.execute([:elixir | metric], measures, metadata)
  end

# Finch
  def extract_metadata(%{
        name: HttpFinch,
        request: %{method: method, scheme: scheme, host: host, port: port, path: path},
        result: {_, %{status: status}}
      }) do
    %{
      request_path: "#{method} #{scheme}://#{host}:#{port}#{path}",
      status: "#{status}",
      service: @service_name
    }
  end

def metrics do
    [
      # Http Outgoing Requests
      counter("elixir.http_outgoing_request.count",
        event_name: [:finch, :request, :stop],
        tag_values: &__MODULE__.extract_metadata/1,
        tags: [:service, :request_path, :status]
      ),
      sum(
        "elixir.http_outgoing_request.duration",
        event_name: [:finch, :request, :stop],
        measurement: :duration,
        unit: {:native, :nanosecond},
        tag_values: &__MODULE__.extract_metadata/1,
        tags: [:service, :request_path, :status]
      ),

      # Http Outgoing Requests
      counter("elixir.http_outgoing_request.count",
        event_consumer: [:finch, :request, :stop],
        tag_values: &__MODULE__.extract_metadata/1,
        tags: [:service, :request_path, :status]
      ),
      sum(
        "elixir.http_outgoing_request.duration",
        event_consumer: [:finch, :request, :stop],
        measurement: :duration,
        unit: {:native, :nanosecond},
        tag_values: &__MODULE__.extract_metadata/1,
        tags: [:service, :request_path, :status]
      ),

      #Plug Metrics
      counter("elixir.http_request_duration_milliseconds.count", tags: [:request_path, :service]),
      sum("elixir.http_request_duration_milliseconds.duration", tags: [:request_path, :service]),

      # VM Metrics
      last_value("elixir.vm.memory.total", unit: {:byte, :kilobyte}, tags: [:service]),
      sum("elixir.vm.total_run_queue_lengths.total", tags: [:service]),
      sum("elixir.vm.total_run_queue_lengths.cpu", tags: [:service]),
      sum("elixir.vm.total_run_queue_lengths.io", tags: [:service]),
    ]
  end

end
