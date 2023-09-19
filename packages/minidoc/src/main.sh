
main() {
  if [ ! -f "README.md" ]; then
    echo "No README.md found"
    exit 1
  fi

  local docs_dir="$1"
  local docs_section="$2"


}
