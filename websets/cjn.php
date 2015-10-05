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

function day_ganzhi_to_gongyuan_old($gz_day)
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

function day_ganzhi_to_gongyuan($gz_day)
{
    global $tiangan_pairs, $dizhi_pairs;
    // $tg_idx = 0;
    // $dz_idx = 0;
    $tgs = array_keys($tiangan_pairs);
    $dzs = array_keys($dizhi_pairs);

    $tgki = array();
    $dzki = array();

    foreach ($tgs as $idx => $key) {
        $tgki[$key] = $idx+1;
    }

    foreach($dzs as $idx => $key) {
        $dzki[$key] = $idx+1;
    }

    // print_r($tgki);
    // print_r($dzki);

    $gy_day = -1;

    $mch1 = substr($gz_day, 0, 3);
    $mch2 = substr($gz_day, 3, 3);
    $idx1 = $tgki[$mch1];
    $idx2 = $dzki[$mch2];

    // echo $mch1 . " $idx1 -- " . $mch2 . " $idx2 \n";

    $gy_day = $tgki[$mch1];
    $diff12 = ($tgki[$mch1] - $dzki[$mch2] + 12) % 12;
    $gy_day += 10 * $diff12/2;

    return $gy_day;
    return -1;
}

function test_day_ganzhi_to_gongyuan()
{
    global $tiangan_pairs, $dizhi_pairs;
    $tg_idx = 0;
    $dz_idx = 0;
    $tgs = array_keys($tiangan_pairs);
    $dzs = array_keys($dizhi_pairs);

    $mch1 = "";
    $mch2 = "";

    for ($i = 1; $i <= 60; ++$i) {
        $gz_day = day_gongyuan_to_ganzhi($i);
        $gy_day = day_ganzhi_to_gongyuan($gz_day);

        $idx1 = 0;
        $idx2 = 0;
        $mch1 = substr($gz_day, 0, 3);
        $mch2 = substr($gz_day, 3, 3);

        // echo strlen($gz_day) . "$mch1 , $mch2 \n";
        for ($j = 0; $j < count($tgs); ++$j) {
            if ($tgs[$j] == $mch1) {
                $idx1 = $j + 1;
                break;
            }
        }

        for ($j = 0; $j < count($dzs); ++$j) {
            if ($dzs[$j] == $mch2) {
                $idx2 = $j + 1;
                break;
            }
        }

        // $idx1 = $tiangan_pairs[$mch1];
        // $idx2 = $dizhi_pairs[$mch2];
        
        $d12 = ($idx1 - $idx2 + 12) % 12;
        $rd12_div2 = $d12 / 2;
        echo "$i ==? $gz_day ==? $gy_day, $mch1($idx1)-$mch2($idx2)=$d12 => r/2($rd12_div2)\n";

        // break;
    }
}

test_day_ganzhi_to_gongyuan();
// echo day_ganzhi_to_gongyuan("丁酉");

/*
  60六十花甲子规律：
  第一位的天干的顺序号为阿拉伯数字日期的个位
  第一位序号与第二位序号的差加12的和模12,然后再除以2,其结果为阿拉伯数据日期的十位
  
 */