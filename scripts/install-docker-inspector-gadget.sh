# https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo docker run -d -p 80:80 jelledruyts/inspectorgadget