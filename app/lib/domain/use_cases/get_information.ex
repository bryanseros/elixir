defmodule App.Domain.UseCase.GetInformation do
  @moduledoc """
  GetInformation
  """

  ## TODO Add functions to business logic app
  require Logger

  @information Application.compile_env(:app, :get_identity)

  def get_information() do
    info = @information.get() |> IO.inspect()
    {:ok, :consulta}
  end

end
