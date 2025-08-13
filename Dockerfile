# Start from the official Nginx image
FROM nginx:latest

# Copy custom index.html into the container
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

