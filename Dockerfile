FROM ubuntu:16.04

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y git vim
RUN apt-get install -y libtool automake libssl-dev gengetopt libjson-c-dev
RUN apt-get install -y checkinstall
RUN apt-get install -y unzip zip wget 

WORKDIR /tmp

# wget tagged version from git
RUN wget -O coova-chilli-1.4.zip  https://github.com/coova/coova-chilli/archive/1.4.zip
#RUN git clone https://github.com/coova/coova-chilli.git

RUN unzip coova-chilli-1.4.zip -d /tmp/
#RUN tar -xvf coova-chilli-src-1.4.tar -C /tmp/coova-chilli

WORKDIR /tmp/coova-chilli-1.4

RUN sh bootstrap

# https://github.com/coova/coova-chilli/blob/master/debian/rules
RUN ./configure --prefix=/usr \
    --libdir=/usr/lib64 \
    --sysconfdir=/etc \
    --mandir=\$${prefix}/share/man --infodir=\$${prefix}/share/info \
    --localstatedir=/var \
    --with-openssl \
    --enable-json \
    --enable-libjson \
    --enable-sessionstate \
    --enable-sessionid \
    --enable-largelimits \
    --enable-debug2 \
    --enable-multilan \
    --enable-layer3 \
    --enable-proxyvsa  \
    --enable-chilliredir \
    --enable-chilliproxy \
    --enable-chilliscript \
    --enable-chilliradsec \
    --enable-eapol \
    --enable-uamdomainfile \
    --enable-redirdnsreq \
    --enable-multiroute \
    --enable-extadmvsa \
    --with-poll \
    --enable-binstatusfile \
    --enable-modules \
    --enable-ipwhitelist 
	
	#--enable-miniportal
        

RUN make
RUN checkinstall -y --install=no --pkgversion=1.4
RUN make clean

VOLUME [ "/target" ]

ENTRYPOINT [ "cp","/tmp/coova-chilli-1.4/coova-chilli_1.4-1_amd64.deb","/target" ]
