package main

// import _ "github.com/kitech/gopp/cgopp"
// import "github.com/kitech/gopp/cgopp"


/*
   void foo() {}
*/
import "C"

func main() {
	// cgopp.Go2cBool(true)////
	C.foo()
}
