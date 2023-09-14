#!/bin/bash

# Define the service unit file path for the backend
BACKEND_SERVICE_FILE="/etc/systemd/system/backend.service"

# Determine the current username using whoami
USERNAME=$(whoami)

echo $USERNAME

# Define the working directory for the backend
BACKEND_DIR="/home/vagrant/Demo_Application"
BACKEND_START_COMMAND="python3 manage.py runserver 0.0.0.0:8000"

# Check if the service file already exists for the backend
if [ -f "$BACKEND_SERVICE_FILE" ]; then
    echo "Service file '$BACKEND_SERVICE_FILE' already exists. Exiting..."
    exit 1
fi

# Create the systemd service unit file for the backend
cat <<EOF | sudo tee "$BACKEND_SERVICE_FILE" > /dev/null
[Unit]
Description=Backend Service
After=network.target

[Service]
User=$USERNAME
WorkingDirectory=$BACKEND_DIR
ExecStart=$BACKEND_START_COMMAND
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to make it aware of the new service
sudo systemctl daemon-reload

# Enable and start the backend service
sudo systemctl enable backend.service
sudo systemctl start backend.service

# Check the status of the backend service
SERVICE_STATUS=$(sudo systemctl is-active backend.service)

if [ "$SERVICE_STATUS" == "active" ]; then
    echo "backend service is now active and running."
else
    echo "Failed to start backend service. Please check the configuration and try again."
fi

sudo journalctl -u backend.service