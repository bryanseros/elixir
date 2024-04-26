defmodule App.Infrastructure.Adapters.RestConsumer.Information.InformationAdapter do
  alias App.Config.ConfigHolder
  #alias App.Domain.Model.Information
  #alias App.Infrastructure.Adapters.RestConsumer.Information.Data.InformationRequest

  ## TODO: Update behaviour
  # @behaviour App.Domain.Behaviours.InformationBehaviour

  def get() do
    %{information_url: url} = ConfigHolder.conf()

    with {:ok, %Finch.Response{body: body}} <- Finch.build(:get, url) |> IO.inspect() |> Finch.request(HttpFinch) |> IO.inspect(),
         {:ok, response} <- Poison.decode(body) do
      {:ok, response}
    end
  end

  def post(body) do
    %{information_url: url} = ConfigHolder.conf()
    headers = [{"Content-Type", "application/json"}]

    #body = struct(InformationRequest, body)

    with {:ok, request} <- Poison.encode(body),
         {:ok, %Finch.Response{body: body, status: _}}
            <- Finch.build(:post, url, headers, request) |> Finch.request(HttpFinch) do

        #Poison.decode(body, as: %Information{})
        Poison.decode(body)
    end
  end
end
