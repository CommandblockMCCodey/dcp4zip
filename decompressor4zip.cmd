
set "INI_FILE=decompressor4zip.ini"
set "SECTION=TMP_DATA"
set "KEY=TMP_DIR"
set VALUE=
for /f "tokens=1* delims=]" %%A in ('find /n /i "[%SECTION%]" ^< "%INI_FILE%"') do (
    set FOUND_SECTION=%%A
    for /f "tokens=1,2 delims== " %%B in ('findstr /i /c:"%KEY%=" "%INI_FILE%"') do (
        if "%%B"=="%KEY%" (
            set VALUE=%%C
        )
    )
)
if not defined VALUE (
    set "VALUE=d4zip_tmp"
)
set "TMP_DIR=%VALUE%"

set "ZIP_FILE=%1"
set "TARGET_DIR=%2"

:restart
if not exist %TMP_DIR% (
    mkdir %TMP_DIR%
) else (
    rmdir %TMP_DIR%
    goto :clear_TMP
)

tar -xf %ZIP_FILE% -C %TMP_DIR%

scp %TMP_DIR% %TARGET_DIR%
if not %errorlevel% equ 0 (
    goto :restart
)

rmdir /s /q %TMP_DIR%