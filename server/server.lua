local QBCore = exports['qb-core']:GetCoreObject()
TimerQueue = TimerQueue or {}

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

RegisterNetEvent('js-debug-timer', function(start, name)
    if start then
        local t1 = GetServerTime()
        t1 = os.time(t1)
        table.insert(TimerQueue, {name = name, t1 = t1, t2 = nil})
        TriggerEvent('js-debug-getDebug-server', {level = 1, msg = "Timer: "..name.." Started"})
    elseif not start then
        local t1
        local t2 = GetServerTime()
        t2 = os.time(t2)
        for i,v in pairs(TimerQueue) do
            if name == v.name then
                t1 = v.t1
                TimerQueue[i].t2 = t2
                break
        end end
        local diffTime = GetDiff(t2,t1)
        TriggerEvent('js-debug-getDebug-server', {level = 1, msg = "Timer: "..name.." Stopped", value = diffTime})
    end
end)