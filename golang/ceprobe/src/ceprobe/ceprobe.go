package main

import (
	// "bufio"
	"io/ioutil"
	"log"
	"math/rand"
	"net"
	"net/http"
	"strconv"
	"strings"
	"time"
)

type CEProbeServer struct {
	reqcnt int
}

func NewCEProbeServer() *CEProbeServer {
	return &CEProbeServer{}
}

func (this *CEProbeServer) index(w http.ResponseWriter, req *http.Request) {
	log.Println(w, req)

}

func (this *CEProbeServer) hello(w http.ResponseWriter, req *http.Request) {
	strings.NewReader("hello world!\n").WriteTo(w)
}

// 测试http服务器允许poll的时间
func (this *CEProbeServer) poll(w http.ResponseWriter, req *http.Request) {
	time.Sleep(50000 * time.Second)
}

var cepsrv = NewCEProbeServer()

func main() {
	log.Println("starting...")

	http.HandleFunc("/", cepsrv.index)
	http.HandleFunc("/hello", cepsrv.hello)
	http.HandleFunc("/poll", cepsrv.poll)

	///
	ln, err := net.Listen("tcp", ":8050")
	if err != nil {
		log.Println("Listen tcp error", err)
	}

	go func() {
		for {
			conn, err := ln.Accept()
			if err != nil {
				log.Println("accept error", err)
			}
			log.Println("accet one")
			go func() {
				rdn := rand.Int()
				rsp := "hello tcp:" + strconv.Itoa(rdn) + "\n"
				strings.NewReader(rsp).WriteTo(conn)
				conn.Close()
			}()
		}
	}()

	go func() {
		urls := []string{
			"http://news.baidu.com/",
			"https://www.github.com/",
			"https://www.google.com/",
		}

		for _, url := range urls {
			resp, err := http.Get(url)
			if err != nil {
				log.Println(url, "get inet error", err)
			} else {
				hcc, err := ioutil.ReadAll(resp.Body)
				if err != nil {
				}
				log.Println(url, "code:", resp.StatusCode, "len:", len(hcc))
				resp.Body.Close()
			}
		}
	}()

	http.ListenAndServe(":8080", nil)
}
