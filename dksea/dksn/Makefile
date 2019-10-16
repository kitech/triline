all:

upbin:
	cp ~/oss/src/mkuse/peeretcd/peeretcd .
	strip -sv peeretcd
	upx peeretcd
	strip -sv cvtier/cvtier || true
	upx cvtier/cvtier  || true
	strip -sv cvtier/tundms || true
	upx cvtier/tundms  || true
	mkdir -p p2pvm || true
	cp ~/oss/src/mkuse/p2pvm/p2vmnode p2pvm/
	strip -sv p2pvm/p2vmnode || true
	upx p2pvm/p2vmnode || true

raw: upbin
	# cp -a /somewhere/proot cvtier/
	# cp -a /somewhere/cvtier-html cvtier/html
	docker build -t kitech/dksn .
	#rm -f peeretcd

pushraw:
	docker push kitech/dksn

# registry.heroku.com/prnetc/worker
# web/worker
hrku: upbin
	heroku container:push web -a prnetc
	#heroku container:release web -a prnetc

hrkuwk: upbin
	heroku container:push worker -a prnetc
	#heroku container:release worker -a prnetc

hkcon:
	heroku run bash -a prnetc

