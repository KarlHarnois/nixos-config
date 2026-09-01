@echo off
curl.exe -fL --connect-timeout 30 --speed-limit 1024 --speed-time 60 --retry 3 --retry-all-errors "https://mtgo.patch.daybreakgames.com/patch/mtg/live/client/setup.exe" -o "C:\Users\Public\Desktop\Install MTGO.exe"
if errorlevel 1 echo The MTGO installer download failed. See C:\OEM\install.log for details.> "C:\Users\Public\Desktop\Install MTGO failed.txt"
