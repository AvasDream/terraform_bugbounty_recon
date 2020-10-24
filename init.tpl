#!/bin/bash

# Conveninence
echo "alias docker='sudo docker'" >> /home/ubuntu/.bashrc
# Install Docker
apt update 
apt install docker.io git -y 
systemctl enable docker 


# Install tmux 
apt install tmux -y
cat << EOF > /home/ubuntu/.tmux.conf
#set prefix 
set -g prefix C-a 
bind C-a send-prefix 
unbind C-b 
set -g history-limit 100000 
set -g allow-rename off 
bind-key j command-prompt -p "Join pan from:" "join-pane -s '%%'" 
bind-key s command-prompt -p "Send pane to:" "joian-pane -t '%%'" 
set-window-option -g mode-keys vi 
run-shell /opt/tmux-logging/logging.tmux
EOF

# Install docker container
apt install python3-pip
pip3 install telegram

git clone https://github.com/AvasDream/docker-httpx-scan.git
cd docker-httpx-scan
echo ${recon_domains} > domains.txt