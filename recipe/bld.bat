REM Build step
cmake -G "NMake Makefiles" ^
	-D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
	-D CMAKE_BUILD_TYPE=Release ^
	-D ENABLE_STATIC=1 ^
	-D ENABLE_SHARED=1 ^
	-D WITH_JPEG8=1 ^
	-D NASM=yasm ^
	.
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

REM Install step
nmake install
if errorlevel 1 exit 1

REM Rename static libraries to be consistent with conda-forge's jpeg recipe
move %LIBRARY_PREFIX%\lib\jpeg-static.lib %LIBRARY_PREFIX%\lib\libjpeg.lib
move %LIBRARY_PREFIX%\lib\turbojpeg-static.lib %LIBRARY_PREFIX%\lib\libturbojpeg.lib
