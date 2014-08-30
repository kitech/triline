<?php

function map($var, $proc)
{
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


$arr = array('fdjiefwf', '123');

map($arr, function ($k, $v) {
        echo "$k => $v \n";
    });

$str = "abcdefg";
map($str, function ($ch) {
        echo "$ch \n";
    });

