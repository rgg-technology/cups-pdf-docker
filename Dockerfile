FROM ubuntu:22.04

ARG ROOT_PASSWD=187

RUN echo root:${ROOT_PASSWD} | chpasswd

RUN apt update
RUN apt -y install curl net-tools htop iproute2
RUN apt -y install cups
RUN apt -y install printer-driver-cups-pdf
RUN apt -y install avahi-daemon samba

COPY cups-pdf.conf /etc/cups/cups-pdf.conf
COPY cupsd.conf /etc/cups/cupsd.conf
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf
COPY smb.conf /etc/samba/smb.conf

# Copy the startup script into the container
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Expose CUPS web interface port
EXPOSE 631
EXPOSE 5353/udp


# Start the script
CMD ["/usr/local/bin/startup.sh"]