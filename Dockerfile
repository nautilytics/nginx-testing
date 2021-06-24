FROM node:14.16.1-alpine3.11 as builder

WORKDIR /app
COPY . .

RUN yarn install
RUN yarn build

FROM nginx
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

RUN rm /etc/nginx/conf.d/default.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Copy static assets from builder stage
COPY --from=builder /app/build .

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
