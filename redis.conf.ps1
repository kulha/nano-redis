Get-Content redis.windows.conf | Where { $_ -notmatch 'bind 127.0.0.1' } | Set-Content redis.openport.conf
Get-Content redis.openport.conf | Where { $_ -notmatch 'protected-mode yes' } | Set-Content redis.unprotected.conf
Add-Content redis.unprotected.conf 'protected-mode no'
Add-Content redis.unprotected.conf 'bind 0.0.0.0'
Get-Content redis.unprotected.conf