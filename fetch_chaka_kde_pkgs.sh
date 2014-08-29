grep "4.10.0" index.html.1  | awk -F\" '{print $2}'

chaka_pkg_url="http://chakra-project.org/repo/testing/x86_64/"

mkdir -pv chakra_kde

for p in `grep "4.10.0" index.html.1  | awk -F\" '{print $2}'`
do
	furl=${chaka_pkg_url}/$p
	set -x
	aria2c -x 5 -k 1M -d ./chakra_kde/ $furl
	set +x
done
