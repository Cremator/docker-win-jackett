FROM mcr.microsoft.com/dotnet/framework/runtime

LABEL maintainer="cremator"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN $j = Invoke-RestMethod -Uri "https://api.github.com/repos/Jackett/Jackett/releases"; \
	$jr = Invoke-RestMethod -Uri ('https://api.github.com/repos/Jackett/Jackett/releases/tags/'+$j.tag_name[0]); \
	foreach ($t in $jr.assets) {if ($t.name -like '*Binaries.Windows.zip') {$jd = $t.browser_download_url}}; \
    Invoke-WebRequest $jd -OutFile c:\jackett.zip ; \
    Expand-Archive c:\jackett.zip -DestinationPath C:\ ; \
    Remove-Item -Path c:\jackett.zip -Force; \
	Start-Process "C:\Jackett\JackettConsole.exe" -ArgumentList '-i' -Wait; \	
	Start-Sleep -s 10; \
	Stop-Service -name "Jackett" -Force -ErrorAction SilentlyContinue; \
	Start-Sleep -s 10; \
	Remove-Item "C:/ProgramData/Jackett" -Force -Recurse
ADD docker-entrypoint.ps1 C:/

EXPOSE 9117

VOLUME [ "C:/ProgramData/Jackett", "C:/downloads" ]

ENTRYPOINT powershell -command c:\docker-entrypoint.ps1
