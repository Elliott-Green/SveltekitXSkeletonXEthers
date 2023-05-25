# Our Node base image
FROM node:18.13-alpine as build

# Create a directory for the Sveltekit client
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package.json package-lock.json svelte.config.js ./

# Install dependencies
RUN npm i -g pnpm
RUN pnpm i

# Copy the rest of the client files
WORKDIR /usr/src/app
COPY . .

# Build the client
RUN npm run build

ENV BUILD_DATE = `date -u +"%Y-%m-%dT%H:%M:%SZ"`

# Expose the port that the client will be served on
EXPOSE 5173

# Start the client from the build
CMD [ "npm", "run", "dev" ]
