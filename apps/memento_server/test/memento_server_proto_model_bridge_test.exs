defmodule MementoServerProtoModelBridgeTest do
  use ExUnit.Case, async: true
  alias MementoServer.Proto
  alias MementoServer.Model
  import MementoServer.TestHelper, only: [a_uuid: 0, a_string: 1]
  alias MementoServer.ProtoModelBridge, as: Bridge

  test "note_to_proto" do
    uuid= a_uuid
    body= a_string(512)
    timestamp= Ecto.DateTime.utc
    model_note= %Model.Note{
      id:          uuid,
      body:        body,
      inserted_at: timestamp
    }
    assert (model_note |> Bridge.note_to_proto) == %Proto.Note{
      uuid: uuid,
      body: body,
      timestamp: timestamp |> Ecto.DateTime.to_erl |> :calendar.datetime_to_gregorian_seconds,
    }
  end

  test "proto_to_note" do
    uuid= a_uuid
    body= a_string(512)
    timestamp= :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds
    proto_note= %Proto.Note{
      uuid: uuid,
      body: body,
      timestamp: timestamp,
    }
    assert proto_note |> Bridge.proto_to_note == %Model.Note{
      id: uuid,
      body: body,
      inserted_at: timestamp |> :calendar.gregorian_seconds_to_datetime |> Ecto.DateTime.from_erl,
    }
  end

  test "vector_clock_to_map" do
    vector_clock= Proto.VectorClock.new(
      clocks: [
        Proto.Clock.new( key: :a, value: 1 ),
        Proto.Clock.new( key: :b, value: 2 ),
      ]
    )
    assert Bridge.vector_clock_to_map(vector_clock) == %{ a: 1, b: 2 }
  end

  test "map_to_vector_clock" do
    map= %{ a: 1, b: 2 }
    assert Bridge.map_to_vector_clock(map) == %Proto.VectorClock{
      clocks: [
        %Proto.Clock{ key: :a, value: 1 },
        %Proto.Clock{ key: :b, value: 2 },
      ]
    }
  end

end
