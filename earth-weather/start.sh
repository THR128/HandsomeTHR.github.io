#!/bin/bash
cd "$(dirname "$0")" || exit

echo "========================================"
echo "  地球实时天气系统 - 本地服务器启动器"
echo "========================================"
echo ""

PYTHON_CMD=""
for cmd in python3 python; do
  if command -v "$cmd" >/dev/null 2>&1; then
    PYTHON_CMD="$cmd"
    break
  fi
done

if [ -z "$PYTHON_CMD" ]; then
  echo "[错误] 未找到 Python，请先安装 Python 3。"
  echo "安装地址：https://www.python.org/downloads/"
  exit 1
fi

echo "使用 Python 命令：$PYTHON_CMD"
echo "服务器地址：http://localhost:8080"
echo "按 Ctrl+C 停止服务"
echo ""

$PYTHON_CMD -m http.server 8080 &
SERVER_PID=$!
sleep 1

if command -v open >/dev/null 2>&1; then
  open "http://localhost:8080"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "http://localhost:8080"
fi

wait $SERVER_PID
