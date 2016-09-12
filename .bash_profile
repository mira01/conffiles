### ssh socket for tmux
if [ -f ~/.bashrc ]; then
       source ~/.bashrc
   fi
echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > ~/.ssh/auth_sock
