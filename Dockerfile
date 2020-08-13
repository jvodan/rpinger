From ubuntu

RUN	apt-get -y update &&\
	apt-get install -y ruby-dev \
					   zlib1g \
					   git \
					   zlib1g-dev \
					   g++ \
	                   gcc \
	                   make \
	                   libc6-dev \
	                   patch \
	                   libreadline6-dev \
	                   autoconf \
	                   libgdbm-dev \
	                   libncurses5-dev \
	                   automake \
	                   libtool \
					   ruby-eventmachine &&\
   gem update --system &&\
   gem update &&\					 
   gem install bundler &&\  				   
   gem install bundle &&\
   gem install rake rainbows net-ping sinatra yajl ;\
   mkdir -p /opt/&&\
   cd /opt &&\
   git clone https://github.com/jvodan/rpinger.git /opt/app
   # gem install rake rainbows eventmachine net-ping sinatra yajl &&\
 CMD 'sleep 600'
   
   
   

