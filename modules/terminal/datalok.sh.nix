''
  #!/usr/bin/env bash

  tmux new-session -d -c $HOME/Projects/datalok-backend/ -s datalok

  ############################
  # FRONTEND                 #
  ############################
  FRONTEND_DIR=$HOME/Projects/datalok-backend/frontend

  tmux rename-window -t datalok:0 'frontend'

  tmux send-keys -t datalok:0 'cd frontend' C-m
  tmux send-keys -t datalok:0 'nix-shell -p nodejs' C-m
  tmux send-keys -t datalok:0 'vim src/main.ts' C-m

  tmux split-window -c $FRONTEND_DIR -l "15%" -t datalok:0.0 -v
  tmux send-keys -t datalok:0.1 'nix-shell -p nodejs' C-m
  tmux send-keys -t datalok:0.1 'npm run start' C-m

  ############################
  # BACKEND                  #
  ############################
  BACKEND_DIR=$HOME/Projects/datalok-backend/backend

  tmux new-window -c $BACKEND_DIR -t datalok:1 -n 'backend'

  tmux send-keys -t datalok:1 'nix-shell -p nodejs' C-m
  tmux send-keys -t datalok:1 'vim src/main.ts' C-m

  tmux split-window -c $BACKEND_DIR -l "15%" -t datalok:1.0 -v
  tmux send-keys -t datalok:1.1 'nix-shell -p nodejs' C-m
  tmux send-keys -t datalok:1.1 'dc -f docker/docker-compose.yml up -d' C-m
  tmux send-keys -t datalok:1.1 'npm run start:dev' C-m

  tmux attach-session -t datalok
''
