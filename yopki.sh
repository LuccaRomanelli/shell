hyprctl dispatch workspace 3
sleep 0.5

uwsm app -- "$TERMINAL" -e tmux new-session -A -s yopki-front 'cd ~/yopki/trip-planner-web && nvim .; exec zsh' &
sleep 0.8

hyprctl dispatch workspace 4
sleep 0.5

uwsm app -- "$TERMINAL" -e tmux new-session -A -s yopki-back 'cd ~/yopki/trip-planner-backend && nvim .; exec zsh' &
sleep 0.8

hyprctl dispatch workspace 5
sleep 0.5

uwsm app -- "$TERMINAL" -e zsh -c 'cd ~/yopki/trip-planner-backend && docker ps -q | xargs -r docker stop && docker start $(docker ps -aq -f "name=^trip-") && pnpm run dev; exec zsh' &

uwsm app -- "$TERMINAL" -e zsh -c 'cd ~/yopki/trip-planner-web/ && npm run dev; exec zsh' &

uwsm app -- "$TERMINAL" -e zsh -c 'cd ~/yopki/trip-planner-web/packages/core/ && npm run build:watch; exec zsh' &
