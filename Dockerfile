FROM nginx:latest
COPY . .
COPY index.html /usr/share/nginx/html/index.html
COPY index.js /usr/share/nginx/html/index.js
COPY style.css /usr/share/nginx/html/style.css
RUN touch /usr/share/nginx/html/.DS_Store
EXPOSE 80
