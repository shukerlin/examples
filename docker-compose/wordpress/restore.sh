#!/bin/bash
# 一键恢复 WordPress

if [ -z "$1" ]; then
  echo "用法: ./restore.sh <备份目录>"
  exit 1
fi

BACKUP_DIR=$1

echo "[1/2] 导入数据库..."
docker cp $BACKUP_DIR/wordpress.sql wordpress_db:/wordpress.sql
docker exec wordpress_db \
  sh -c "mysql -u wpuser -pwppass wordpress < /wordpress.sql"

echo "[2/2] 还原 wp-content 文件..."
docker run --rm \
  -v wordpress_wp_data:/data \
  -v $BACKUP_DIR:/backup \
  alpine sh -c "cd /data && tar xzf /backup/wp_data.tar.gz"

echo "✅ 恢复完成"
