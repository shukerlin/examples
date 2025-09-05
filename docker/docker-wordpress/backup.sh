#!/bin/bash
# 一键备份 WordPress (数据库 + wp-content)

BACKUP_DIR=./backup_$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

echo "[1/2] 备份数据库..."
docker exec wordpress_db \
  mysqldump -u wpuser -pwppass wordpress > $BACKUP_DIR/wordpress.sql

echo "[2/2] 备份 wp-content 文件..."
docker run --rm \
  -v wordpress_wp_data:/data \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/wp_data.tar.gz -C /data .

echo "✅ 备份完成: $BACKUP_DIR"
