#!/bin/sh

# format 
# #EXTM3U
# #EXTINF:0,vvv,
# mms://fff
# #EXTINF:0,fff,
# mms://ttt

############ html mode
######1         #########2

# http://radioget.googlecode.com/svn/trunk/radiolist.xml
radio_get_xml=$HOME/.config/smplayer/radiolist.xml
smplayer_audio_file=$HOME/.config/smplayer/radio.m3u8
temp_audio_file=/tmp/radio.m3u8
temp_html_file=/tmp/radioget.html

if [ -f $radio_get_xml ] ; then
    mv -v $radio_get_xml ${radio_get_xml}.bak
    true
fi

wget -O $radio_get_xml http://radioget.googlecode.com/svn/trunk/radiolist.xml

echo "#EXTM3U" > $temp_audio_file


###############to html
cat <<EOF > $temp_html_file
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <style type="text/css">
    <!--
      #list {width: 800px;float:left; list-style:disc outside; color:#000; line-height:30px }
      #list li {float:left;}
      #list li a{display:block;float:left; width: 380px; }
    -->
    </style>
</head>
<body>
    <p>在线广播/电视:</p>
    <ul id="list">
EOF

radio_caty=
while read radio
do
    # echo $radio
    xml_ver_line=`echo $radio|grep "xml version"`
    xml_root_line=`echo $radio|grep "RadioGet"`
    radio_cat_line=`echo $radio|grep "radiotag"`
    radio_addr_line=`echo $radio|grep "url"`

    if [ x"$xml_ver_line" = x"" ] ; then
        true;
    else
        continue;
    fi

    if [ x"$xml_root_line" = x"" ] ; then
        true;
    else
        continue;
    fi

    if [ x"$radio_cat_line" = x"" ] ; then
        true;
    else
        radio_caty=`echo $radio|awk -F\" '{print $2}'`
        
        if [ x"$radio_caty" = x"" ] ; then
            # echo $radio_caty
            true;
        fi
        continue;
    fi

    if [ x"$radio_addr_line" = x"" ] ; then
        true;
    else
        radio_addr=`echo $radio|awk -F\" '{print $4}'`
        radio_name=`echo $radio|awk -F\" '{print $2}'`
        if [ "$radio_name" = "true" ] ; then
            radio_addr=`echo $radio|awk -F\" '{print $6}'`
            radio_name=`echo $radio|awk -F\" '{print $4}'`
        fi

        echo $radio_caty "->" $radio_name "->" $radio_addr
        echo "#EXTINF:0,${radio_caty}->${radio_name}," >> $temp_audio_file
        echo "$radio_addr" >> $temp_audio_file

        #####to html
        echo "<li><a href=\"${radio_addr}\">${radio_caty}->${radio_name}</a></li>" >> $temp_html_file
        
    fi

done < $radio_get_xml

mv -v $smplayer_audio_file ${smplayer_audio_file}.bak
cp -v $temp_audio_file ${smplayer_audio_file}

####### to html
echo "</ul></body></html>" >> $temp_html_file