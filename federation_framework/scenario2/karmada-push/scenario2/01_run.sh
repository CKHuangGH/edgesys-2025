read -p "please enter the test number(2000, 4000, 6000, 8000, 10000): " number

for (( times=0; times<3; times++ )); do
    . ./init_reg.sh
    sleep 40
    mkdir results
    . ./02_run_stress_kpush.sh $number
    . ./03.getdocker.sh $number $times
    sleep 20
    . ./reset.sh
    rm -rf results
    sleep 60
done