hyprctl dispatch workspace 3
sleep 0.5

uwsm app -- "$TERMINAL" -e zsh -c 'nvim ~/yopki/trip-planner-web' &
sleep 0.8

hyprctl dispatch workspace 4
sleep 0.5

uwsm app -- "$TERMINAL" -e zsh -c 'nvim ~/yopki/trip-planner-backend' &
sleep 0.8

hyprctl dispatch workspace 5
sleep 0.5

uwsm app -- "$TERMINAL" -e zsh -c '
  cd ~/yopki/trip-planner-backend &&

  docker ps -q | xargs -r docker stop &&

  docker run -d --name trip-planner-bff-nats \
    -p 4222:4222 -p 8222:8222 -p 6222:6222 \
    nats -js -m 8222 &&

  docker compose up -d &&

  pnpm run dev &&

  exec zsh
' &
