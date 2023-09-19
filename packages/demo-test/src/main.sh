
main () {

  echo "Hello world!"

}

test_main () {

  main | assert_equals "Hello world!"

}
