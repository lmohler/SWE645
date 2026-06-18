# Dockerfile
# Author: Lucas Mohler
# Purpose: Builds a Docker image for the SWE 645 web application by copying the
#          HTML pages and images into an nginx:alpine container exposed on port 80.

FROM nginx:alpine
COPY index.html error.html survey.html /usr/share/nginx/html/
COPY images/ /usr/share/nginx/html/images/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
