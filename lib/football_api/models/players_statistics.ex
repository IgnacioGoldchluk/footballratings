defmodule FootballApi.Models.PlayersStatistics do
  @moduledoc """
  External API schema for validation.
  """

  @schema """
          {
            "type": "object",
            "required": [
              "response"
            ],
            "properties": {
              "response": {
                "type": "array",
                "minItems": 1,
                "items": {
                  "type": "object",
                  "requied": [
                    "team",
                    "players"
                  ],
                  "properties": {
                    "team": {
                      "type": "object",
                      "required": [
                        "id"
                      ],
                      "properties": {
                        "id": {
                          "type": "number"
                        }
                      }
                    },
                    "players": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "required": [
                          "player",
                          "statistics"
                        ],
                        "properties": {
                          "player": {
                            "type": "object",
                            "required": [
                              "id"
                            ],
                            "properties": {
                              "id": {
                                "type": ["number", "null"]
                              }
                            }
                          },
                          "satistics": {
                            "type": "array",
                            "minItems": 1,
                            "maxItems": 1,
                            "items": {
                              "type": "object",
                              "required": [
                                "games"
                              ],
                              "properties": {
                                "games": {
                                  "type": "object",
                                  "required": [
                                    "minutes"
                                  ],
                                  "properties": {
                                    "minutes": {
                                      "type": "number",
                                      "minimum": 0
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
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
