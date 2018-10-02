defmodule MailboxWrapper do

  def register_mailbox(process_name, buffer_size \\ 1000) do
    {:ok, pid} = :pobox.start_link(via_process_name(process_name), self(), buffer_size, :queue)
    activate_mailbox(pid)

    {:ok, pid}
  end

  defp via_process_name(process_name) do
    {:via, Registry, {GlobalRegistry, process_name}}
  end

  def activate_mailbox(mailbox) do
    :pobox.active(mailbox, fn(msg, _) -> 
        {{:ok, msg}, :ok}
      end, :ok)
  end

  def send(target_process, message) do
    Registry.dispatch(GlobalRegistry, target_process, fn(entries) ->
      for {pid, _} <- entries do
        :pobox.post(pid, message)
      end
    end)
  end
end

