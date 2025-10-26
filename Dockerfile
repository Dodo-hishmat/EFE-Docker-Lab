# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies inside the container
# This fulfills the 'npm install' requirement 
RUN npm install

# Bundle app source
COPY . .

# Make port 3000 available to the world outside this container
# This fulfills the 'Expose the correct port' requirement 
EXPOSE 3000

# Define the command to run the app
# This fulfills the 'Run the application using npm start' requirement 
CMD [ "npm", "start" ]
