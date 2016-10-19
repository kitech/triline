/*
go run tox100.go [count]

maybe need ulimit -n 10000
*/

package main

import (
	"flag"
	"fmt"
	"log"
	"strconv"
	"time"

	"tox"
)

func init() {
}

var toxNodeCount int = 5

func main() {
	flag.Parse()

	if flag.NArg() > 0 {
		toxNodeCountx, err := strconv.Atoi(flag.Arg(0))
		if err != nil {
			log.Println(err)
			return
		}
		toxNodeCount = toxNodeCountx
	}

	t100 := NewTox100(toxNodeCount)
	t100.Serve()
}

type Tox100 struct {
	count int
	cores []*tox.ToxClient
}

func NewTox100(count int) *Tox100 {
	t100 := &Tox100{}
	t100.count = count
	t100.cores = make([]*tox.ToxClient, count)

	return t100
}

func (this *Tox100) Serve() {

	dir := "./tox100p"
	for idx := 0; idx < this.count; idx++ {
		name := fmt.Sprintf("tox%.3d", idx)
		client := tox.NewToxClient(name, dir)
		this.cores[idx] = client

		client.Core.CallbackSelfConnectionStatus(func(t *tox.Tox, status uint32, ud interface{}) {
			log.Println("self conn status:", t, status, ud, ud.(*tox.ToxClient).Name)
		}, client)

	}

	for idx := 0; idx < this.count; idx++ {
		client := this.cores[idx]

		go func() {
			for true {
				client.Iterate()
				time.Sleep(time.Millisecond * 200)
			}
		}()
	}

	select {}
}
