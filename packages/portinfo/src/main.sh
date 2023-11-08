
main() {
  local port
  local pid

  port=$1

  pid=$(netstat -aon | grep "$port" | grep LISTEN | awk '{print $5}' | xargs kill -9 || true)

  ps -u --pid "${pid}"
}
