#!/bin/bash

rm -rf .tnt-doc
rm -rf ./tarantool-lsp/completions
./bin/tarantool-lsp docs init
mv ./completions ./tarantool-lsp/completions
