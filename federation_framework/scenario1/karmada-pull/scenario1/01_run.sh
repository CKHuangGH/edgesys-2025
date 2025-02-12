read -p "please enter the test number(2000, 4000, 6000, 8000, 10000): " number

for (( i=0; i<3; i++ )); do
    mkdir results
    . ./02_run_stress_kpull.sh $number
    . ./03.getdocker.sh $number $i
    sleep 6
    . ./reset.sh
    rm -rf results
done