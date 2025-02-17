#!/bin/bash

# Function to accept clusters using the names provided in the node_list file.
accept_clusters() {
  while read -r cluster_name; do
    echo "Accepting cluster: $cluster_name"
    clusteradm accept --clusters "$cluster_name"
  done < node_list
}

# Function to calculate the adjusted namespace count
get_adjusted_ns_count() {
  # Get the total number of namespaces (excluding header) and subtract 6
  ns_count=$(kubectl get ns --no-headers | wc -l)
  echo $(( ns_count - 6 ))
}

# Repeat the cluster acceptance until the adjusted namespace count equals 100.
while true; do
  echo "Accepting clusters..."
  accept_clusters

  echo "Waiting 10 seconds for changes to propagate..."
  sleep 10

  adjusted_ns_count=$(get_adjusted_ns_count)
  echo "Current adjusted namespace count: $adjusted_ns_count"

  if [ "$adjusted_ns_count" -eq 1 ]; then
    echo "Desired namespace count of 1 reached."
    break
  else
    echo "Namespace count is not 100. Repeating cluster acceptance..."
  fi
done
