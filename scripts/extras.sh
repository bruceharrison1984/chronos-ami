#!/usr/bin/bash
set -e

echo -e "\n-= Install Google Authentication =-"
echo -e "-= (This needs to be manually setup once you start a server with this image) =-"
sudo yum -y install google-authenticator qrencode

echo -e "\n-= Setup MOTD =-"
sudo sh -c 'cat <<EOF > /etc/update-motd.d/30-banner
#!/usr/bin/bash
echo "
  ______ _____ ___                                                              
 |  ____/ ____|__ \                                                             
 | |__ | |       ) |                                                            
 |  __|| |      / /  Amazon Linux 2 AMI (ARM)                                                          
 | |___| |____ / /_                                                             
 |______\_____|____|_   ____  _   _  ____   _____             
  / ____| |  | |  __ \ / __ \| \ | |/ __ \ / ____|
 | |    | |__| | |__) | |  | |  \| | |  | | (___  
 | |    |  __  |  _  /| |  | |     | |  | |\___ \ 
 | |____| |  | | | \ \| |__| | |\  | |__| |____) |
  \_____|_|  |_|_|  \_\\____/|_| \_|\____/|_____/ 
                      * EXPERIMENTAL -USE AT OWN RISK- *
              * https://github.com/bruceharrison1984/chronos-ami *
- Next steps:
  - su to the username(${USERNAME}) you chose when creating this AMI
  - Initialize the chain-maind client
    - $> init-sentry.sh
  - You must download and install the chain QuickSync files
    - download-quicksync.sh can be used for this
    - https://quicksync.io/networks/crypto.html
    - Extract files into /chronos/node/**
    - Trying to start the Sentry without this (at block 0) will fail
    - Once QuickSync is done, sudo systemctl enable chronos-sentry.service
  - Setup Google Authenticator login for added security:
    - https://wiki.archlinux.org/title/Google_Authenticator"
EOF'
sudo /usr/bin/systemctl restart update-motd