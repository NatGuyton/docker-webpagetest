FROM guyton/centos6
# epel-release required for ExifTool
RUN yum install -y epel-release; yum install -y wget tar zlib php php-gd perl-Image-ExifTool httpd php-pecl-apc perl ; yum clean all
RUN /usr/bin/perl -p -i -e 's/#ServerName www.example.com:80/ServerName webpagetest/' /etc/httpd/conf/httpd.conf

# Get WebPageTest code
RUN cd /tmp; wget -q https://github.com/WPO-Foundation/webpagetest/archive/WebPageTest-2.19.tar.gz ; cd /opt; tar zxf /tmp/WebPageTest-2.19.tar.gz ; \rm /tmp/WebPageTest-2.19.tar.gz ; mv webpagetest-WebPageTest-2.19/www/* /var/www/html/; \rm -fr webpagetest-WebPageTest-2.19

RUN cd /var/www/html ; mkdir -p tmp dat results work/jobs work/video logs; chown -R apache:apache tmp dat results work/jobs work/video logs 
RUN cd /var/www/html/settings; for i in locations settings; do cp ${i}.ini.sample ${i}.ini; done; perl -p -i -e 's/enableVideo=1/enableVideo=0/' settings.ini; 
# Put Native speed at top
RUN cd /var/www/html/settings; linenum=`grep -n '\[Native\]' connectivity.ini.sample|cut -f1 -d:`; linenumoneback=`expr $linenum - 1`; tail -n +$linenum connectivity.ini.sample > connectivity.ini ; echo "" >> connectivity.ini; head -$linenumoneback connectivity.ini.sample >> connectivity.ini

# fix php settings to webpagetest needs
RUN /usr/bin/perl -p -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /etc/php.ini ; /usr/bin/perl -p -i -e 's/post_max_size = 8M/post_max_size = 10M/' /etc/php.ini ; /usr/bin/perl -p -i -e 's/memory_limit = 128M/memory_limit = 256M/' /etc/php.ini 

EXPOSE 80 443
VOLUME /var/www/html/tmp /var/www/html/dat /var/www/html/work/jobs /var/www/html/work/video /var/www/html/results /var/www/html/logs /var/log/httpd
CMD /usr/sbin/httpd -DFOREGROUND

