
# 当前的连接ip的地理位置批量查询
ips=$(ss -ant|grep 33445|grep ESTAB|awk '{print $5}'|awk -F: '{print $1}')
for ip in $ips; do
    # echo "$ip"
    CTLINE=$(geoiplookup "$ip"|head -n 1|awk '{print $4}')
    echo "$CTLINE $ip"
done

