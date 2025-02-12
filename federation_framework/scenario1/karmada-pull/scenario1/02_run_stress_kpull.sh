number=$1
echo $number
echo $number >> number.txt
echo "start deployment" >> number.txt
echo $(date +'%s.%N') >> number.txt
. ./script/$number.sh > /dev/null &

# . ./checking_deployment_kpull.sh $number &
# . ./checking_kpull.sh $number

. ./script/tophub.sh > /dev/null &

for i in $(cat node_exec)
do 
	ssh root@$i . /root/edgesys-2025/federation_framework/scenario1/karmada-pull/scenario1/script/toppodwa.sh > /dev/null &
done

sudo tcpdump -i ens3 -nn -q '(src net 10.176.0.0/16 and dst net 10.176.0.0/16) and not arp' >> cross > /dev/null &

echo "wait for 900 secs"
for (( i=9; i>0; i-- )); do
    echo "$i secs..."
    sleep 1
done