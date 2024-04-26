defmodule App.Config.AppConfig do

  @moduledoc """
   Provides strcut for app-config
  """

   defstruct [
     :information_url,
     :enable_server,
     :http_port
   ]

   def load_config do
     %__MODULE__{
       information_url: load(:information_url),
       enable_server: load(:enable_server),
       http_port: load(:http_port)
     }
   end

   defp load(property_name), do: Application.fetch_env!(:app, property_name)
 end
