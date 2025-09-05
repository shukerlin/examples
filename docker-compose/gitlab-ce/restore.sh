#!/bin/bash
# 一键恢复 GitLab

if [ -z "$1" ]; then
  echo "用法: ./restore.sh <备份目录>"
  exit 1
fi

BACKUP_DIR=$1

echo "[1/3] 恢复 GitLab 配置..."
docker run --rm \
  -v gitlab_config:/etc/gitlab \
  -v $BACKUP_DIR:/backup \
  alpine sh -c "cd /etc/gitlab && tar xzf /backup/gitlab_config.tar.gz"

echo "[2/3] 恢复 GitLab 数据..."
docker run --rm \
  -v gitlab_data:/var/opt/gitlab \
  -v $BACKUP_DIR:/backup \
  alpine sh -c "cd /var/opt/gitlab && tar xzf /backup/gitlab_data.tar.gz"

echo "[3/3] 恢复 GitLab 日志..."
docker run --rm \
  -v gitlab_logs:/var/log/gitlab \
  -v $BACKUP_DIR:/backup \
  alpine sh -c "cd /var/log/gitlab && tar xzf /backup/gitlab_logs.tar.gz"

echo "✅ 恢复完成"
