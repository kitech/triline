package main

import "runtime"
import "log"

func main() {
	log.Println("hot it......")
	for i := 0; i < runtime.NumCPU()+1; i++ {
		go func() {
			for {
			}
		}()
	}
	select {}
}
