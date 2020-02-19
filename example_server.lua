local lsp = require('tarantool-lsp')
local http = require('http.server')
local http_router = require('http.router')
local httpd = http.new('0.0.0.0', '5050')
local router = http_router.new()
httpd:set_router(router)

