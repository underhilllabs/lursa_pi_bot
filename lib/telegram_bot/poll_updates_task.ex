defmodule TelegramBot.PollUpdatesTask do
  def poll(registry, updates \\ nil) do
    new_updates = if updates do
                    TelegramBot.API.getUpdates(updates.last_update_id + 1)
                  else
                    TelegramBot.API.getUpdates()
                  end

    if new_updates do
      updates = new_updates
      TelegramBot.ChatRegistry.broadcast_updates(registry, updates)
      :timer.sleep(200)
    end
    poll(registry, updates)
  end
end
