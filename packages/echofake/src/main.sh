
main() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: echofake <command>"
    return 1
  fi

  script -q /dev/null -c "$*" 2>&1 | while read -r line; do
    line=$(echo -n "$line" | tr -d '\r' | cat -A - |
      sed 's/`/\\`/g' | sed 's/"/\\"/g' | sed 's/\^\[/\\e/g' | sed 's/\^\I/\\t/g' )
    printf "echo -e \"%s\"\r\n" "${line}"
  done
}
