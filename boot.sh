set -e

echo "Postgres booting..."
while ! nc -z db 5432; 
do
    sleep 0.8
done

echo "Postgres is ready!"

mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
mix phx.server
