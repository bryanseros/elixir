defmodule App.Infrastructure.EntryPoints.ClientRequestValidation do

  def validate_request_body(request) when request.data == "" do
    {:error, :data_not_found}
  end

  def validate_request_body(request) when request == %{} do
    {:error, :request_empty}
  end

  def validate_request_body(request) when request != %{} do
    {:ok, request}
  end
end
