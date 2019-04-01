all: dragon/ dependencies/python-2.7.16.msi dependencies/vcredist_x86.exe dependencies/setup-natlink-4.1whiskey3.exe
	md5sum -c dependencies.md5

dragon/:
	@echo
	@echo Please place your Dragon installer into windows/$@.
	@echo
	exit 1

dependencies/python-2.7.16.msi:
	mkdir -p dependencies
	wget https://www.python.org/ftp/python/2.7.16/python-2.7.16.msi -O $@

dependencies/vcredist_x86.exe:
	mkdir -p dependencies
	wget https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe -O $@

dependencies/setup-natlink-4.1whiskey3.exe:
	mkdir -p dependencies
	wget https://sourceforge.net/projects/natlink/files/natlink/natlinktest4.1/setup-natlink-4.1whiskey3.exe -O $@
