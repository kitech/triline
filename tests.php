<?php

include_once('scheme.php');

$scm = new Scheme;


$code = "(+ 1 2 3 (+ 18 (+ 5 6)))";
$ret = $scm->do_eval($code);
var_dump($ret);

$file = "test.scm";
$code = file_get_contents($file);
$ret = $scm->do_eval($code);
var_dump($ret);


exit;
/*
$a = scm_tokenize($code);
$rnode = STParse($a);

$scope = new STScope(null);
$ret = evaluate($rnode, $scope);
var_dump($ret);

*/