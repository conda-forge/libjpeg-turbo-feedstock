:: Build step
mkdir "%SRC_DIR%\stage"
mkdir build_libjpeg
cd  build_libjpeg

cmake -G "NMake Makefiles" ^
	-D CMAKE_INSTALL_PREFIX="%SRC_DIR%\stage" ^
	-D CMAKE_BUILD_TYPE=Release ^
	-D ENABLE_STATIC=0 ^
	-D ENABLE_SHARED=1 ^
	-D WITH_JPEG8=1 ^
	-D NASM=yasm ^
	%SRC_DIR%
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

:: Install step
nmake install
if errorlevel 1 exit 1

setlocal EnableExtensions ENABLEDELAYEDEXPANSION
for %%f in ( "%SRC_DIR%\stage\lib\pkgconfig\*.pc" ) do (
    sed -i.bak "s,prefix=.*,prefix=/opt/anaconda1anaconda2anaconda3/Library,g" %%f
    del %%f.bak
)
endlocal
