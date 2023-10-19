defmodule FootballApi.Models.Matches do
  @schema """
          {
            "type": "object",
            "required": [
              "response"
            ],
            "properties": {
              "response": {
                "type": "array",
                "items": {
                  "type": "object",
                  "required": [
                    "fixture",
                    "league",
                    "teams",
                    "goals",
                    "score"
                  ],
                  "properties": {
                    "fixture": {
                      "type": "object",
                      "required": [
                        "id",
                        "status",
                        "timestamp"
                      ],
                      "properties": {
                        "id": {
                          "type": "number"
                        },
                        "status": {
                          "type": "object",
                          "required": [
                            "short"
                          ],
                          "properties": {
                            "short": {
                              "type": "string"
                            }
                          }
                        },
                        "timestamp": {
                          "type": "number"
                        }
                      }
                    },
                    "score": {
                      "type": "object",
                      "required": [
                        "extratime",
                        "fulltime",
                        "halftime",
                        "penalty"
                      ],
                      "properties": {
                        "extratime": {
                          "type": "object",
                          "required": [
                            "home",
                            "away"
                          ],
                          "properties": {
                            "home": {
                              "type": [
                                "number",
                                "null"
                              ]
                            },
                            "away": {
                              "type": [
                                "number",
                                "null"
                              ]
                            }
                          }
                        },
                        "halftime": {
                          "type": "object",
                          "required": [
                            "home",
                            "away"
                          ],
                          "properties": {
                            "home": {
                              "type": [
                                "number",
                                "null"
                              ]
                            },
                            "away": {
                              "type": [
                                "number",
                                "null"
                              ]
                            }
                          }
                        },
                        "fulltime": {
                          "type": "object",
                          "required": [
                            "home",
                            "away"
                          ],
                          "properties": {
                            "home": {
                              "type": [
                                "number",
                                "null"
                              ]
                            },
                            "away": {
                              "type": [
                                "number",
                                "null"
                              ]
                            }
                          }
                        },
                        "penalty": {
                          "type": "object",
                          "required": [
                            "home",
                            "away"
                          ],
                          "properties": {
                            "home": {
                              "type": [
                                "number",
                                "null"
                              ]
                            },
                            "away": {
                              "type": [
                                "number",
                                "null"
                              ]
                            }
                          }
                        }
                      }
                    },
                    "league": {
                      "type": "object",
                      "required": [
                        "id",
                        "season",
                        "round",
                        "name"
                      ],
                      "properties": {
                        "id": {
                          "type": "number"
                        },
                        "season": {
                          "type": "number"
                        },
                        "round": {
                          "type": "string"
                        },
                        "name": {
                          "type": "string"
                        }
                      }
                    },
                    "teams": {
                      "type": "object",
                      "required": [
                        "home",
                        "away"
                      ],
                      "properties": {
                        "home": {
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
                        "away": {
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
