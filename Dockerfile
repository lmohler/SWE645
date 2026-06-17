FROM nginx:alpine
COPY index.html error.html survey.html /usr/share/nginx/html/
COPY images/ /usr/share/nginx/html/images/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
