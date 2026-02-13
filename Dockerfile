FROM node:20 AS contracts

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8545
CMD ["npx", "hardhat", "node"]

FROM node:20 AS frontend
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend .
EXPOSE 3000
CMD ["npm", "run", "dev"]
