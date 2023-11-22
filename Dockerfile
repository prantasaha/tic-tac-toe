# Stage 1: Build stage
FROM node:14 as builder

WORKDIR /app

# Copy package.json and package-lock.json separately to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the application
RUN npm run first

# Stage 2: Production-ready image
FROM node:14-alpine

WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/socket-client /app/socket-client
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/*.js /app/

# Expose the port your app runs on
EXPOSE 3000
EXPOSE 4001

# Start the application
CMD ["npm", "run", "start"]
