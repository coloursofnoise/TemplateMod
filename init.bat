@echo off

set NAMEARG=%1
:loop
    if "%NAMEARG%"=="" (
        echo "Enter Mod Name:"
        set /p MODNAME=""
    ) else (
        set MODNAME=%NAMEARG%
        set "NAMEARG="
    )

    :: skip verification
    ::goto exitloop

    :: findstr character classes are horribly cursed
    :: https://stackoverflow.com/a/8767815
    echo %MODNAME%|findstr /r "[^0123-9aAb-Cd-EfFg-Ij-NoOp-St-Uv-YzZ]">nul 2>&1
    if errorlevel 0 (
        echo "!!! Name contains invalid characters."
        echo "Valid characters include \`a-zA-Z0-9 _-\`"
        set "MODNAME="
        goto loop
    )

    :: can't check for duplicates because no curl :bigsadeline:
:exitloop


echo "Initialization Complete."
(goto) 2>nul & del "%~dp0/init.*" rem delete init files