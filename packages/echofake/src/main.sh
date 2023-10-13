
main() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: echofake <command>"
    return 1
  fi

  script -q /dev/null -c "$*" > output.log
  script -q /dev/null -c "$*" | while read -r line; do
    line=$(echo -n "$line" |
      tr -d '\r' | sed 's/`/\\`/g' | sed 's/"/\\"/g' | cat -A - |
      sed 's/\^\[/\\e/g' | sed 's/\^\I/\\t/g' )
    echo -en "\r"
    echo "echo -e \"$line\""
  done
  echo -en "\r"
}
