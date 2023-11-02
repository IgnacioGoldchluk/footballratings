defmodule FootballApi.Models.Squads do
  @moduledoc """
  External API schema for validation.
  """

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
                                            "type": ["number", "null"]
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
