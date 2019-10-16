<?php

var_dump($argv);

$s1 = $argv[1];
$fields = explode("|", $s1);
var_dump($fields);
$fields[2] = urlencode($fields[2]);
$s2 = implode("|", $fields);
echo $s2;
echo "\n";

