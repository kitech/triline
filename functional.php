<?php

/*

  需要给PHP添加StdClass一个__call方法
  代码块传递
  轻量级eval
 */

class Math
{
    public static function add()
    {
        $argc = func_num_args();
        $args = func_get_args();
        
        return Funt::reduce($args, function ($r, $k, $v) {
                return $r + $v; 
            }, 0);
    }

    public static function mul()
    {
        $argc = func_num_args();
        $args = func_get_args();
        
        return Funt::reduce($args, function ($r, $v, $k) {
                return $r * $v; 
            }, 1);
    }

    public static function pow()
    {
        $argc = func_num_args();
        $args = func_get_args();
        
        array_reverse($args);
        
        return Funt::reduce($args, function ($r, $v, $k) {
                return $v ** $r; 
            }, 1);
    }
};


class Funt
{
    public static function map($var, $proc)
    {
        if (!is_callable($proc)) return false;

        switch (gettype($var)) {
        case 'string': function() {
            };
            break;
        }

        if (is_resource($var)) {
        } else if (is_object($var)) {
        } else if (is_array($var)) {
            foreach ($var as $k => $v) {
                call_user_func($proc, $k, $v);
            }
        } else if (is_string($var)) {
            for ($i = 0; $i < strlen($var); $i ++) {
                call_user_func($proc, $var[$i]);
            }
        } else {
        }

    }

    public static function reduce($var, $proc, $default)
    {
        $val = $default;
        Funt::map($var, function ($k, $v) use (&$val, $proc) {
                $val = call_user_func($proc, $val, $v, $k);
                return $val;
            });

        return $val;
    }

    // lambda('$x, $y => aaaaa'
    // body必须是有返回值的语句，不能使用echo语句
    // lambda语法的parser
    // @return Closure object
    public static function lambda($body)
    {
        $margs_str = trim(explode('=>', $body)[0]);
        $margs_list = explode(',', $margs_str);
        $mbody = trim(explode('=>', $body)[1]);

        $f = function(...$_lambda_args) use ($margs_list, $mbody) {
            $code = "<?php\n\n";

            foreach ($margs_list as $_lambda_k => $_lambda_v) {
                if (empty($_lambda_v)) continue;
                $code .= "" . trim($_lambda_v) . " = \$_lambda_args[{$_lambda_k}];\n";
            }

            $code .= "\nreturn ( " . $mbody . " );\n";

            $code_hash = md5($mbody);
            $fname = "/tmp/php_lambda_{$code_hash}.php";
            file_put_contents($fname, $code);
            
            $lv = require($fname);

            // unlink($fname);

            return $lv;
        };

        return $f;
    }

    public static function literal($body)
    {

    }
};


class String
{
    
};

function lambda($body)
{
    return Funt::lambda($body);
}

class Lambda
{
    public function __construct()
    {
        
    }
};

class Characters {
    public static $isLowerCase = null;
    public static $isUpperCase = null;
};

// shit PHP syntax limitation
Characters::$isLowerCase = function($v) { return ($v == strtolower($v)); };
Characters::$isUpperCase = function($v) { return ($v == strtoupper($v)); };


// ruby首页的5.times {}实现
function O($var)
{
    if (!class_exists('Oimp')) {

        class Oimp
        {
            private $obj = null;
            public function __construct($var)
            {
                $this->setVar($var);
            }
            public function __distruct()
            {
                var_dump("distructed");
            }

            public function setVar($var)
            {
                $this->obj = $var;
            }
        
            public function __call($m, $a)
            {
                switch ($m) {
                case 'times':
                    if (is_numeric($this->obj)) {
                        foreach (range(1, $this->obj) as $v)
                            call_user_func($proc = $a[0], $v);
                    }
                    break;
                case 'exists':
                    if (is_array($this->obj)) {
                        $ok = false;
                        foreach ($this->obj as $k => $v) {
                            $ok = $ok || call_user_func($proc = $a[0], $v);
                            if ($ok) break;
                        }
                        return $ok;
                    }
                    break;
                case 'filter':
                    if (is_array($this->obj)) {
                        $res = array();
                        foreach ($this->obj as $k => $v) {
                            if (call_user_func($proc = $a[0], $v)) $res[] = $v;
                        }
                        return $res;
                    }
                    break;   
                case 'abc':
                    break;
                default:
                    throw new Exception("unknown method:".$m);
                    break;
                }

            }

            public static function __get_o_handle($var)
            {
                // 对象缓存
                static $ho = null;
                is_null($ho) ? $ho = new Oimp($var) : $ho->setVar($var);

                return $ho;
            }

        };
    }


    if (0) {
        $bt = debug_backtrace(DEBUG_BACKTRACE_PROVIDE_OBJECT, 2);
        print_r($bt);
    }

    // 引入这个类，保证使用方无论保证这个引用，还是一直创建新的对象，都能够正确调用到相应方法
    // 这个类的代价相对更小
    if (!class_exists('__StdClass')) {
        class __StdClass extends StdClass
        {
            private $obj = null;
            public function __construct($var)
            {
                $this->obj = $var;
            }

            public function __call($m, $a)
            {
                $ho = Oimp::__get_o_handle($this->obj);
                return call_user_func_array(array($ho, $m), $a);
            }
        };
    }
    

    $obj = new __StdClass($var);

    // return $ho;
    return $obj;
};

function ff()
{

}


function OTest() {
    /*
    O(5)->times(function ($i) {
            echo($i . "\n");
        });

    O(3)->times(function ($i) {
            echo($i . "\n");
        });
    */
    $arr = array("Hello", "There", "what", "DAY", "iS", "iT");
    $b = O($arr)->exists(Characters::$isLowerCase);
    var_dump($b);

    $arr = array(97, 44, 67, 3, 22, 90, 1, 77, 98, 1078, 6, 64, 6, 79, 42);
    $arr2 = O($arr)->filter(function($v) { return $v % 2 == 0;});
    print_r($arr2);

    $arr2 = o($arr)->filter(lambda('$v => $v % 2 == 1'));
    print_r($arr2);
}

OTest();

$arr = array('fdjiefwf', '123');

Funt::map($arr, function($k, $v) { echo "$k => $v \n";});
Funt::map($arr, lambda('$k, $v => print "$k -> $v \n"'));


$str = "abcdefg";
Funt::map($str, function ($ch) {
        echo "$ch \n";
    });

$arr = array(1, 2, 3, 4, 5);
echo(Funt::reduce($arr, function ($r, $k, $v) {
        return $r + $v;
        }, 1)) . "\n";

echo(Math::add(1, 2, 3, 4, 5, 6) . "\n");
echo(Math::mul(1, 2, 3, 4, 5, 6) . "\n");
echo(Math::pow(2, 3, 2) . "\n");
echo(2 ** (3 ** 2)) . "\n";

function abc(){}
var_dump('abc') . "\n";

// PHP不支持“惰性特征”
// $arr = array(1/0, 3, 4);
// var_dump(count($arr));
// PHP的闭包“惰性特征”
$arr = function() {
    return array(1/0);
};

// 使用PHP的yeild协同机制，可以实现类似nodejs的事件机制。

