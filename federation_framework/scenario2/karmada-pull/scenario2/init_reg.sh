#!/bin/bash

# 檢查是否有傳入預期集群數量參數
if [ $# -lt 1 ]; then
    echo "Usage: $0 <expected_cluster_count>"
    exit 1
fi

expected_count=$1

# 設定 kubeconfig context 及初始化 karmada
kubectl config use-context cluster0
kubectl karmada init

# 取得註冊指令
REGISTER_CMD=$(kubectl karmada token create --print-register-command --kubeconfig=/etc/karmada/karmada-apiserver.config)

# 不斷執行註冊，直到集群數量達到指定數量
while true; do
    echo "開始執行節點註冊..."
    for c in $(cat node_list); do
        ssh root@$c "eval \"$REGISTER_CMD\""
    done

    # 等待一段時間讓註冊動作完成
    sleep 5

    # 取得目前集群數量
    current_count=$(kubectl get clusters --kubeconfig /etc/karmada/karmada-apiserver.config | tail -n +2 | wc -l)
    echo "目前已註冊集群數量：$current_count"

    # 判斷是否達到預期集群數量
    if [ "$current_count" -ge "$expected_count" ]; then
        echo "集群數量達到預期 ($expected_count) ，註冊完成。"
        break
    else
        echo "集群數量不足 (預期 $expected_count, 實際 $current_count)，將重新執行註冊。"
        # 可視需求調整等待時間
        sleep 5
    fi
done
