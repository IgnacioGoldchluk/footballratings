defmodule FootballApi.Models.Lineups do
  @schema """
          {
            "type": "object",
            "required": [
              "response"
            ],
            "properties": {
              "response": {
                "type": "object",
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
                          "type": "number"
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
                          "type": "number"
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
                                "type": "number"
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
                                "type": "number"
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
