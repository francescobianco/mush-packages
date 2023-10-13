
main() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: echofake <command>"
    return 1
  fi

  script -q /dev/null -c "$*" > output.log

  while read -r line; do
    echo -n "$line" | tr '\r' '\n' | while read -r subline; do
      subline=$(echo -n "${subline}" | cat -A - | sed 's/`/\\`/g' | sed 's/"/\\"/g' | sed 's/\^\[/\\e/g' | sed 's/\^\I/\\t/g' )
      printf "echo -e \"%s\"\r\n" "${subline}"
    done
  done < output.log
}
