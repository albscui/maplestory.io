FROM node:argon

# Create app directory
RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/lib
RUN mkdir -p /usr/src/app/cert
RUN mkdir -p /usr/src/less
RUN mkdir -p /usr/src/app/public
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install --production

# Bundle app source
COPY less /usr/src/app/less
COPY lib /usr/src/app/lib/
COPY public /usr/src/app/public

RUN mkdir /opt/teleport && \
 cd /opt/teleport && \
 wget https://github.com/gravitational/teleport/releases/download/v1.1.0/teleport-v1.1.0-linux-amd64-bin.tar.gz && \
 tar -zxvf teleport-v1.1.0-linux-amd64-bin.tar.gz && \
 make install

COPY teleport.conf /etc/init/teleport.conf

# Verify teleport works / starts up.
RUN start teleport && ps -ax | grep teleport

CMD [ "npm", "start" ]
