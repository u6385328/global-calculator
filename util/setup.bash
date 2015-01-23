#!/bin/bash

# The first need to check we are running on a 64bit x86 machine
# Ruby 2.0 only seems to be built for 64bit 
# and I've only tested on x86
if [ "$(uname -m)" !=  'x86_64' ]; then
  echo "This script is only tested on 64 bit x86 machines. (your system is reported as $(uname -m))"
  exit 1
fi

# The next thing we need to do is check we are running the right version of Ubuntu
. /etc/lsb-release # This loads variables which contain the Ubuntu version
if [ "$DISTRIB_ID" != 'Ubuntu' ] || [ "$DISTRIB_RELEASE" != '14.04' ]; then
  echo "This script is only tested with Ubuntu 14.04. (your system is reported as $DISTRIB_ID $DISTRIB_RELEASE)"
  exit 1
fi

sudo apt-add-repository ppa:brightbox/ruby-ng # For ruby
sudo apt-get update
sudo apt-get install -y ruby2.2 ruby2.2-dev
sudo apt-get install -y git # For version control
sudo apt-get install -y build-essential # For compiling the C code
sudo apt-get install -y libxml2-dev # For compiling Ruby and Ox, an XML processing library needed to translate Excel into C
sudo apt-get install -y libxslt-dev # For compiling Ruby and Ox, an XML processing library needed to translate Excel into C
sudo apt-get install -y zip # Dunno why?
sudo apt-get install -y unzip # Dunno why?
sudo apt-get install -y libcurl4-openssl-dev # Dunno why?
sudo apt-get install -y libssl-dev # Dunno why?
sudo apt-get install ruby-switch # Allows us to change the default ruby on the system
sudo ruby-switch --set ruby2.2 # Make version 2.1 the default ruby
sudo gem pristine --all --only-executables # Attempt to ensure that old commands point to the new ruby
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7 # The source for the Phusion ubuntu packages
sudo apt-get install -y apt-transport-https ca-certificates # So the new source can be used
sudo add-apt-repository -y 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' # The source for the Phusion packages
sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
sudo apt-get update
sudo apt-get install -y nginx-extras passenger # The web server
sudo gem install bundler --no-ri --no-rdoc # Install the ruby package manager

cd /home/ubuntu

cat <<EndConf > ngnix.conf
server {
  listen 80 default_server;
  listen [::]:80 default_server ipv6only=on;
  root /home/ubuntu/global-calculator/public;

  passenger_enabled on;
  passenger_ruby /usr/bin/ruby2.2;
}
EndConf

sudo cp /home/ubnutu/ngnix.conf /etc/nginx/sites-available/2050.conf
sudo ln -s /etc/nginx/sites-available/2050.conf /etc/nginx/sites-enabled/2050.conf
sudo unlink /etc/nginx/sites-enabled/default
sudo sed --in-place "s/# passenger_root/passenger_root/g" /etc/nginx/nginx.conf
sudo nginx -t
sudo service nginx restart

cd /home/ubuntu
git clone https://github.com/decc/global-calculator.git # Download the code
cd global-calculator/
bundle # Install the ruby dependencies

cd model/global_2050_model/
rake # Compile the C version
