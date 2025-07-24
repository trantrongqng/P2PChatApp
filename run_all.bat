@echo off
echo =========================
echo   DANG KHOI DONG SERVER
echo =========================
start ""python Server.py

timeout /t 2 >nul

echo =========================
echo  DANG MO P2PChatApp
echo =========================
start "" build\Desktop_Qt_6_9_1_MinGW_64_bit-Release\release\P2PChatApp.exe
