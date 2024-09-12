#!/bin/bash

service dbus restart
service avahi-daemon start
service smbd start

sleep 3

# Start the CUPS service in the background
#cupsd -f &
service cups start

# Wait for CUPS to start up
echo "Waiting for CUPS to start..."
while ! curl -s http://localhost:631 >/dev/null; do
  sleep 1
done

# Configure the virtual PDF printer
echo "Configuring the virtual PDF printer..."
lpadmin -p printprint -v cups-pdf:/ -E -m lsb/usr/cups-pdf/CUPS-PDF_noopt.ppd -o printer-is-shared=true -D "The real printprint"

# Keep the container running
echo "CUPS is up and running. Keeping container alive..."

tail -f /var/log/cups/error_log