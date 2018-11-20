# Use an existing docker image as base
FROM microsoft/nanoserver

# Create a directory for redis server
RUN mkdir C:\redis

# Download and install a Dependency
RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Method Get -Uri https://github.com/MicrosoftArchive/redis/releases/download/win-3.2.100/Redis-x64-3.2.100.zip -OutFile redis.zip ; \
    Expand-Archive redis.zip . ; \
    Remove-Item redis.zip -Force

ENTRYPOINT [ "redis-server" ]
