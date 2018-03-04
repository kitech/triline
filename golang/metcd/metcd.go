package main

import (
	"bufio"
	"flag"
	"fmt"
	"gopp"
	"log"
	"os"
	"os/exec"
	"strings"
	"sync"
	"time"
)

const etcd_client_port_base = 2379
const etcd_peer_port_base = 2380
const etcd_port_step = 100

var etcd_exe string = "/usr/bin/etcd"
var etcd_node_count int = 5
var etcd_data_dir string = os.Getenv("HOME") + "/tmp"
var etcd_version string
var etcd_version_majar string

func main() {
	log.SetFlags(log.Flags() | log.Lmicroseconds)
	flag.IntVar(&etcd_node_count, "c", etcd_node_count, "node count, 1,3,5,7 is best")
	flag.StringVar(&etcd_data_dir, "d", etcd_data_dir, "data directory")
	flag.StringVar(&etcd_exe, "e", etcd_exe, "etcd executable path")
	flag.Parse()

	cmd := exec.Command(etcd_exe, "--version")
	cmd.Wait()
	output, err := cmd.CombinedOutput()
	gopp.ErrPrint(err)
	log.Println(string(output))
	line := strings.Split(string(output), "\n")[0]
	etcd_version = strings.Split(line, " ")[2]
	etcd_version_majar = etcd_version[0:1]
	log.Println(etcd_version, etcd_version_majar)

	nn := map[int]int{}
	for i := 0; i < etcd_node_count; i++ {
		nn[i] = i
	}
	for i, _ := range nn {
		go run_etcd_node(i)
	}
	for {
		time.Sleep(1 * time.Second)
	}

}

func run_etcd_node(no int) {
	log.Println("Running node:", no)
	args := gen_etcd_args(no)
	log.Println("No.", no, etcd_exe, strings.Join(args, " "))
	cmd := exec.Command(etcd_exe, args...)
	log.Println("started???")

	stderr, err := cmd.StderrPipe()
	gopp.ErrPrint(err)

	wg := sync.WaitGroup{}

	go func() {
		wg.Add(1)

		err := cmd.Run()
		log.Println("started???")
		gopp.ErrPrint(err)
		// output, _ := cmd.CombinedOutput()
		// log.Println(no, string(output))

		wg.Done()
	}()

	for {
		time.Sleep(5 * time.Millisecond)
		log.Println(cmd.ProcessState, cmd.Process)
		if cmd.Process == nil {
			continue
		} else {
			break
		}
	}

	go func() {
		wg.Add(1)
		for {
			r := bufio.NewReader(stderr)
			line, isPrefix, err := r.ReadLine()
			gopp.ErrPrint(err)
			if err != nil {
				break
			}
			if isPrefix {
			}
			tmeg := "2017-10-15 00:31:35.149388"
			if len(line) > len(tmeg) {
				line = line[len(tmeg):]
			}
			log.Println("MEP.", no, string(line))
		}
		log.Panicln("wtf")
		wg.Done()
	}()
	wg.Wait()
	log.Println("MEP.", no, "done")
}

func gen_etcd_args(i int) []string {
	args := map[string]string{
		"--name":                        fmt.Sprintf("defmem%d", i),
		"--data-dir":                    fmt.Sprintf("%s/defmem%d.metcdv%s", etcd_data_dir, i, etcd_version_majar),
		"--listen-peer-urls":            fmt.Sprintf("http://0.0.0.0:%d", etcd_peer_port_base+i*etcd_port_step),
		"--listen-client-urls":          fmt.Sprintf("http://0.0.0.0:%d", etcd_client_port_base+i*etcd_port_step),
		"--initial-advertise-peer-urls": fmt.Sprintf("http://127.0.0.1:%d", etcd_peer_port_base+i*etcd_port_step),
		"--advertise-client-urls":       fmt.Sprintf("http://127.0.0.1:%d", etcd_client_port_base+i*etcd_port_step),
		"--initial-cluster":             gen_init_clusters(),
		"--initial-cluster-token":       "etcd-cluster",

		"--snapshot-count":     "10000",
		"--heartbeat-interval": "100",
		"--election-timeout":   "1000",
		"--max-snapshots":      "5",
		"--max-wals":           "5",
	}
	ret := []string{}
	for arg_name, arg_value := range args {
		ret = append(ret, arg_name, arg_value)
	}

	switchs := []string{"--debug"}
	v3 := false
	if v3 {
		switchs = append(switchs, "--enable-v2=false")
	}
	ret = append(ret, switchs...)
	return ret
}

func gen_init_clusters() string {
	rets := []string{}
	for i := 0; i < etcd_node_count; i++ {
		rets = append(rets, fmt.Sprintf("defmem%d=http://127.0.0.1:%d", i, etcd_peer_port_base+i*etcd_port_step))
	}
	return strings.Join(rets, ",")
}
