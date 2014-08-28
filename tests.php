<?php

include_once('scheme.php');

$code = "(+ 1 2 3 (+ 18 (+ 5 6)))";
$a = scm_tokenize($code);
$rnode = STParse($a);

$scope = new STScope(null);
$ret = evaluate($rnode, $scope);
var_dump($ret);

