hyprctl dispatch workspace 1
sleep 0.5

omarchy-launch-webapp 'https://apps.abacus.ai/chatllm/' &
sleep 1.2

hyprctl dispatch workspace 2
sleep 0.5

omarchy-launch-browser &
sleep 1.2

hyprctl dispatch workspace 6
sleep 1.2

hyprctl dispatch layoutmsg "master"
sleep 0.5
hyprctl dispatch layoutmsg "orientationleft"
sleep 0.5

omarchy-launch-webapp WhatsApp 'https://web.whatsapp.com/' &
sleep 0.8

omarchy-launch-webapp ClickUp 'https://app.clickup.com/' &
sleep 0.8

omarchy-launch-webapp 'Google Chat' &
sleep 0.8

hyprctl dispatch layoutmsg "magic"
sleep 0.5

hyprctl dispatch workspace 7
sleep 0.5

omarchy-launch-webapp Jira
sleep 0.5
omarchy-launch-webapp ClickUp
sleep 0.8
omarchy-launch-webapp \
  'https://docs.google.com/spreadsheets/d/1eBNz9AqBo1jv5pLwOGyTwKSk6K328TTa37g5Dt19fwI/edit?pli=1&gid=256386999#gid=256386999' &
sleep 1.2

hyprctl dispatch workspace 8
sleep 0.5

omarchy-launch-webapp TodoIst &
sleep 1.0

hyprctl dispatch split:right
sleep 0.2

omarchy-launch-webapp 'Google Calendar' &
sleep 1.0

hyprctl dispatch cyclenext
sleep 0.2
hyprctl dispatch split:bottom
sleep 0.2

omarchy-launch-webapp 'Google Calendar' &
sleep 1.0

hyprctl dispatch cyclenext
sleep 0.2
hyprctl dispatch split:bottom
sleep 0.2

omarchy-launch-webapp 'Google Calendar' &
sleep 1.0

hyprctl dispatch layoutmsg "magic"
sleep 0.2

hyprctl dispatch workspace 9
sleep 0.5

omarchy-launch-webapp YouTubeMusic 'https://music.youtube.com/' &
sleep 0.8

hyprctl dispatch workspace 2
