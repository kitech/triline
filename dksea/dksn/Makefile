all:

upbin:
	cp ~/oss/src/mkuse/peeretcd/peeretcd .
	strip -sv peeretcd
	upx peeretcd

raw: upbin
	docker build -t kitech/dksn .
	rm -f peeretcd

pushraw:
	docker push kitech/dksn

hrku: upbin
	heroku container:push web -a prnetc
	#heroku container:release web -a prnetc

