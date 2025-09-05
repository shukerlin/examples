#!/bin/bash
# 一键备份 GitLab (配置 + 数据 + 日志)

BACKUP_DIR=./backup_$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

echo "[1/3] 备份 GitLab 配置..."
docker run --rm \
  -v gitlab_config:/etc/gitlab \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/gitlab_config.tar.gz -C /etc/gitlab .

echo "[2/3] 备份 GitLab 数据..."
docker run --rm \
  -v gitlab_data:/var/opt/gitlab \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/gitlab_data.tar.gz -C /var/opt/gitlab .

echo "[3/3] 备份 GitLab 日志..."
docker run --rm \
  -v gitlab_logs:/var/log/gitlab \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/gitlab_logs.tar.gz -C /var/log/gitlab .

echo "✅ 备份完成: $BACKUP_DIR"
