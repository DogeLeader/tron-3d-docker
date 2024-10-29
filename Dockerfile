# Use an official lightweight base image
FROM debian:bullseye-slim

# Set environment variables for non-interactive apt installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages including TigerVNC
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-ttf-dev \
    libogg-dev \
    libvorbis-dev \
    liblua5.3-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-thread-dev \
    tigervnc-standalone-server \
    tigervnc-viewer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the Armagetron Advanced repo
RUN git clone --recursive https://github.com/armagetronad/armagetronad.git /armagetronad

# Build the project
WORKDIR /armagetronad
RUN make

# Configure VNC
# Create a VNC session without a password
RUN mkdir -p /root/.vnc && \
    echo "" > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Expose the ports for Armagetron server and VNC
EXPOSE 4285 5901

# Start the VNC server and the Armagetron server
CMD ["sh", "-c", "vncserver :1 -geometry 1280x720 -depth 24 && ./armagetronad-server -port ${PORT}"]
