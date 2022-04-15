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
 |  __|| |      / /  Amazon Linux 2 AMI                                                           
 | |___| |____ / /_                                                             
 |______\_____|____|_   ____  _   _  ____   _____             
  / ____| |  | |  __ \ / __ \| \ | |/ __ \ / ____|
 | |    | |__| | |__) | |  | |  \| | |  | | (___  
 | |    |  __  |  _  /| |  | | . ` | |  | |\___ \ 
 | |____| |  | | | \ \| |__| | |\  | |__| |____) |
  \_____|_|  |_|_|  \_\\____/|_| \_|\____/|_____/ 
                      * EXPERIMENTAL -USE AT OWN RISK- *
              * https://github.com/bruceharrison1984/cardano-ami *
- All Chronos services are disabled by default
  - You must enable them to start them
    - sudo systemctl enable chronos-relay.service
  - You must manually start them
    - sudo systemctl start chronos-relay.service"
EOF'
sudo /usr/bin/systemctl --quiet restart update-motd