package main

import (
	// "bufio"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net"
	"net/http"
	// "os"
	"strconv"
	"strings"
	"time"
)

/*
// TODO
下载速度，上传速度。（服务器间的速度）
ssh端口。
*/

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

// 测试http服务器的下载速度，带宽
func (this *CEProbeServer) speed(w http.ResponseWriter, req *http.Request) {

	rlen := 0
	for {
		num := rand.NormFloat64()
		str := fmt.Sprintf("%v", num)
		rlen += len(str)
		if rlen > 1024*1024*10 {
			break
		}
		strings.NewReader(str).WriteTo(w)
	}

}

var cepsrv = NewCEProbeServer()

func main() {
	log.Println("starting...")

	http.HandleFunc("/", cepsrv.index)
	http.HandleFunc("/hello", cepsrv.hello)
	http.HandleFunc("/poll", cepsrv.poll)
	http.HandleFunc("/speed", cepsrv.speed)

	/// 测试tcp端口是否可用
	tln, err := net.Listen("tcp", ":8050")
	if err != nil {
		log.Println("Listen tcp error", err)
	}

	go func() {
		for {
			conn, err := tln.Accept()
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

	// 测试UDP端口是否可用
	ServerAddr, err := net.ResolveUDPAddr("udp", ":8050")
	uln, err := net.ListenUDP("udp", ServerAddr)
	if err != nil {
		log.Println("Listen udp error", err)
	}

	go func() {
		log.Println(uln)
	}()

	// 测试对外访问是否可用
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

	// 测试http服务是否可用
	err = http.ListenAndServe(":8070", nil)
	if err != nil {
		log.Panic(err)
	}
}
