<?php
/* htshc.php --- 
 * 
 * Author: liuguangzhao
 * Copyright (C) 2007-2013 liuguangzhao@users.sf.net
 * URL: 
 * Created: 2013-04-06 17:27:15 +0000
 * Version: $Id$
 */

/**
 * 尽量在客户端做功能，
 * 像转换命令行，
 * 让服务器端保持精简
 * 
 * TODO 更好的信号处理与进行中断处理
 *      命令提交前的预处理
 * 
 */

declare(ticks = 1);

$htsh = new HttpShell('gzleo');
$htsh->runcon();

class HttpShell
{
    private $_pwd = '';
    private $_old_pwd = '';
    private $_purl = "http://photo.house.sina.com.cn/test/test5";
    private $_pip = '';
    private $_sin = STDIN;
    private $_shh = '>$ ';
    private $_curr_shh = '';
    private $_hint = '';
    private $_history_file = '';
    private $_hcurl = null;
    private $_cookies = array();
    private $_proxies = array();  // 切换过的代理列表, 'url' => array('ip1', 'ip2');
    private $_helps = array();
    private $_envs = array();
    private $_inputLine = '';
    private $_inputFinished = false;

    public function __construct($hint)
    {
        $this->_curr_shh = $this->_shh;
        $this->_hint = $hint;

        $this->_history_file = getenv('HOME') . '/.htsh_history';

        readline_completion_function(array($this, 'completionFunctor'));

        $this->helpInit();
        $this->handleSignals();
        $this->restoreRC();
    }

    public function runcon()
    {
        $iscmd = function ($line, $cmd) {
            if ($line == $cmd || substr($line, 0, strlen($cmd)+1) == $cmd . ' ') {
                return true;
            }
            return false;
        };

        while (true) {

            $chint = $this->getFullHint();
            // $cline = readline($chint);
            $cline = $this->readio_readline($chint);
            $rline = trim($cline);

            // var_dump($cline);
            // exit;

            if ($cline == "") {
            } else if ($rline == 'exit' || $rline == 'bye') {
                $this->quit();
            } else if ($rline == 'help' || $rline == '?' || $rline == 'usage') {
                $this->help();
            } else if ($rline == 'version') {
                echo "htsh - 1.0\n";
            } else if ($rline == 'history') {
                print_r(readline_list_history());
            } else if ($iscmd($rline, 'switch2ip')) {
                $this->switchhostip($rline);
            } else if ($iscmd($rline, 'switch2host')) {
                $this->switchhostip($rline);
            } else if ($iscmd($rline, 'push')) {
                $this->notimplcmd($rline);
            } else {
                // echo $cline . "\n";
                $this->runCmd($cline);
            }
        }
        
    }

    protected function runCmd($line)
    {
        readline_add_history($line);

        $purl = $this->getCmdUrl($line);
        // $cout = file_get_contents($purl);
        $cout = $this->sendCommandRequest($purl);
        echo $cout;
    }

    protected function runCtrl($ctrl)
    {
        
    }

    protected function runcompletion($prefix)
    {

    }

    private function getCmdUrl($line)
    {
        $pi = parse_url($this->_purl);
        $host = $pi['host'];
        $hip = gethostbyname($host);
        $purl = str_replace($host, $hip, $this->_purl);

        $cmd = $this->reformatCommand($line);
        $cmd_url = $this->_purl . '/cmd/?cmd=' . urlencode($cmd);
        $cmd_url .= '&pwd=' . $this->_pwd;
        $cmd_url .= '&old_pwd=' . $this->_old_pwd;

        return $cmd_url;
    }

    private function getCtrlUrl()
    {
        $pi = parse_url($this->_purl);
        $host = $pi['host'];
        $hip = gethostbyname($host);
        $purl = str_replace($host, $hip, $this->_purl);

        $cmd_url = $this->_purl . '/ctrl/?';
        $cmd_url .= '&pwd=' . $this->_pwd;
        $cmd_url .= '&old_pwd=' . $this->_old_pwd;

        return $cmd_url;
    }

    private function getFullHint()
    {
        $pwd = $this->_pwd ? $this->_pwd : '~';
        $fhint = "[{$this->_hint}@HTSH>{$this->_purl} {$pwd}]$ ";

        var_dump($pwd);
        return $fhint;
    }

    protected function reformatCommand($cmd)
    {       
        $cmd = trim($cmd);
        var_dump($cmd, $this->_old_pwd, 456);

        if ($cmd == 'ls') {
            $cmd = 'ls --color';
        }
        
        if (strpos($cmd, "ls ") === 0) {
            $cmd = str_replace("ls ", "ls --color ", $cmd);
        }
        
        if ($cmd == 'cd') {
            $cmd = "cd ~";
        }

        if ($cmd == 'cd -') {
            // $cmd = "cd {$OLDPWD}";
            if ($this->_old_pwd) {
                $cmd = "cd {$this->_old_pwd}";
            }
        }

        if (!strstr($cmd, "2>&1")) {
            $cmd = $cmd . " 2>&1 ";
        }
        
        return $cmd;
    }

    /**
     * 生成补全数组
     *
     * TODO 参数级的补全
     */
    private function completionFunctor($input, $index)
    {
        $helps = $this->_helps;
        $matches = array();

        foreach ($helps as $cmd => $desc) {
            if (substr($cmd, 0, strlen($input)) == $input) {
                $matches[] = $cmd;
            }
        }

        if (!empty($matches)) {
            // return $matches;
        }

        // exec("env|grep ^PATH|grep -v grep", $output, $rval);

        // print_r($output);

        // return $matches;

        // echo $input . ':' . $index . "\n";

        $rlinfo = readline_info();

        // print_r($rlinfo);

        $ctrl_url = $this->getCtrlUrl();

        $ctrl_url .= '&input=' . $input;
        $ctrl_url .= '&index=' . $index;

        foreach ($rlinfo as $ikey => $ival) {
            $ctrl_url .= '&' . $ikey . '=' . urlencode($ival);

        }

        $rmatches = file($ctrl_url);
        if (!empty($rmatches)) {
            foreach ($rmatches as $idx => $rmat) {
                $matches[] = trim($rmat);
            }
        }

        //print_r($matches);

        return $matches;
        return array();
    }

    protected function sendCommandRequest($url)
    {
        $pi = parse_url($url);
        $host = $pi['host'];
        $hip = gethostbyname($host);
        $ups = explode('?', $url);
        $purl = str_replace($host, $this->_pip ? $this->_pip : $hip, $ups[0]) . '?' . $ups[1];

        $this->_hcurl = $ch = curl_init();

        $bret = curl_setopt($ch, CURLOPT_URL, $purl);
        $bret = curl_setopt($ch, CURLOPT_BUFFERSIZE, 8);
        $bret = curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_0);
        $bret = curl_setopt($ch, CURLOPT_VERBOSE, false);
        $bret = curl_setopt($ch, CURLOPT_WRITEFUNCTION, array($this, 'curlWriteFunc'));
        // $bret = curl_setopt($ch, CURLOPT_PROGRESSFUNCTION, array($this, 'curlProgressFunc'));
        $bret = curl_setopt($ch, CURLOPT_HEADERFUNCTION, array($this, 'curlHeaderFunc'));
        $bret = curl_setopt($ch, CURLOPT_HTTPHEADER,array ("Host: {$host}", "Content-Type: text/xml; charset=utf-8"));

        // cookie
        $cooarr = array();
        $cooarr[] = "tokey=".md5('htshv1.0key');

        foreach ($this->_cookies as $ckey => $cval) {
            $cooarr[] = "{$ckey}={$cval}";
        }
        $bret = curl_setopt($ch, CURLOPT_COOKIE, implode(';', $cooarr));
        // var_dump($cooarr);

        $res = curl_exec($ch);
        // var_dump($res);
        if (curl_errno($ch) !== 0) {
            $cei = curl_getinfo($ch);
            $cerr = curl_error($ch);
            // var_dump($cei);
            echo $cerr . "\n";
        }

        curl_close($ch);

        $this->_hcurl = null;
    }

    /**
     *
     *
     */
    protected function switchhostip($line)
    {
        $lps = explode(' ', $line);
        
        switch (count($lps)) {
        case 3: // switch2host
            $this->_purl = $lps[1];
            $this->_pip = $lps[2];
            $this->_proxies[$this->_purl][$this->_pip] = 1;
            break;
        case 2:  // switch2ip
            $this->_pip = $lps[1];
            $this->_proxies[$this->_purl][$this->_pip] = 1;
            break;
        default:
            break;
        }
    }

    protected function notimplcmd($line)
    {
        $cmd_arr = explode(' ', $line);
        echo "Command not impled: {$cmd_arr[0]}\n";
    }

    public function curlWriteFunc($ch, $data)
    {
        
        echo $data;

        flush();

        return strlen($data);
    }

    public function curlProgressFunc($ch, $fd, $alen)
    {
        // var_dump($ch, $fd, $alen);

        // $c = fread($ch, 1);

        // echo $c;

        return $alen;
    }

    public function curlHeaderFunc($ch, $header)
    {
        echo $header;

        if (stristr($header, 'set-cookie:')) {
            $this->_curl_parse_cookie($header);
        }

        return strlen($header);
    }

    protected function _curl_parse_cookie($hdr) { 
        $cookies = array();

        $arr = explode(':', $hdr);
        $cookies[explode('=', $arr[1])[0]] = $arr[1];

        $arr2 = explode(';', $arr[1]);
        $arr3 = explode('=', $arr2[0]);
        $arr4 = explode('=', $arr2[1]);
        $this->_cookies[$arr3[0]] = $arr3[1];
        // $this->_cookies[$arr4[0]] = $arr4[1];

        $arr3[0] = trim($arr3[0]);
        if ($arr3[0] == 'old_pwd') {
            $this->_old_pwd = urldecode($arr3[1]);
        } else if ($arr3[0] == 'pwd') {
            $rpwd = rawurldecode($arr3[1]);
            // var_dump($arr3[1], $rpwd);
            if ($this->_pwd != $rpwd) {
                $this->_old_pwd = $this->_pwd;
                $this->_pwd = $rpwd;
            }
        }

        return $cookies;
    }

    protected function _curl_set_cookie($ch)
    {

    }

    // 从系统的$HOME/.bash_history中恢复命令历史
    public function restoreRC()
    {
        $hiscnt = 200;

        // history
        $bash_history_file = getenv('HOME').'/.bash_history';
        $htsh_history_file = $this->_history_file;
        if (!file_exists($htsh_history_file)) {
            $htsh_history_file = $bash_history_file;
        }
        
        if (file_exists($htsh_history_file)) {
            $bash_history = file($htsh_history_file);
            $allcnt = count($bash_history);
            if ($allcnt > 0) {
                for ($i = $allcnt - 1; $i >= 0; $i --) {
                    $history_cmd = trim($bash_history[$i]);
                    if (!empty($history_cmd) && $hiscnt -- > 0) {
                        readline_add_history($history_cmd);
                    }
                }
            }
        }
    }

    public function handleSignals()
    {
        pcntl_signal(SIGINT, array($this, 'signal_handler'), true);
    }

    public function signal_handler($signal) {
        switch($signal) {
        case SIGTERM:
            // print "Caught SIGTERM\n";
            exit;
        case SIGKILL:
            // print "Caught SIGKILL\n";
            exit;
        case SIGINT:
            if ($this->_hcurl) {
                // curl_close($this->_hcurl);
            }
            // print "Caught SIGINT\n";
            // exit;
            break;
        }
    }

    public function readio_handler($ret)
    {
        echo "you entered: {$ret}\n";
        $this->_inputLine = $ret;

        // readline_callback_handler_install('acdefg'.rand() . ':', array($this, 'readio_handler'));
        // readline_callback_handler_remove();
        $this->_inputFinished = true;
    }

    /**
     * 可以处理IO的readline
     */
    public function readio_readline($prompt)
    {
        readline_callback_handler_install($prompt, array($this, 'readio_handler'));

        $this->_inputLine = '';
        $this->_inputFinished = false;
        while (!$this->_inputFinished) {
            $w = NULL;
            $e = NULL;
            $r = array(STDIN);
            $n = @stream_select($r, $w, $e, null);
            // var_dump($n, $r, $w, $e);
            if ($n === false) {
                // echo "io incrupt\n";
                // exit;
            } else if ($n && in_array(STDIN, $r)) {
                // read a character, will call the callback when a newline is entered
                readline_callback_read_char();

                $rli = readline_info();
                // print_r($rli);
            }
        }

        return $this->_inputLine;
    }

    protected function quit()
    {
        var_dump(readline_write_history($this->_history_file));
        exit(0);
    }

    protected function helpInit()
    {
        // command => desc
        $this->_helps = 
            $helps = 
            array('switch2host' => '<url> <bindip> switch to url and bind to ip xxx',
                  'switch2ip' => '<bindip> bind current url to ip xxx',
                  'history' => 'show command history list',
                  'help|usage' => 'show htsh usage',
                  'push' => '<local-file> <remote-file> upload local file to remote',
                  'lcd' => '<directory> change local dir to directory',
                  'version' => 'show htsh version',
                  'exit|bye' => 'quit htsh command line',
                  );
    }

    protected function help()
    {
        // command => desc
        $helps = $this->_helps;

        foreach ($helps as $cmd => $desc) {
            echo "{$cmd} {$desc}\n";
        }

    }

    protected function version()
    {

    }

    protected function initEnv()
    {

    }
};
