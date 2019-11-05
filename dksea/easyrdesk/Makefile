all:

upbin:
	# gotty
	# novnc
	upx gotty || true
	mkdir -p usr/bin
	cp -a $(HOME)/triline/shell/xtermc usr/bin
	cp -a $(HOME)/Downloads/mac2012wallpaper.jpg .

raw: upbin
	docker build -t kitech/erdesk .

pushraw:
	docker push kitech/erdesk

