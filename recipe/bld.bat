:: Build step
mkdir build_libjpeg
cd  build_libjpeg

cmake %CMAKE_ARGS% -G "NMake Makefiles" ^
	-D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
	-D CMAKE_BUILD_TYPE=Release ^
	-D ENABLE_STATIC=1 ^
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
