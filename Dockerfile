# build stage
FROM node:lts-alpine as build-stage
RUN apk add --update python3 make g++ && rm -rf /var/cache/apk/*
WORKDIR /app
COPY ./website/package*.json .
RUN npm install
COPY ./website .
RUN ["npm", "run", "build"]


# production stage
FROM nginxinc/nginx-unprivileged:stable-alpine as production-stage
COPY --from=build-stage /app/public /usr/share/nginx/html
EXPOSE 8080
USER 101
CMD ["nginx", "-g", "daemon off;"]
