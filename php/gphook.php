<?php
/*
  简单gitlab自动部署钩子
  把仓库中的php代码更新到本地指定目录。
  刚算能用，代码很丑，以后整理。
 */
function repo_url_conv($git_url)
{
    $reg = '/git@git.yourhost.com:(.*)\/(.*)\.git/';
    if (preg_match($reg, $git_url, $mats)) {
        $http_url = "https://git.yourhost.com/{$mats[1]}/{$mats[2]}.git";
        return $http_url;
    }
    return $git_url;
}

/*
  格式文档：https://git.yourhost.com/help/web_hooks/web_hooks.md#push-events
  POST /gphook.php HTTP/1.1

  {"before":"077a85dd266e6f3573ef7e9ef8ce3343ad659c4e","after":"95cd4a99e93bc4bbabacfa2cd10e6725b1403c60",<SNIP>}
 */
echo rand() . "\n";

$time = microtime();
$log = var_export($_SERVER, true);
$file_path = dirname(__FILE__) . '/var/logs/gphook.log';
$post_data = var_export($_POST, true) . var_export($HTTP_RAW_POST_DATA, true);
$nw = file_put_contents($file_path, "{$time}\n{$log},\n{$post_data}\n===============\n\n", FILE_APPEND);
var_dump($nw);


$json_event = $HTTP_RAW_POST_DATA;
$event = json_decode($json_event, true);

$copy_dir = dirname(__FILE__) . '/var/store';
$repo_url = $event['repository']['url'];
$repo_name = strtolower($event['repository']['name']);
$copy_path = $copy_dir . '/' . $repo_name;

// repo需要是public的，这样只读取的，不需要账号。
if ($repo_name == 'mytest') {
    $http_repo_url = repo_url_conv($repo_url);
    $output = array();
    $retvar = 0;
    $cmd = '';
    if (file_exists($copy_path)) {
        $cmd = "cd $copy_path && git pull origin master";
        $last_line = exec($cmd, $output, $retvar);
    } else {
        $cmd = "git clone {$http_repo_url} $copy_path";
        $last_line = exec($cmd, $output, $retvar);
    }

    $output = implode("\n", $output);
    $nw = file_put_contents($file_path, "{$cmd},{$last_line}, {$output}, $retvar\n", FILE_APPEND);
} else {
    $nw = file_put_contents($file_path, "not cared repo: {$repo_name}\n", FILE_APPEND);
}



