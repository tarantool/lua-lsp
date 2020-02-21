local rpc             = require 'tarantool-lsp.rpc'
local method_handlers = require 'tarantool-lsp.methods'
local ws              = require 'websocket'
local json            = require 'json'
local docs 	          = require 'tarantool-lsp.tnt-doc.doc-manager'

local handshake = require('websocket.handshake')
local fio = require('fio')
local log = require('log')

local DETACHED = 101

-- [path] = libraries
local completions_cache = {}

local create_handler = function(options)
    local path = debug.getinfo(1).source:match("@?(.*/)")

    log.info('Path: %s', path)

    local completion_dir = options and options.completion_root or fio.pathjoin(path, 'completions')
    if not completions_cache[completion_dir] then
        local libraries, err = docs:init({
            completions_dir =completion_dir
        })
        if err ~= nil then
            log.info("Docs subsystem error: %s", err)
            error(err)
        end
        completions_cache[completion_dir] = libraries
    end
    return function(req)
        local validated, errresp = handshake.validate_request(req)

        if validated then
            --log.info(req)
            req.s:write(
                handshake.reduce_response(
                    handshake.accept_upgrade(req)))
            local ws_peer = ws.new(req.s, 10, false, true, req)
            local config = {
                language = "5.1",
                builtins = {"5_1"},
                packagePath = {"./?.lua"},
                debugMode = false,
                documents = {},
                types = {},
                web_server = true,
                libraries = completions_cache[completion_dir],
                _useNativeLuacheck = false -- underscore means "experimental" here
            }
            while true do
                local message, err = ws_peer:read()
                if not message or message.opcode == nil then
                    break
                end
                local data = json.decode(message.data)
                if data.method then
                    -- request
                    if data.method == 'exit' then
                        return DETACHED
                    end
                    if not method_handlers[data.method] then
                        -- log.verbose("confused by %t", data)
                        err = string.format("%q: Not found/NYI", tostring(data.method))
                        if data.id then
                            rpc.respondError(data.id, err, "MethodNotFound")
                        else
                            --log.warning("%s", err)
                        end
                    else
                        local ok
                        ok, err = xpcall(function()
                            local response = method_handlers[data.method](config, data.params, data.id)
                            if response then
                                ws_peer:write(response)
                            end
                        end, debug.traceback)
                        if not ok then
                            if data.id then
                                local msgError = rpc.respondError(data.id, err, "InternalError")
                                ws_peer:write(msgError)
                            else
                                --local msgError = rpc.respondError(1, err, "InternalError")
                                --ws_peer:write(msgError)
                                log.info("%s", tostring(err))
                            end
                        end
                    end
                elseif data.result then
                    rpc.finish(data)
                elseif data.error then
                    log("client error:%s", data.error.message)
                end
            end
            return DETACHED
        else
            return {status=400, body="No way"}
        end
    end
end

return {
    create_handler = create_handler,
}
