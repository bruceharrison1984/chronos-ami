#!/bin/bash
set -e

echo -e "\n-= Install Google Authentication =-"
echo -e "-= (This needs to be manually setup once you start a server with this image) =-"
sudo yum -y install google-authenticator qrencode

echo -e "\n-= Setup MOTD =-"
sudo sh -c 'cat <<EOF > /etc/update-motd.d/30-banner
#!/bin/bash
echo "
  ______ _____ ___                                                              
 |  ____/ ____|__ \                                                             
 | |__ | |       ) |                                                            
 |  __|| |      / /  Amazon Linux 2 AMI                                                           
 | |___| |____ / /_                                                             
 |______\_____|____|___  _____          _   _  ____                __  __ _____ 
  / ____|   /\   |  __ \|  __ \   /\   | \ | |/ __ \         /\   |  \/  |_   _|
 | |       /  \  | |__) | |  | | /  \  |  \| | |  | |______ /  \  | \  / | | |  
 | |      / /\ \ |  _  /| |  | |/ /\ \ |     | |  | |______/ /\ \ | |\/| | | |  
 | |____ / ____ \| | \ \| |__| / ____ \| |\  | |__| |     / ____ \| |  | |_| |_ 
  \_____/_/    \_\_|  \_\_____/_/    \_\_| \_|\____/     /_/    \_\_|  |_|_____|
                      * EXPERIMENTAL -USE AT OWN RISK- *
              * https://github.com/bruceharrison1984/cardano-ami *"
EOF'
sudo /usr/bin/systemctl --quiet restart update-motd