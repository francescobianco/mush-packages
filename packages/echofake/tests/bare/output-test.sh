#!/bin/bash

mush run -- bash tests/fixtures/real-output.sh > tests/fixtures/fake-output.sh

echo "====[ REAL ]===="
bash tests/fixtures/real-output.sh
echo "====[ FAKE ]===="
bash tests/fixtures/fake-output.sh


