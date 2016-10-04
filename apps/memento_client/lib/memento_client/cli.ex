defmodule MementoClient.CLI do

  alias MementoClient.Proto
  alias MementoClient.Server

  def parse_args(args) do
    {parsed, _args, _invalid}= args
      |> OptionParser.parse(
        switcehs: [
          from: :string
        ]
      )
    {from, parsed}= Keyword.pop(parsed, :from)
    stream= case from do
      nil ->
        IO.stream(:stdio, :line)
      from ->
        File.stream!(from, [], :line)
    end
    {stream, parsed}
  end

  def proceed({stream, opts}) do
    #TODO
    body= stream
      |> Enum.reduce(fn(line, acc) ->
        acc <> line
      end)
    # FIXME: implement client ID fetching from the app config
    message= Proto.Note.new(body: body, client_id: "Some dummy client id")
      |> Proto.put_uuid
      |> Proto.put_timestamp
    case Server.is_running? do
      false -> raise "Server seems to be down."
      true  ->
        Server.send_data(message, fn(resp) ->
          IO.inspect resp
        end)
    end
  end

end