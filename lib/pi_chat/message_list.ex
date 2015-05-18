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
    Agent.get(__MODULE__, &(&1[:list]))
  end

  defp update_message([count: count, list: list], msg) do
    case count do
      @max_messages -> [count: @max_messages, list: (list |> Enum.drop(1)) ++ [msg]]
      _ -> [count: count+1, list: list ++ [msg] ]
    end
  end
end
