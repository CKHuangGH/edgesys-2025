read -p "please enter the test number(2000, 4000, 6000, 8000, 10000): " number

for (( times=0; times<3; times++ )); do
    . ./init_reg.sh
    sleep 40
    mkdir results
    . ./02_run_stress_ocm.sh $number
    . ./03.getdocker.sh $number $times
    sleep 20
    . ./reset.sh
    for ip in $(cat node_exec)
    do 
	    ssh root@$ip . /root/edgesys-2025/federation_framework/scenario1/ocm/scenario1/reset_worker.sh
    done
    rm -rf results
    sleep 60
done