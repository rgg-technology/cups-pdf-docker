#!/bin/bash
avahi-daemon --no-rlimits &
# Start the CUPS service in the background
cupsd -f &

#echo "IP configuration..."
#ifconfig

# Wait for CUPS to start up
echo "Waiting for CUPS to start..."
while ! curl -s http://localhost:631 >/dev/null; do
  sleep 1
done

# Configure the virtual PDF printer
echo "Configuring the virtual PDF printer..."
lpadmin -p Virtual_PDF_Printer -v cups-pdf:/ -E -m drv:///sample.drv/generic.ppd -o printer-is-shared=true

# Keep the container running
echo "CUPS is up and running. Keeping container alive..."
tail -f /var/log/cups/error_log