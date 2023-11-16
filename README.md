# Project setup

## Tools and dependencies

### Erlang and Elixir
1. Install [`asdf`](https://asdf-vm.com/).
2. Run `asdf install` from the root of the repo. It should install the Elixir and Erlang versions specified in [`tool-versions`](/.tool-versions)

### Docker, Node and npm.
1. Install `Docker`, `nodejs` and `npm` by following the corresponding instructions for your OS.

## Project setup
1. Create an `.env` file at the root of the project containing the env variables for dev. The DB should work with the following
```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=footballratings_dev
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```
2. Run `docker compose up` to start the dev DB.
3. Run `mix setup`. The command will:
    1. Fetch all the (Elixir) dependencies.
    2. Setup the DB (create + migrations + seeds)
    3. Fetch the assets (Tailwind + ESbuild)
4. Install the other JS dependencies via `cd assets && npm install`.
5. Run `mix test`.

## Start the project
- `mix phx.server` for non-interactive mode.
- `iex -S mix phx.server` for interactive mode. Launches the app + an IEx shell.
- The app will be available at [localhost:4000](http://localhost:4000).
