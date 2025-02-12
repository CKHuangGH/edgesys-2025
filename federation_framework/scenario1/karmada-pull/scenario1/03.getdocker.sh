number=$1
time=$2
j=1

for i in $(cat node_exec)
do 
	scp root@$i:/root/kubetopPodWA.csv /root/edgesys-2025/federation_framework/scenario1/karmada-pull/scenario1/results/kubetopPodWA.csv
	j=$((j+1))	
done
mv kubetopPodHUB.csv /root/edgesys-2025/federation_framework/scenario1/karmada-pull/scenario1/results/kubetopPodHUB.csv
mv cross /root/edgesys-2025/federation_framework/scenario1/karmada-pull/scenario1/results/cross
mv number.txt /root/edgesys-2025/federation_framework/scenario1/karmada-pull/scenario1/results/number.txt
sleep 5
random_number=$((1 + $RANDOM))
scp -o StrictHostKeyChecking=no -r /root/edgesys-2025/federation_framework/scenario1/karmada-pull/scenario1/results chuang@172.16.111.106:/home/chuang/results$number-$time-karmada-pull

echo "-----------------------copy ok -------------------------------"