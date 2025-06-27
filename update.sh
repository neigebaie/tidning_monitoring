#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Start logging
exec > >(tee -a update.log) 2>&1

echo -e "${YELLOW}Update process started at: $(date +"%Y-%m-%d %T")${NC}"

echo -e "${GREEN}Pulling latest changes from GitHub...${NC}"
git pull

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully pulled from GitHub.${NC}"
else
    echo -e "${RED}Failed to pull from GitHub. Check the log above for errors.${NC}"
    exit 1
fi

echo -e "${GREEN}Building and (re)starting Docker containers...${NC}"
sudo docker compose -f docker-compose.yml up --build -d

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Docker containers are up and running.${NC}"
else
    echo -e "${RED}Failed to start Docker containers. Check the log above for errors.${NC}"
    exit 1
fi

# echo -e "${GREEN}Pruning unused Docker images...${NC}"
# sudo docker image prune -f

echo -e "${GREEN}Update process completed successfully!${NC}"
