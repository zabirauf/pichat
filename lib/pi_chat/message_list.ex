defmodule PiChat.MessageList do

  @max_messages 10

  def start_link() do
    Agent.start_link(fn -> [count: 0, list: []] end, name: __MODULE__)
  end

  def update(msg) do
    Agent.cast(__MODULE__,
      &(update_message(&1, msg)))
  end

  def get() do
    Agent.get(__MODULE__, &( Enum.reverse(&1[:list]) ))
  end

  defp update_message([count: count, list: list], msg) do
    case count do
      @max_messages -> [count: @max_messages, list: [msg | Enum.drop(list, -1)] ]
      _ -> [count: count+1, list: [msg | list] ]
    end
  end
end
