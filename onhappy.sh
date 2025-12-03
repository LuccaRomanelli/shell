hyprctl dispatch workspace 3
sleep 0.5

uwsm app -- "$TERMINAL" --command zsh -ic 'cd ~/onhappy/onhappy-frontend && nvim .; exec zsh' &
sleep 0.8

hyprctl dispatch workspace 4
sleep 0.5

uwsm app -- "$TERMINAL" --command zsh -ic 'cd ~/onhappy/onhappy-backend && nvim .; exec zsh' &
sleep 0.8

hyprctl dispatch workspace 5
sleep 0.5

uwsm app -- "$TERMINAL" -e zsh -ic 'cd ~/onhappy/onhappy-backend/ && docker ps -q | xargs -r docker stop && docker start $(docker ps -aq -f "name=^onhappy-") && npm run dev; exec zsh' &
sleep 0.8

uwsm app -- "$TERMINAL" -e zsh -ic 'cd ~/onhappy/onhappy-frontend/ && npm run dev; exec zsh' &
sleep 0.8

hyprctl dispatch workspace 2
