#!/bin/bash

echo "Searching for and terminating tcpdump-related processes..."
PIDS=$(pgrep -f "tcpdump")

if [ -n "$PIDS" ]; then
    echo "Found the following processes: $PIDS"
    kill -9 $PIDS
    echo "All tcpdump processes have been terminated."
else
    echo "No tcpdump processes found."
fi

echo "Searching for and terminating bash-related processes..."
PIDS=$(pgrep -f "tophub")

if [ -n "$PIDS" ]; then
    echo "Found the following processes: $PIDS"
    kill -9 $PIDS
    echo "All bash processes have been terminated."
else
    echo "No bash processes found."
fi

echo "Searching for and terminating bash-related processes..."
PIDS=$(pgrep -f "toppodwa")

if [ -n "$PIDS" ]; then
    echo "Found the following processes: $PIDS"
    kill -9 $PIDS
    echo "All bash processes have been terminated."
else
    echo "No bash processes found."
fi

# Loop through cluster numbers 1 to 100
for i in $(seq 1 1); do
    # Retrieve CSR names that match the pattern "cluster<i>-"
    csr_names=$(kubectl get csr --no-headers -o custom-columns=NAME:.metadata.name | grep "^cluster${i}-")
    
    # If no CSR is found for this cluster number, output a message and continue to the next number.
    if [ -z "$csr_names" ]; then
        echo "No CSR found for cluster${i}"
        continue
    fi

    # Loop through each CSR name that matches the pattern and delete it.
    for csr in $csr_names; do
        echo "Deleting CSR: $csr"
        kubectl delete csr "$csr"
    done
done

clusteradm clean

for ((i=1; i<=1; i++)); do
    kubectl delete ns cluster$i
done

rm -f ./number.txt
rm -f temp.sh
rm -f run.sh
rm -f run1.sh
rm -f ./kubetopPodHUB.csv