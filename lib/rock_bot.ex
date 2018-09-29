defmodule RockBot do
  require Logger
  
  def send_message(payload) do
    {:ok, decoded_payload} = Jason.decode(payload)
    message = "#{decoded_payload["name"]} said \"#{decoded_payload["message"]}\""
    case Nadia.send_message("@chat_through_evanilukhin_rockbot", message) do
      {:ok, _} -> :ok
      {:error, error} ->
        Logger.error "Nadia tried to send_message but something went wrong: #{error}"
        :error
    end
  end
end
