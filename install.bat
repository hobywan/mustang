@echo off
setlocal EnableDelayedExpansion

:: Copyright 2018, Hoby Rakotoarivelo.
::
:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the “Software”),
:: to deal in the Software without restriction, including without limitation
:: the rights to use, copy, modify, merge, publish, distribute, sublicense,
:: and/or sell copies of the Software, and to permit persons to whom the
:: Software is furnished to do so, subject to the following conditions:
::
:: The above copyright notice and this permission notice shall be included in
:: all copies or substantial portions of the Software.
::
:: The Software is provided “as is”, without warranty of any kind, express
:: or implied, including but not limited to the warranties of merchantability,
:: fitness for a particular purpose and noninfringement.
:: In no event shall the authors or copyright holders be liable for any claim,
:: damages or other liability, whether in an action of contract, tort or
:: otherwise, arising from, out of or in connection with the software or
:: the use or other dealings in the Software.

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
      echo "Mustang scheme successfully installed for !ide!".
    )
  )
goto :eof

:detect_and_copy
  for /f "tokens=*" %%a in ('dir /b /ad "!settings_root!" 2^>nul') do (
    echo "%%a" | findstr /r "^\.?CLion.*$"
    if %errorlevel% equ 0 (
      set "found=true"
      call :copy_scheme "%%a", "mustang.clion.icls"
    )

    echo "%%a" | findstr /r /c:"^\.?IdeaC.*$" "^\.?IntelliJ.*$"
    if %errorlevel% equ 0 (
      set "found=true"
      call :copy_scheme "%%a", "mustang.idea.icls"
    )
  )

  if not defined "!found!" (
    echo "No supported IDE detected"
    exit /b 1
  )
goto :eof