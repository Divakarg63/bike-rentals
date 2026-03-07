FROM node:18-alpine

WORKDIR /app

COPY . .

EXPOSE 1337

CMD ["node","server.js"]
