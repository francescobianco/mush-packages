
main() {
  local speedtest=https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
  curl -s "${speedtest}" | python3 - --simple
}
