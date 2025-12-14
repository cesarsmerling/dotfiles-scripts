#!/bin/sh

# Get the directory where this script is located (project root)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Navigate to the directory
cd "$SCRIPT_DIR" || exit

# Session name
SESSION="dots"

# Check if session already exists
tmux has-session -t $SESSION 2>/dev/null

if [ $? != 0 ]; then
  # Create new session with first window named "editor"
  tmux new-session -d -s $SESSION -n editor -c "$SCRIPT_DIR"

  # Split window horizontally (left-right) with 65-35 split
  # -p 35 means the new pane (right side) gets 35% of the space
  # Left pane (0) = 65%, Right pane (1) = 35%
  tmux split-window -h -t $SESSION:1 -p 35 -c "$SCRIPT_DIR"

  # Send commands to panes
  # Pane 0 (left, larger): nvim
  # Pane 1 (right, smaller): claude
  tmux send-keys -t $SESSION:1.0 'nvim .' C-m

  # Small delay to ensure shell is ready before sending claude command
  sleep 0.5
  tmux send-keys -t $SESSION:1.1 'claude' C-m

  # Create second window for lazygit
  tmux new-window -t $SESSION:2 -n lazygit -c "$SCRIPT_DIR"
  tmux send-keys -t $SESSION:2 'lazygit' C-m

  # Create third window for terminal
  tmux new-window -t $SESSION:3 -n terminal -c "$SCRIPT_DIR"

  # Select the first window to start
  tmux select-window -t $SESSION:1
fi

# Attach to session
tmux attach-session -t $SESSION
