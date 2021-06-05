FROM jenkins/jenkins:latest
USER root
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates \
    curl gnupg2 software-properties-common 
RUN curl -fsSL https://download.docker.com/linux/debian/gpg \
    | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"
RUN apt-get update -qq \
    && apt-get install docker-ce=17.12.1~ce-0~debian -y

##########################################################
# Run inside of container then turn container to image
##########################################################
# sudo apt update && sudo apt upgrade 
# sudo apt install wget build-essential libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev  
# wget https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz 
# tar xzf Python-3.9.4.tgz 
# cd Python-3.9.5
# ./configure --enable-optimizations 
# make altinstall 
# echo 'alias python="python3.9"' >> ~/.bashrc
# echo 'alias pip="pip3.9"' >> ~/.bashrc
# . ~/.bashrc
# pip install --upgrade pip
# pip install pytest