# ffmpeg -i "http://host/folder/file.m3u8" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 file.mp4

url=$1
tofile=file.mp4
if [ x"$2" != x"" ]
	tofile=$2
fi

ffmpeg -i "$url" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "$tofile"
