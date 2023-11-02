defmodule FootballApi.Models.Lineups do
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
                "minItems": 2,
                "maxItems": 2,
                "items": {
                  "type": "object",
                  "required": [
                    "coach",
                    "startXI",
                    "substitutes",
                    "team"
                  ],
                  "properties": {
                    "coach": {
                      "type": "object",
                      "required": [
                        "id",
                        "name"
                      ],
                      "properties": {
                        "id": {
                          "type": ["number", "null"]
                        },
                        "name": {
                          "type": "string"
                        }
                      }
                    },
                    "team": {
                      "type": "object",
                      "required": [
                        "id"
                      ],
                      "properties": {
                        "id": {
                          "type": ["number"]
                        }
                      }
                    },
                    "substitutes": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "required": [
                          "player"
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
                          }
                        }
                      }
                    },
                    "startXI": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "required": [
                          "player"
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
