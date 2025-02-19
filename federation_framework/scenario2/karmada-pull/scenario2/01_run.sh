read -p "please enter the test number(1, 50, 100, 150, 200): " number

for (( times=0; times<10; times++ )); do
    . ./init_reg.sh
    sleep 40
    mkdir results
    . ./02_run_stress_kpull.sh $number
    . ./03.getdocker.sh $number $times
    sleep 20
    for ip in $(cat node_exec)
    do 
	    ssh root@$ip . /root/edgesys-2025/federation_framework/scenario2/karmada-pull/scenario2/reset_worker.sh
    done
    . ./reset.sh $number
    rm -rf results
    sleep 60
done