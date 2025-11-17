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

uwsm app -- "$TERMINAL" -e zsh -c 'cd ~/yopki/trip-planner-backend && docker ps -q | xargs -r docker stop && bash start-nats.sh && docker compose up -d && pnpm run dev && exec zsh' &

uwsm app -- "$TERMINAL" -e zsh -c 'cd ~/yopki/trip-planner-web/ && npm run dev && exec zsh' &
