<?php
/*
  公元纪年与干支纪年的换算
  公元前纪年与干支纪年的换算
 */

$tiangan_pairs = array("甲" => 4, "乙" => 5, "丙" => 6, 
                       "丁" => 7, "戊" => 8, "已" => 9,
                       "庚" => 10,
                       "辛" => 1, "壬" => 2, "癸" => 3);
$dizhi_pairs = array("子" => 4, "丑" => 5, "寅" => 6,
                     "卯" => 7, "辰" => 8, "巳" => 9,
                     "午" => 10, "未" => 11, "申" => 12,
                     "酉" => 1, "戌" => 2, "亥" => 3);

/*
  将公元纪年换算成干支纪年，以公元年的尾数在天干中找出相对应。然后，将公元纪年除以12，用余数在地支中找出所对应的地支。
 */
function nian_gongyan_to_ganzhi($gy_year)
{
    $gz_year = "";

    $tail_num = substr($gy_year, strlen($gy_year)-1, 1);
    $dz_num = $gy_year % 12;
    
    $tg_sym = "";
    $dz_sym = "";

    global $tiangan_pairs;
    global $dizhi_pairs;

    foreach ($tiangan_pairs as $sym => $num) {
        if ($tail_num == $num) {
            $tg_sym = $sym;
        }
    }

    foreach ($dizhi_pairs as $sym => $num) {
        if ($dz_num == $num) {
            $dz_sym = $sym;
        }
    }

    $gz_year = $tg_sym . $dz_sym;

    return $gz_year;
}

$gy_year = 1989;
// echo "公元$gy_year 是 " . nian_gongyan_to_ganzhi($gy_year) . "年";

$qian_tiangan_pairs = array("甲" => 7, "乙" => 6, "丙" => 5, 
                            "丁" => 4, "戊" => 3, "已" => 2,
                            "庚" => 1,
                            "辛" => 10, "壬" => 9, "癸" => 8);
$qian_dizhi_pairs = array("子" => 9, "丑" => 8, "寅" => 7,
                          "卯" => 6, "辰" => 5, "巳" => 4,
                          "午" => 3, "未" => 2, "申" => 1,
                          "酉" => 12, "戌" => 11, "亥" => 10);


/*
  用尾数5取天干中的“丙”； 155除以12得余数11，对应地支中的“戌”。
 */

function nian_gongyanqian_to_ganzhi($gyq_year)
{
    $gz_year = "";

    $tail_num = substr($gyq_year, strlen($gyq_year)-1, 1);
    $dz_num = $gyq_year % 12;
    
    $tg_sym = "";
    $dz_sym = "";

    global $qian_tiangan_pairs;
    global $qian_dizhi_pairs;

    foreach ($qian_tiangan_pairs as $sym => $num) {
        if ($tail_num == $num) {
            $tg_sym = $sym;
        }
    }

    foreach ($qian_dizhi_pairs as $sym => $num) {
        if ($dz_num == $num) {
            $dz_sym = $sym;
        }
    }

    $gz_year = $tg_sym . $dz_sym;

    return $gz_year;
}

$gyq_year = 155;
// echo "公元前$gyq_year 是 " . nian_gongyanqian_to_ganzhi($gyq_year) . "年";

///////////////////
function day_gongyuan_to_ganzhi($gy_day)
{
    global $tiangan_pairs, $dizhi_pairs;
    $tg_idx = 0;
    $dz_idx = 0;
    $tgs = array_keys($tiangan_pairs);
    $dzs = array_keys($dizhi_pairs);

    // print_r($tgs);
    // print_r($dzs);

    for ($i = 1; $i < $gy_day; ++$i) {
        $tg_idx ++;
        $dz_idx ++;

        if ($tg_idx == 10) {
            $tg_idx = 0;
        }

        if ($dz_idx == 12) {
            $dz_idx = 0;
        }
    }

    $gz_day = $tgs[$tg_idx] . $dzs[$dz_idx];

    return $gz_day;
}

function test_day_gongyuan_to_ganzhi()
{
    for ($i = 1; $i <= 60; ++$i) {
        $gz_day = day_gongyuan_to_ganzhi($i);
        echo  "$i = $gz_day \n";
    }
}
// test_day_gongyuan_to_ganzhi();
// echo day_gongyuan_to_ganzhi(10);

function day_ganzhi_to_gongyuan($gz_day)
{
    global $tiangan_pairs, $dizhi_pairs;
    $tg_idx = 0;
    $dz_idx = 0;
    $tgs = array_keys($tiangan_pairs);
    $dzs = array_keys($dizhi_pairs);

    // print_r($tgs);
    // print_r($dzs);

    for ($i = 1; $i <= 60; ++$i) {
        $tmp_gz_day = $tgs[$tg_idx] . $dzs[$dz_idx];

        if ($tmp_gz_day == $gz_day) {
            return $i;
        }

        $tg_idx ++;
        $dz_idx ++;

        if ($tg_idx == 10) {
            $tg_idx = 0;
        }

        if ($dz_idx == 12) {
            $dz_idx = 0;
        }
    }

    return -1;
}

function test_day_ganzhi_to_gongyuan()
{
    for ($i = 1; $i <= 60; ++$i) {
        $gz_day = day_gongyuan_to_ganzhi($i);
        $gy_day = day_ganzhi_to_gongyuan($gz_day);

        echo "$i ==? $gz_day ==? $gy_day \n";
    }
}

test_day_ganzhi_to_gongyuan();
// echo day_ganzhi_to_gongyuan("丁酉");