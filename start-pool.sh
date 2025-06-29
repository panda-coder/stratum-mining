#!/bin/bash

SESSION_NAME="mining-pool"
DELAY=10  # seconds

print_starting() {
    local service_name="$1"
    echo -e "\033[1;37mStarting \033[1;32m${service_name}...\033[0m"
}

print_starting "template-provider"
tmux new-session -d -s "$SESSION_NAME" -n "templat-provider"  'docker-compose up template-provider'

sleep $DELAY
print_starting "jds"
tmux new-window -t "$SESSION_NAME" -n "jds" 'docker-compose up jds'

sleep $DELAY
print_starting "pool"
tmux new-window -t "$SESSION_NAME" -n "pool"  'docker-compose up pool' 

sleep $DELAY
print_starting "jdc"
tmux new-window -t "$SESSION_NAME" -n "jdc" 'docker-compose up jdc'


sleep $DELAY
print_starting "mining-device"
tmux new-window -t "$SESSION_NAME" -n "mining-device" 'docker-compose up mining-device'

sleep $DELAY
print_starting "btc-explorer"
tmux new-window -t "$SESSION_NAME" -n "btc-explorer" 'docker-compose up btc-explorer'





# Optional: attach to the session
tmux attach-session -t "$SESSION_NAME"
