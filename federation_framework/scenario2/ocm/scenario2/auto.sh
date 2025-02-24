#!/bin/bash

token_line=$(clusteradm get token | grep "clusteradm join")
join_cmd=$(echo "$token_line" | sed 's/--cluster-name <cluster_name>//')

echo "取得的 join 指令為："
echo "$join_cmd"
echo "========================================"

# (3) 依序讀取 node_list 對每個 Node 執行 join
i=1
while read -r node_ip; do
  # 跳過空行或被 '#' 註解掉的行
  [[ -z "$node_ip" || "$node_ip" =~ ^#.* ]] && continue

  # 自動命名 cluster name
  cluster_name="cluster${i}"
  echo "========================================"
  echo "開始處理 Node IP: $node_ip"
  echo "將命名為叢集：$cluster_name"
  echo "----------------------------------------"

  # (4) 使用「失敗重試」機制
  while true; do
    # 透過 SSH 執行 join 指令
    #   -n 代表不要從本地的 stdin 讀取，避免與 while 迴圈衝突
    #   2>&1 讓錯誤訊息也可以收集到 output 變數
    output=$(ssh -n root@"$node_ip" "${join_cmd} --wait --cluster-name $cluster_name" 2>&1)
    ret=$?

    # 印出遠端回傳的訊息
    echo "$output"

    # (5) 檢查結果：
    #    - exit code 為 0
    #    - 不含特定錯誤訊息 (例如 "Error: unexpected watch event received")
    if [[ $ret -eq 0 && "$output" != *"Error: unexpected watch event received"* ]]; then
      echo ">>> 加入叢集成功：$cluster_name on $node_ip"
      break
    else
      echo ">>> 加入叢集失敗 (node: $node_ip)。5 秒後重試..."
      sleep 5
    fi
  done

  i=$((i + 1))
done < "node_list"

echo "========================================"
echo "全部節點處理完畢！"