hyprctl dispatch workspace 3
sleep 0.5

uwsm app -- "$TERMINAL" -e zsh -c 'nvim ~/onhappy/onhappy-frontend/' &
sleep 0.8

hyprctl dispatch workspace 4
sleep 0.5

uwsm app -- "$TERMINAL" -e zsh -c 'nvim ~/onhappy/onhappy-backend/' &
sleep 0.8

hyprctl dispatch workspace 5
sleep 0.5

uwsm app -- "$TERMINAL" -e zsh -c 'cd ~/onhappy/onhappy-backend/ && docker ps -q | xargs -r docker stop && docker-compose up -d && sdev; exec zsh' &
sleep 0.8

uwsm app -- "$TERMINAL" -e zsh -c 'cd ~/onhappy/onhappy-frontend/ && npm run dev; exec zsh' &
sleep 0.8

hyprctl dispatch workspace 2
