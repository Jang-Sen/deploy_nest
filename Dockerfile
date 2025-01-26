###################
# BUILD FOR LOCAL DEVELOPMENT
###################

FROM node:18-alpine As development

# Create app directory
WORKDIR /usr/src/app

# Set proper ownership for the directory
RUN chown -R node:node /usr/src/app

# Copy application dependency manifests
COPY package*.json ./

# Install app dependencies
RUN npm install --force

# Copy application source code
COPY . .

# Ensure the node user has ownership of the application files
RUN chown -R node:node /usr/src/app

# Use the node user
USER node

###################
# BUILD FOR PRODUCTION
###################

FROM node:18-alpine As build

WORKDIR /usr/src/app

COPY --from=development /usr/src/app ./

# Build the application
RUN npm run build

# Set NODE_ENV to production
ENV NODE_ENV production

RUN npm ci --only=production && npm cache clean --force

USER node