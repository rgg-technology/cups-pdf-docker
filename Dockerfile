FROM ubuntu:22.04

EXPOSE 631

RUN echo 'root:187' | chpasswd

RUN apt update
RUN apt -y install cups

RUN apt -y install curl net-tools htop
RUN apt -y install iproute2


RUN apt -y install printer-driver-cups-pdf
RUN apt -y install avahi-daemon samba



COPY cups-pdf.conf /etc/cups/cups-pdf.conf
COPY cupsd.conf /etc/cups/cupsd.conf
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf
COPY smb.conf /etc/samba/smb.conf
#CMD ["cupsd", "-f"]

# Copy the startup script into the container
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Expose CUPS web interface port
EXPOSE 631
EXPOSE 5353/udp

RUN mkdir /data
RUN chmod 777 /data

# Start the script
CMD ["/usr/local/bin/startup.sh"]