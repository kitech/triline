all:

upbin:
	cp -a /usr/bin/amuled usr/bin/
	cp -a /usr/lib/libcryptopp.so* usr/lib/
	cp -a /usr/lib/libupnp.so* usr/lib/
	cp -a /usr/lib/libixml.so* usr/lib/
	cp -a /usr/lib/libthreadutil.so* usr/lib/
	cp -a /usr/lib/libinotifytools.so* usr/lib/
	cp -a /usr/bin/inotifywait usr/bin/

raw: upbin
	docker build -t kitech/dkwnat .

pushraw:
	docker push kitech/dkwnat

