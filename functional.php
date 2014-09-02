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

    /*
      (parameters) ->expression                or         (parameters) ->{ statements; }
      1.  () -> 5                           		// takes no value and returns 5
      2.  x -> 2 * x            					// takes a number and returns the result of doubling it
      3.  (x, y) -> x - y                     		// takes two numbers and returns their difference
      4.  (int x, int y) -> x + y      				// takes two integers and returns their sum
      5.  (String s) -> System.out.print(s) 		// takes a string and prints it to console without returning anything
     */
    public static function lamexp($exp)
    {

    }

    public static function literal($body)
    {

    }
};

// High Order Functions
class FPHOF
{
    // map,reduce,filter
};

// First Order Functions
class FPFOF
{
    // apply
};

class String
{
    
};

function lambda($body)
{
    return Funt::lambda($body);
}

function lamexp($exp)
{
    return Funt::lamexp($exp);
}

class Lambda
{
    public function __construct()
    {
        
    }
};


Characters::init(); // needed
class Characters {
    // case 1
    // map($arr, Characters::$isLowerCase);
    public static $isLowerCase = null;
    public static $isUpperCase = null;

    public static function init()
    {
        // shit PHP syntax limitation
        Characters::$isLowerCase = function($v) { return ($v == strtolower($v)); };
        Characters::$isUpperCase = function($v) { return ($v == strtoupper($v)); };
    }

    // case 2
    // map($arr, 'Characters::isLowerCase');
    // case 3
    // map($arr, Characters::isLowerCase());
    public static function __callStatic($m, $a)
    {
        $case = 3; // for switch

        if ($case == 2) {
            switch ($m) {
            case 'isLowerCase': return call_user_func_array(Characters::$$m, $a);
            case 'isUpperCase': return call_user_func_array(Characters::$$m, $a);
            default:
                throw new Exception('Unkown method');
                break;
            }
        } else if ($case == 3) {
            switch ($m) {
            case 'isLowerCase': return Characters::$$m;
            case 'isUpperCase': return Characters::$$m;
            default:
                throw new Exception('Unkown method');
                break;
            }
        } else {
            throw new Exception('Not Possible');
        }
    }

};


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

/*
  函数式编程通用方法语义说明：
  *map 对每个元素应用一个函数，得到数目相等的列表。注意mapn的情况。
  *reduce 即fold*
  fold 对每个元素应用一个函数，得到一个结果。需要前置初值。
  foldLeft 指定从左到右的顺序，与fold的默认语义相同
  foldRight 指定从右到左的顺序
  exists 是否有符合一个条件的元素
  forall 
  count
  *filter 返回一个小于等于原list的新list。
  
 */

/*
  从functionaljava学习函数式编程
  函数式编程概念：
  数据结构，集合数据类型，其他抽象算法
  全函数/偏函数，
  高阶函数
  一阶函数
  匿名表达式
  map函数：在遍历的每个元素上应用某个函数，返回相同数目的相同类型的集合，该集合是一个新的集合，还不是修改的原来的集合。
  

  phpng可能有的特性，
  正式发布的版本号为PHP7.0，但有些优化可能反抽合并到5.x,6.x版本。
  效率提升，现有的2倍以上
  JIT优化
  await 异步编程关键字
  完全线程安全

  
  PHP中的函数式编程特性分析
  
  一、引言
  在写此文时，想起之前看过的一句话，如果要学习一门新的语言，那么就学习一门能够改变你的思维方式的语言。
  本着这句对我触动比较大的一句话，一直在关注着LISP/Scheme这类直接产生函数式编程方式的语言。
  在这中间看过一些相关的资料，试着编写过一些代码，却一直停留在学习试验阶段，很难写出像样的可用程序来。
  
  在最近几年中，又是一个计算机界推出新语言高潮。比较新的有Closure，Go等。
  并且一些比较老的语言像C++，Python，Perl，发展变化的步伐也变大了。
  在C++11中，也添加了匿名函数的支持。nodejs的javascript语言，更是标榜着“披着C语言外衣的LISP”。
  从这些变化除了让程序更高效，功能更丰富全面外，也提供了大量使用函数式思维解决程序复杂度不断上升的问题的特性。
  
  这也正好契合了我希望能学习一门新语言的想法。不过这门新语言并没有找到，而是在这个过程中，
  通过分析多种编程语言的特性和多种发展迅速的语言的新特性，有了一些新发现：
  函数式思维才是我要找的东西，函数式思维不只是标榜为函数式语言才有的东西。
  把函数式思维用于现有的命令式语言（一般也都是混合模式的语言），一样能够加深对函数式思维的理解。

  其实经过了这个复杂的寻找过程，也影响了我对LISP/Scheme类函数式语言的理解。
  现在也能用Scheme编程简单实用程序了。
  不过现在，还是从我比较熟悉的其中一门语言PHP说起，探讨函数式编程的基本应用。


  二、PHP目前的发展现状
  说到函数式编程，不得不提到闭包的概念，而PHP是从PHP-5.3版本才引入的，
  所以PHP语言在函数式编程方面特性并不强，不过现在已经能够初步实现一些函数式编程方式了。
  并且，就目前对此刚入门来说，如果要分析一门包含所有函数式编程特性的语言，
  分析起来也还有不少困难。

  除了现在稳定版本的PHP-5.x版本，在函数式语言方面算是非常初步的。
  从phpng的开发看，也就是后续的6.0、7.0版本，并没有看到太多的函数式编程特性的影子。
  反而是Facebook的基于PHP的Hack/HHVM语言，已经添加了许多函数式编程的特性语法。

  三、使用闭包匿名函数实现数组求和
  先来看一下在PHP中使用闭包的方式，
  <code type="php">
  $fn = function($a, $b) { return $a + $b; };
  echo $fn(1, 2);
  </code>

  这里实现了把一个类似函数的语句赋值给一个变量，然后这个变量执行'()'操作。
  最终的输出结果为3。
  乍一看，这也没有什么了不起的，和函数的功能一样的。
  接下来，我们用这种方法实现一个求和功能，看下这种方式的优势。

  <code type="php">
  $arr = array(1, 2, 3, 4, 5);
  $sum = array_reduce($arr, $fn, 0);
  echo $sum;
  </code>

  这段代码的输出结果为15。
  其执行过程为给定一个初始值，遍历数组，并调用这个$fn变量所表示的匿名函数，然后返回结果。
  在前一段代码中，$fn()直接调用输出结果。
  在这个例子中，$fn作为一个参数传递给了另一个函数，由这个函数隐匿调用$fn($a, $b)。
  这比直接使用for循环遍历数组要简洁的多。
  其中的核心思想是把通用的算法作用于数据，产生相应的结果，着重点在通用算法上。

  当然，在PHP中，对于这个数组，还可以使用array_sum函数直接计算出结果。
  但是，由于可能的计算操作非常多，或者数组不是这种标准格式的，现有的函数就不够用了。
  单独靠PHP需要提供函数也可就多了，而且全部都提供的话PHP也就没这么容易入手了。
  这些离散的PHP函数，对核心开发人员来说还要考虑是否真的需要。

  
  四、具有更丰富函数式编程特征的求和方式
  上一节中，我们使用了针对array类型的array_reduce函数实现了求和功能。
  本节中，我们将编写一个更通用的遍历数据的函数map实现任意数据类型的遍历语义。
  同时，提供一个更通用的reduce函数，将相同的算法用于更复杂的不同的数据结构中。

  通用的遍历函数map的实现，

  <code type="php">
    function map($var, $proc)
    {
        if (!is_callable($proc)) return false;

        if (is_array($var)) {
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
    </code>

    目前该map函数不但能够遍历数组，还能够遍历字符串，然后把遍历出来的每个元素逐个应用于可调用的$proc上。
    这就是函数式编程中的关注要做什么，map函数就是提供遍历，而遍历什么数据结构则放在其次。

    实现聚合的通用的reduce函数实现，
    <code type="php">
    function reduce($var, $proc, $default)
    {
        $val = $default;
        map($var, function ($k, $v) use (&$val, $proc) {
                $val = call_user_func($proc, $val, $v, $k);
                return $val;
            });

        return $val;
    }
    </code>
    
    聚合首先要遍历，所以使用了map函数，在些函数基础出做进一步函数调用。
    reduce函数同样也是关注了要做什么。

    现在来看怎么用函数式编程方式实现求和，

    <code type="php">
    function add()
    {
        $args = func_get_args();
        
        return Funt::reduce($args, function ($r, $k, $v) {
                return $r + $v; 
            }, 0);
    }
    </code>

    <code type="php">
    $sum = add(1, 2, 3, 4, 5); 
    </code>
    
    或者
    <code type="php">
    $sum = add($arr);
    </code>
    
    是不是非常简单呢，甚至可以通过完善add函数实现不同数据类型的求和。
    
    这段代码的最大特点是什么呢？是要做什么为主，这个说清楚了，后面才是怎么做。


    五、 PHP中函数式编程特性的不足与补充
    
    在以上两节，从PHP引入的闭包/匿名函数开始，介绍基本使用，并通过示例演示函数编程的基本方式。
    不过，如果再要使用更多的函数编程特性的话，PHP目前就显得力不从心了。
    像在Hack语言中提供的“表达式闭包”，它是简化版本的匿名函数，由解释器自动当作函数执行。
    如在Hack语言中遍历数组并打印， map($arr, ($k, $v) ==> print $k . " --> " $v);
    这在PHP中很难以做到。

    还有通用算法方面，虽然有些涉及，但也不够完善和通用。
    不过在下一节中，我将试着用一种比较难看的方式实现类似的功能，
    变通地为PHP添加更多的函数式编程特征，同时也给出一种在此基础上再次扩展的思路。

    六、扩展PHP的函数式编程特性

    首先介绍强大的O函数，它让所有PHP变量成为一个StdClass对象，然后捕捉在这个对象上的所有调用，
    从而实现任意变量的函数调用。

    <code type="php">
    function O($var)
    {
     
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
     
        return $obj;
    };
    </code>

    这个函数让我们能实现类似ruby中5.times()这种功能。
    O(5)->times(function ($i) { print("say $i"); });
    是不是很强大。
    这个函数中使用到的Oimp类实现请查询完整的<a href="https://github.com/kitech/functionalphp">源代码</a>文件。
    除了在Oimp中实现times方法，只要不断扩充Oimp实现新的方法，就能够提供更多具有函数式特征的功能。
    
    另外一点，现在来看一下“表达式闭包”的模拟，

    <code type="php">
    // lambda('$x, $y => aaaaa'
    // @return Closure object
    function lambda($body)
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
            unlink($fname);

            return $lv;
        };

        return $f;
    }
    </code>

    它使用PHP的require解释写到临时文件的表达式代码，实现类似eval的功能。
    但应该比eval要轻量级一些，并且功能上也更容易控制。

    有了这个函数，本节开始时的示例可以实现如下，
    <code type="php">
    map($arr, lambda('$k, $v ===> print($k . " ---> " . $v)'));
    </code>

    由于无法在这一层级上修改PHP的语法，只能使用传递字符串做再次解析的方式。

    七、总结
    
    现在的PHP已经支持一点函数式编程特性，不过却没能很好的组织起来。
    这体现了在函数式编程方面PHP语言还有很长的路要走。
    通过一些额外的方法能完善PHP的函数式编程特性，
    即使有本文实现的基本框架，还有很多工作要做。


    参考：
    http://hhvm.org/
    http://php.net/


  1,2
  通用算法的缺失（算法与数组绑定）
  代码块传递的缺失（简洁lambda表达式）
  补充O函数。
  更多的函数式算法，groupby/some/any/exists/filter/contains/



 */

