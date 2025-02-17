FROM nginx:latest

# Copy all files from the build context to the Nginx HTML directory
COPY . /usr/share/nginx/html/

# Expose port 80 for the web server
EXPOSE 80
