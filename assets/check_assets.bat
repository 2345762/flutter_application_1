@echo off
echo === Checking assets folder ===
dir assets /b
echo.
echo === Checking pubspec.yaml asset declarations ===
findstr "assets/" pubspec.yaml