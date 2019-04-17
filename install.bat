@echo off
setlocal EnableDelayedExpansion

set settings_root=""
set detecting_path=""
set colors_dir=""

:: run
call :set_paths
call :detect_and_copy
exit /b 0

:set_paths
  set settings_root="%userprofile%"
  set detecting_path="config\options\project.default.xml"
  set colors_dir="config\colors"
goto :eof

:copy_scheme
  ide=%~1
  scheme=%~2
  if exist "!settings_root!\!ide!\!detecting_path!" (
    set dest="!settings_root!\!ide!\!colors_dir!"
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
  for /f "tokens=*" %%a in ('dir /b /ad "!settings_root!" 2^>nul') do (
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
    exit /b 1
  )
goto :eof