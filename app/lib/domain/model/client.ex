defmodule App.Domain.Model.Client do
  alias __MODULE__
  @derive [Poison.Encoder]
  defstruct [:type, :number]

  def new_client(params) do

    # La línea de código `type = get_in(params, [:data, :identification, :type])` en Elixir se utiliza para obtener un valor específico de una estructura de datos anidada.
    # En este caso, `params` es probablemente un mapa o una lista de palabras clave que contiene otros mapas o listas de palabras clave. `get_in` es una función que toma esta estructura de datos y una lista de claves, y devuelve el valor en la estructura de datos que corresponde a la secuencia de claves.
    # Por lo tanto, `[:data, :identification, :type]` es una lista de claves. Elixir buscará en `params` la clave `:data`, luego en el valor que obtiene buscará la clave `:identification`, y finalmente en ese valor buscará la clave `:type`.
    # El valor que se obtiene se asigna a la variable `type`.
    type = get_in(params, [:data, :identification, :type]) || ""
    number = get_in(params, [:data, :identification, :number]) || ""

    client = %__MODULE__{
      type: type,
      number: number
    }
    validate_client(client)
  end

  defp validate_client(client) do
    cond do
      client.type == "" -> {:error, :type_not_found}
      client.number == "" -> {:error, :number_not_found}
      String.length(client.type) > 12 -> {:error, :type_too_long}
      String.length(client.number) > 15 -> {:error, :number_too_long}
      true -> {:ok, client}
    end
  end

end
