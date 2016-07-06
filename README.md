## WebPagetest Private Instance Version 2.19

This is the server component of a private instance of WebPagetest.  You will also need to set up agents on test servers.  

References:
* [WPT Private Instance GitHub Repository](https://github.com/WPO-Foundation/webpagetest/releases/tag/WebPageTest-2.19)
* [Velocity NYC 2014 WebPagetest Private Instances - Part 1](https://www.youtube.com/watch?v=enVpzzlhTzE)
* [Velocity NYC 2014 WebPagetest Private Instances - Part 2](https://www.youtube.com/watch?v=loAGkDTMjtY)

You will likely want to copy /var/www/html/settings out of your container and customize, then mount into the container from either host directory or data container.

#### Run example:

```
docker run -d --name webpagetest -p 80:80 \
	-v /local/webpagetest/settings:/var/www/html/settings \
	-v /local/webpagetest/tmp:/var/www/html/tmp \
	-v /local/webpagetest/dat:/var/www/html/dat \
	-v /local/webpagetest/work/jobs:/var/www/html/work/jobs \
	-v /local/webpagetest/work/video:/var/www/html/work/video \
	-v /local/webpagetest/results:/var/www/html/results \
	-v /local/webpagetest/logs:/var/www/html/logs \
	-v /local/webpagetest/httpd_logs:/var/log/httpd \
	guyton/webpagetest
```

