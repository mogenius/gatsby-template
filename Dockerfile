FROM node:gallium-alpine3.14 as builder

WORKDIR /app

COPY package.json .
RUN npm install
COPY . .
RUN ["npm", "run", "build"]

FROM nginxinc/nginx-unprivileged:stable-alpine as production-stage
COPY --from=builder /app/public /usr/share/nginx/html
EXPOSE 8080
USER 101
CMD ["nginx", "-g", "daemon off;"]
