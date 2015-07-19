defmodule TelegramBot.API do
  use HTTPoison.Base

  @post_headers %{"Content-type" => "application/x-www-form-urlencoded"}
  @photos  ["lursa1", "betor", "duras", "gowran", "klingon1"]
  @captions  ["PetaQ!", "You dress like a Ferengi", "Look at the Qa'Hom shaking in his Pe'lak'ta'huk!", "Youre head has ridges, but your blood runs like water."]

  def process_url(url) do
    "https://api.telegram.org/bot" <> token <> "/" <> url
  end

  defp token, do: Application.get_env(:telegram_bot, :bot_token)

  def get_updates(offset \\ nil, limit \\ 100, timeout \\ 30) do
    {:ok, response} = post("getUpdates", {:form, [offset: offset, limit: limit, timeout: timeout]}, @post_headers)
    %{"ok" => true, "result" => result} = response.body
    TelegramBot.Models.Updates.new(result)
  end

  def send_message(chat_id, text) do
    post("sendMessage", {:form, [chat_id: chat_id, text: text]}, @post_headers)
  end

  def send_sticker(chat_id, sticker) do
    post("sendSticker", {:form, [chat_id: chat_id, sticker: sticker]}, @post_headers)
  end

  def send_photo(chat_id, filename \\ "fake", caption \\ nil) do 
    filename = "img/"<>sample_list(@photos)<>".jpg"
    unless caption do
      caption = sample_list(@captions)
    end
    post("sendPhoto", {:multipart, [{"chat_id", Integer.to_string(chat_id)}, {"caption", caption}, {:file, filename,{"form-data", [{"filename", filename},{"name", "photo"}]}, [{"Content-Type", "image/jpeg"}] }]})
  end

  def process_response_body(body) do
    body |> Poison.decode!
  end

  def sample_list(photos) do
    Enum.shuffle(photos) |> List.first
  end
end
