<?php

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
            return intval($tnode->value);
        }

        return STScope::find($scope, $tnode->value);
    }

    $first = $tnode->children[0];


    $builtInFuns = array();
    $builtInFuns['+'] = function ($args, $scope) {
        $ret = 0;
        
        for ($i = 1; $i < count($args); $i ++) {
            $ret += evaluate($args[$i], $scope);
        }

        return $ret;
    };


    if (array_key_exists($first->value, $builtInFuns)) {
        return $builtInFuns[$first->value]($tnode->children, $scope);
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

