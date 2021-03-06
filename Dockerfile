# Use an existing docker image as base
FROM microsoft/nanoserver

# Create a directory for redis server
RUN mkdir C:\redis

# make this directory as working directory for following commands
WORKDIR C:/redis

# modify redis server config file to turn
# off protected mode and allow all ip addresses to connect to the server
RUN powershell -executionpolicy bypass -Command "\
    Get-Content redis.windows.conf | Where { $_ -notmatch 'bind 127.0.0.1' } | Set-Content redis.openport.conf ; \
    Get-Content redis.openport.conf | Where { $_ -notmatch 'protected-mode yes' } | Set-Content redis.unprotected.conf ; \
    Add-Content redis.unprotected.conf 'protected-mode no' ; \
    Add-Content redis.unprotected.conf 'bind 0.0.0.0' ; \
    Get-Content redis.unprotected.conf"

# Download and install a Dependency
RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Method Get -Uri https://github.com/MicrosoftArchive/redis/releases/download/win-3.2.100/Redis-x64-3.2.100.zip -OutFile redis.zip ; \
    Expand-Archive redis.zip . ; \
    Remove-Item redis.zip -Force

EXPOSE 6379

# Tell this new image what to do when it starts 
# as a container
CMD powershell -Command \
    .\\redis-server.exe .\\redis.unprotected.conf --port 6379 ; \
    Write-Host Redis Started... ; \
    while ($true) { Start-Sleep -Seconds 3600 }
