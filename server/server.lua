local QBCore = exports['qb-core']:GetCoreObject()

---@return string|osdate
function GetServerTime()
    local time = os.date('*t')
    return time
end

RegisterNetEvent('js-debug-getDebug-server', function(args)
    local time = GetServerTime()
    local msg
    if not args.value then msg = SetMsg{time = time, level = args.level, msg = args.msg}
    else msg = SetMsg{time = time, level = args.level, msg = args.msg, value = args.value} end
    if type(msg) == 'nil' then TriggerEvent('js-debug-getDebug-server',{level = 0, msg = "Output found as nil"})
    else print(msg) end
end)