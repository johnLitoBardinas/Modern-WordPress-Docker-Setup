FROM nginx:stable-alpine

# HOST -> CONTAINER
ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf
ADD ./nginx/certs /etc/nginx/certs/self-signed