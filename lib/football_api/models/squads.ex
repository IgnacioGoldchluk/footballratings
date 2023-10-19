defmodule FootballApi.Models.Squads do
  @schema """
          {
            "type": "object",
            "properties": {
                "response": {
                    "type": "array",
                    "minItems": 1,
                    "maxItems": 1,
                    "items": {
                        "type": "object",
                        "required": [
                            "players"
                        ],
                        "properties": {
                            "players": {
                                "type": "array",
                                "items": {
                                    "type": "object",
                                    "properties": {
                                        "id": {
                                            "type": [
                                                "number",
                                                "null"
                                            ]
                                        },
                                        "name": {
                                            "type": "string"
                                        },
                                        "age": {
                                            "type": "number",
                                            "minimum": 1
                                        }
                                    },
                                    "required": [
                                        "id",
                                        "name",
                                        "age"
                                    ]
                                }
                            }
                        }
                    }
                }
            }
          }
          """
          |> Jason.decode!()
          |> JsonXema.new()

  def json_schema(), do: @schema
end
