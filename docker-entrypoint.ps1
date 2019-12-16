Start-Sleep -s 10
if ((Test-Path 'C:\ProgramData\Jackett\ServerConfig.json')) {
	$f = ConvertFrom-Json -InputObject (Get-Content 'C:\ProgramData\Jackett\ServerConfig.json' -raw)
	if(!$f.AllowExternal){
	$f.AllowExternal=$true
	Set-Content -Path 'C:\ProgramData\Jackett\ServerConfig.json' -Value (ConvertTo-Json -depth 32 -InputObject $f)
	Restart-Service -name "Jackett" -Force -ErrorAction SilentlyContinue
	Start-Sleep -s 10
	}
	}
Get-Content C:\ProgramData\Jackett\log.txt -Wait
