read -p "please enter the test number(2000, 4000, 6000, 8000, 10000): " number

for (( i=10; i>0; i-- )); do
    . ./02_run_stress_kpull.sh $number
    sleep 60
    . ./reset.sh
done