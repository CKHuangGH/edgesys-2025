read -p "please enter the test number(1, 50, 100, 150, 200): " number

for (( times=0; times<10; times++ )); do
    . ./init_reg.sh
    sleep 30
    mkdir results
    . ./02_run_stress_kpush.sh $number
    . ./03.getdocker.sh $number $times
    sleep 30
    . ./reset.sh $number
    rm -rf results
    sleep 60
done