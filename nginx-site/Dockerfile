# Use a nginx Docker image
FROM nginx
# Copy the static HTMLs to the nginx directory
COPY public /usr/share/nginx/html
# Copy the nginx configuration template to the nginx config directory
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
# Substitute the environment variables and generate the final config
CMD exec nginx -g 'daemon off;'

