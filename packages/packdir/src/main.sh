
main() {
  local dirpath=$(realpath $1)
  local dirname=$(dirname $dirpath)
  local basename=$(basename $dirpath)
  local packname=$dirname/${basename}_$(date +'%Y%m%d').zip
  local current_pwd=$PWD

  cd "${dirpath}"
  echo "Packing ($basename): $dirpath"
  local first_file=$(find * -type f | head -n 1)
  #echo "First file: $first_file"
  zip -or "${packname}" "$first_file"
  find * -type f | while read file; do
    zip -uor "${packname}" "${file}"
  done

  cd "${current_pwd}"
}

test_main() {
  main /tmp/
}
