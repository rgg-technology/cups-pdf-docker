#!/bin/bash

service dbus restart
service avahi-daemon start
service smbd start
service cups start

# Wait for CUPS to start up
echo "Waiting for CUPS to start..."
while ! curl -s http://localhost:631 >/dev/null; do
  sleep 1
done

# Configure the virtual PDF printer
echo "Configuring the virtual PDF printer..."
lpadmin -p $APP_PRINTER1_NAME -v cups-pdf:/ -E -m lsb/usr/cups-pdf/CUPS-PDF_noopt.ppd -o printer-is-shared=true -D "$APP_PRINTER1_NAME_FULL"

# Keep the container running
echo "CUPS is up and running. Keeping container alive..."

# Print cups error output
tail -f /var/log/cups/error_log