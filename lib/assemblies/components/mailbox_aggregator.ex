defmodule MailboxAggregator do
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    Registry.register(GlobalRegistry, "MailboxAggregator", nil)
    
    Logger.info "[MailboxAggregator] init"
    {:ok, mailbox_pid} = MailboxWrapper.register_mailbox(MailboxAggregator)
    {:ok,
      %{
        process_name: "MailboxAggregator",
        mailbox: mailbox_pid
      }
    }
  end

  def handle_info({:mail, _, messages, _count, drop_count}, state) do
    if drop_count > 0 do
      Logger.error "[MailboxAggregator] drop count: #{inspect drop_count}"
    end

    messages
      |> Enum.map(fn({handler, msg}) ->
        handler.(msg)
      end)

    MailboxWrapper.activate_mailbox(state.mailbox)
    {:noreply, state}
  end
end
