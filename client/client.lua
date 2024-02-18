local QBCore = exports['qb-core']:GetCoreObject()

-- js-debug debugger
-- RegisterCommand('getDebug', function(source,args)
--     local where = args[1] + 0
--     local level = args[2] + 0
--     local value
--     if args[4] ~= nil then value = args[4] else value = nil end
--     TriggerDebug{dest = where, level = level, msg = args[3], value = value}
-- end, false)

RegisterNetEvent('js-debug-getDebug-chat', function(args)
    local msg
    if not args.value then msg = SetMsg{level = args.level, msg = args.msg, value = args.value} else SetMsg{level = args.level, msg = args.msg} end
    TriggerEvent('chat:addMessage', {
        multiline = false,
        args = {"DEBUG", msg}
      })
end)

RegisterNetEvent('js-debug-getDebug-console', function(args)
    local msg
    if not args.value then msg = SetMsg{level = args.level, msg = args.msg}
    else msg = SetMsg{level = args.level, msg = args.msg, value = args.value} end
    if type(msg) == 'nil' then TriggerEvent('js-debug-getDebug-console',{level = 0, msg = "Output found as nil"})
    else print(msg) end
end)