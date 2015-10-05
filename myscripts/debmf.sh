# sudo apt-get -y -qq --print-uris upgrade | awk -F"'" '{print $2}'| sudo xargs aria2c -d /var/cache/apt/archives/
pkgs="install kdeplasma-addons kdewallpapers  digikam"
pkgs="upgrade"
debs=`sudo apt-get -y -qq --print-uris $pkgs | awk -F"'" '{print $2}'`

function sig_handle
{
    echo "catch exit signal, exit now.";
    exit;
}

trap sig_handle SIGINT

cnt=0
for deb in $debs
do
	cnt=`expr $cnt + 1`
done

idx=1
for deb in $debs
do
	echo "Fetching [$idx/$cnt] $deb ..."
	sudo aria2c -x 5 -k 1M -c -d /var/cache/apt/archives/ $deb

	idx=`expr $idx + 1`
done
