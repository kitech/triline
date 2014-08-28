<?php

// ini_set('precision', 1000000);

function scm_tokenize($src)
{
    $tokens = array();
    $len = strlen($src);
    $curr_token = '';
    for ($i = 0; $i < $len; $i ++) {
        $ch = $src[$i];

        switch ($ch) {
        case '(':
            $tokens[] = $ch;
            break;
        case ')':
            if ($curr_token != '') {
                $tokens[] = $curr_token;
                $curr_token = '';
            }
            $tokens[] = $ch;
            break;
        case ' ':
            if ($curr_token != '') {
                $tokens[] = $curr_token;
                $curr_token = '';
            } else {
                // none
            }
            break;
        case "\n":
            if ($curr_token != '') {
                $tokens[] = $curr_token;
                $curr_token = '';
            }
            break;
        default:
            $curr_token .= $ch;
            break;
        }
    }

    return $tokens;
}

class STNode
{
    var $value = '';
    var $parent = null;
    var $children = array();

    public function __construct()
    {
    }
};


function STParse($tokens)
{
    $program = new STNode;
    $current = $program;

    for ($i = 0; $i < count($tokens); $i ++) {
        switch ($tokens[$i]) {
        case '(':
            $newNode = new STNode;
            $newNode->value = '(';
            $newNode->parent = $current;

            $current->children[] = $newNode;
            $current = $newNode;
            break;
        case ')':
            $current = $current->parent;
            break;
        default:
            $newNode = new STNode;
            $newNode->value = $tokens[$i];
            $newNode->parent = $current;

            $current->children[] = $newNode;
            break;
        }
    }

    $clause_count = count($program->children);
    echo "clause count: {$clause_count}\n";
    return $program->children[0];
}


class STScope
{
    var $parent = null;
    var $vars = array();

    public function __construct($parent) {
        $this->parent = $parent;
    }

    public static function find($scope, $name)
    {
        $current = $scope;
        while ($current != null) {
            if (array_key_exists($name, $current->vars)) {
                return $current->vars[$name];
            }
            $current = $current->parent;
        }

        return null;
    }

};

function evaluate(STNode $tnode, STScope $scope)
{
    if (count($tnode->children) <= 0) {
        if (is_numeric($tnode->value)) {
            return gmp_strval(gmp_init($tnode->value));
        }

        return STScope::find($scope, $tnode->value);
    }

    $first = $tnode->children[0];


    $builtInFuns = array();
    $builtInFuns['+'] = function ($args, $scope) {
        $ret = gmp_init(0);
        
        for ($i = 1; $i < count($args); $i ++) {
            // $ret += evaluate($args[$i], $scope);
            $ret = gmp_add($ret, gmp_init(evaluate($args[$i], $scope)));
        }

        return gmp_strval($ret);
    };

    $builtInFuns['*'] = function ($args, $scope) {
        $ret = gmp_init(1);

        for ($i = 0; $i < count($args); $i ++) {
            $v = evaluate($args[$i], $scope);
            if ($v == '') $v = 1;
            $ret = gmp_mul($ret, gmp_init($v));
        }

        return gmp_strval($ret);
    };


    if (array_key_exists($first->value, $builtInFuns)) {
        return $builtInFuns[$first->value]($tnode->children, $scope);
    }

    echo "evaling: {$first->value}...\n";
    if ($first->value == "begin") {
        $ret = null;
        for ($i = 0; $i < count($tnode->children); $i ++) {
            $ret = evaluate($tnode->children[$i], $scope);
        }
        return $ret;
    }

    if ($first->value == "defun") {
        
    }

    if ($first->value == "defvar") {
        echo "tnode count:" . count($tnode->children) . "\n";
        $varname = $tnode->children[1]->value;
        echo "varname: {$varname}\n";        
        $varval = evaluate($tnode->children[2], $scope);




        $scope->vars[$varname] = $varval;
        return $varval;
    }

    if ($first->value == "display") {
        $val = evaluate($tnode->children[1], $scope);
        echo $val;
        return null;
    }

    $func = null;
    if ($first->value == '(') {
        $tscope = new STScope($scope);
        $func = evaluate($first, $tscope);
    } else {
        $func = STScope::find($scope, $first->value);
    }

    $arguments = array();
    for ($i = 1; $i < count($tnode->children); $i ++) {
        $arguments[] = evaluate($tnode->children[$i], $scope);
    }

    if ($func == null) {
        throw new Exception("not defined function: {$first->value}\n");
    } else {
        $cnode = $func;
        $cscope = $scope;
        return evaluate($cnode, $cscope);
    }
}



class Scheme
{
    private $_scope = null;
    private $_rnode = null;

    public function __construct()
    {

    }

    public function do_eval($source)
    {
        $fmt_source = "(begin $source )";
        $tokens = scm_tokenize($fmt_source);
        
        $this->_rnode = STParse($tokens);

        $this->_scope = new STScope(null);

        return evaluate($this->_rnode, $this->_scope);
    }

    public function do_shell()
    {

    }
};

