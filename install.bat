@echo off
setlocal EnableDelayedExpansion

set SETTINGS_ROOT=""
set DETECTING_PATH=""
set COLORS_DIR=""
set SCHEME=""
set IDE_FOUND=false

:: run
call :set_paths
call :detect_and_copy
exit /b 0

:set_paths
  set SETTINGS_ROOT="%USERPROFILE%"
  set DETECTING_PATH="config\options\project.default.xml"
  set COLORS_DIR="config\colors"
goto :eof

:copy_scheme
  ide=%~1
  scheme=%~2
  if exist "%SETTINGS_ROOT%\!ide!\%DETECTING_PATH%" (
    set dest="%SETTINGS_ROOT%\!ide!\%COLORS_DIR%"
    if not exist "!dest!" (
      mkdir "!dest!" >nul
    )
    copy /y "!scheme!" "!dest!" >nul
    if %errorlevel% equ 0 (
      echo 'Mustang scheme successfully installed for "!ide!"'.
    )
  )
goto :eof

:detect_and_copy
  for /f "tokens=*" %%a in ('dir /b /ad "%SETTINGS_ROOT%" 2^>nul') do (
    echo "%%a" | findstr /i /r /c:"^\.?CLion.*$"
    if %errorlevel% equ 1 (
      set "found=true"
      call :copy_scheme "%%a", "mustang.clion.icls"
    )

    echo %%a | findstr /i /r /c:"^\.?IdeaC.*$" "^\.?IntelliJ.*$"
    if %errorlevel% equ 1 (
      set "found=true"
      call :copy_scheme "%%a", "mustang.idea.icls"
    )
  )

  if not defined "!found!" (
    echo 'No supported IDE detected'
    pause & exit /b 1
  )
goto :eof