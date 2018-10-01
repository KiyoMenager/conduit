defmodule Conduit.Support.Unique do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def claim(context, value) do
    GenServer.call(__MODULE__, {:claim, context, value})
  end

  def init(state), do: {:ok, state}

  def handle_call({:claim, context, value}, _from, assignments) do
    {reply, state} =
      case Map.get(assignments, context) do
        nil ->
          {:ok, Map.put(assignments, context, MapSet.new([value]))}

        values ->
          case MapSet.member?(values, value) do
            true -> {{:error, :already_taken}, assignments}
            false -> {:ok, Map.update!(assignments, context, &MapSet.put(&1, value))}
          end
      end

    {:reply, reply, state}
  end
end
