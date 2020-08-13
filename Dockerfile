From ubuntu

RUN	apt-get -y update &&\
	apt-get install -y ruby-dev \
					   zlib1g \
					   zlib1g-dev &&\
   gem update --system &&\
   gem update &&\					 
   gem install bundler &&\  				   
   gem install bundle &&\
   gem install rake rainbows eventmachine net/ping sinatra yajl ffi_yajl &&\
   mkdir -p /opt/&&\
   cd /opt &&\
   git clone https://github.com/jvodan/rpinger.git /opt/app
   
 CMD 'sleep 600'
   
   
   

