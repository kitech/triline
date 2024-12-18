https://blog.howardjohn.info/posts/go-build-times/

build syntax only mode: -toolexec=$PWD/gobnold.sh

go test -toolexec=$PWD/gobverbose.sh -vet=off

GOFLAGS=-buildvcs=false
CGO_CFLAGS="-g -O0"

go build -ldflags "-linkmode external -extld clang -extldflags -fuse-ld=mold"

go build -debug-actiongraph=/tmp/actiongraph ./pilot/cmd/pilot-discovery
actiongraph result parse: https://github.com/unravelin/actiongraph

goda, the "Go Dependency Analysis toolkit"

go test -c # the -c switch

- * gobverbose.sh的结果文件  /tmp/golog

- [ ] cgo生成的c代码不兼容tinycc,否则还是有加快空间的

v -keepc -skip-running tcc4cgo.vsh && CC=$PWD/tcc4cgo ./gospup.sh -v -x demo.go
v -keepc -skip-running tcc4cgo.vsh && CC=$PWD/tcc4cgo go build  -v -x demo.go
v -keepc -skip-running tcc4cgo.vsh && CC=$PWD/tcc4cgo go build  -v -x demo.go
