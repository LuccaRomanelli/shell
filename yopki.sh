#!/usr/bin/env bash

# workspace 3: frontend web no nvim
hyprctl dispatch workspace 3
sleep 0.5

uwsm app -- "$TERMINAL" --command zsh -ic 'cd ~/yopki/trip-planner-web && nvim .; exec zsh' &
sleep 0.8

# workspace 4: backend no nvim
hyprctl dispatch workspace 4
sleep 0.5

uwsm app -- "$TERMINAL" --command zsh -ic 'cd ~/yopki/trip-planner-backend && nvim .; exec zsh' &
sleep 0.8

# workspace 5: docker + backend dev + frontend dev + core build:watch
hyprctl dispatch workspace 5
sleep 0.5

uwsm app -- "$TERMINAL" --command zsh -ic 'cd ~/yopki/trip-planner-backend && docker ps -q | xargs -r docker stop && docker start $(docker ps -aq -f "name=^trip-") && pnpm run dev; zsh' &

uwsm app -- "$TERMINAL" --command zsh -ic 'cd ~/yopki/trip-planner-web/ && npm run dev; zsh' &

uwsm app -- "$TERMINAL" --command zsh -ic 'cd ~/yopki/trip-planner-web/packages/core/ && npm run build:watch; zsh' &
