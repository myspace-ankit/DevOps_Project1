FROM devopsedu/webapp
# This image was asked to be used in the project. This image was built on apache image.

COPY  website/ /var/www/html

RUN rm /var/www/html/index.html

CMD ["apachectl", "-D", "FOREGROUND"]
