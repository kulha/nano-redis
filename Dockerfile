# Use an existing docker image as base
FROM microsoft/nanoserver

# Create a directory for redis server
RUN mkdir C:\redis

# make this directory as working directory for following commands
WORKDIR C:/redis

# copy and execute custom powershell script
COPY redis.conf.ps1 c:/redis
# this script contains commands to modify redis server config file to turn
# off protected mode and allow all ip addresses to connect to the server
RUN powershell.exe -executionpolicy bypass ./redis.conf.ps1

# Download and install a Dependency
RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Method Get -Uri https://github.com/MicrosoftArchive/redis/releases/download/win-3.2.100/Redis-x64-3.2.100.zip -OutFile redis.zip ; \
    Expand-Archive redis.zip . ; \
    Remove-Item redis.zip -Force

EXPOSE 6379

ENTRYPOINT [ "redis-server" ]
