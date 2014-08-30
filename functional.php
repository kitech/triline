<?php

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
        switch (gettype($var)) {
        case 'string': function() {
            };
            break;
        }

        if (!is_callable($proc)) {
            return false;
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
};

class String
{
    
};

class Lambda
{
    public function __construct()
    {
        
    }
};

$arr = array('fdjiefwf', '123');

Funt::map($arr, function ($k, $v) {
        echo "$k => $v \n";
    });

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
