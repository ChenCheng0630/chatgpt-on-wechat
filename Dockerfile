# Use Python 3.10 slim image as base
FROM anolis-registry.cn-zhangjiakou.cr.aliyuncs.com/openanolis/python:3.10.13-23

# Set working directory
WORKDIR /app

# Set timezone
ENV TZ='Asia/Shanghai'

# Install system dependencies
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     bash \
#     ffmpeg \
#     espeak \
#     libavcodec-extra && \
#     rm -rf /var/lib/apt/lists/*

# Copy requirements files
COPY requirements.txt requirements-optional.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir -r requirements-optional.txt && \
    pip install --no-cache-dir azure-cognitiveservices-speech

# Copy config template and create config
COPY config.json config.json

# Copy application code
COPY . .

# Create non-root user for security
RUN mkdir -p /home/noroot && \
    groupadd -r noroot && \
    useradd -r -g noroot -s /bin/bash -d /home/noroot noroot && \
    chown -R noroot:noroot /home/noroot /app /usr/local/lib

# Switch to non-root user
USER noroot

CMD [ "python3", "app.py" ]
