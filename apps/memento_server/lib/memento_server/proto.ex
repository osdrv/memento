defmodule MementoServer.Proto do
  use Protobuf, from: Path.expand("../../priv/data.proto", __DIR__)

  def put_timestamp(msg), do: put_timestamp(msg, :calendar.universal_time)
  def put_timestamp(msg, datetime) do
    Map.put(msg, :timestamp, datetime |> :calendar.datetime_to_gregorian_seconds)
  end

end
