number=$1

while read -r ip; do
    if [[ "$ip" =~ ^[[:space:]]*$ || "$ip" =~ ^\s*# ]]; then
        continue
    fi

    ping -c 2 "$ip" > number.txt
done < "node_list"

echo $number
echo $number >> number.txt
echo "start deployment" >> number.txt
echo $(date +'%s.%N') >> number.txt
. ./script/$number.sh > /dev/null 2>&1 &

. ./checking_deployment_kpush.sh $number &
. ./checking_kpush.sh $number

exec -a tophub bash -c "./script/tophub.sh" > /dev/null 2>&1 &

sudo tcpdump -i ens3 -nn -q '(src net 10.176.0.0/16 and dst net 10.176.0.0/16) and not arp' >> cross &

echo "wait for 900 secs"
for (( i=900; i>0; i-- )); do
    echo -ne "\r$i secs remaining..."
    sleep 1
done