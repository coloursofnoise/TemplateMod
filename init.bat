@echo off

set NAMEARG=%1
:loop
    if "%NAMEARG%"=="" (
        echo Enter Mod Name:
        set /p MODNAME=""
    ) else (
        set MODNAME=%NAMEARG%
        set "NAMEARG="
    )

    :: skip verification
    ::goto exitloop

    :: findstr character classes are horribly cursed
    :: https://stackoverflow.com/a/8767815
    echo %MODNAME%|findstr /r "[^0123-9aAb-Cd-EfFg-Ij-NoOp-St-Uv-YzZ _-]">nul 2>&1
    if errorlevel 1 ( echo ) else (
        echo !!! Name contains invalid characters.
        echo Valid characters include \`a-zA-Z0-9 _-\`
        set "MODNAME="
        goto loop
    )

    :: can't check for duplicates because no curl :bigsadeline:
:exitloop

:: this is an absolute mess
setlocal enableextensions disabledelayedexpansion
:recurse
for %%f in (*) do (
    :: ignore .* files (.gitignore)
    echo %%f|findstr /b \.>nul 2>&1
    if errorlevel 1 (
        :: ignore init.* files (like this one!)
        echo %%f|findstr /b init>nul 2>&1
    )
    if errorlevel 1 (
        echo %%f
        >"%%f.tmp" (
            for /f "delims=" %%i in ('findstr /n "^" "%%f"') do (
                set "line=%%i"
                setlocal enabledelayedexpansion
                set "line=!line:*:=!"
                if defined line set "line=!line:$MODNAME$=%MODNAME%!"
                echo(!line!
                endlocal
            )
        )
        move /y "%%f.tmp" "%%f" >nul
        set "file=%%f"
        setlocal enabledelayedexpansion
        move /y "%%f" "!file:$MODNAME$=%MODNAME%!
        endlocal
    )
)
for /D %%d in (*) do (
    echo %%d|findstr /b \.>nul 2>&1
    if errorlevel 1 (
        pushd %%d
        call :recurse
        popd
    )
)

echo Initialization Complete.
del "%~dp0/README.md"
del "%~dp0/LICENSE"
(goto) 2>nul & del "%~dp0/init.*" rem delete init files