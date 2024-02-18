local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {}

Config.Returns = {
    Nil         = { Tipe = 'nil',       output = '[NIL]'        },
    Bool        = { Tipe = 'boolean',   Output = '[BOOL]'       },
    Int         = { Tipe = 'number',    Output = '[INT]'        },
    String      = { Tipe = 'string',    Output = '[STRING]'     },
    Table       = { Tipe = 'table',     Output = '[ARRAY]'      },
    Function    = { Tipe = 'function',  Output = '[FUNC]'       },
    Thread      = { Tipe = 'thread',    Output = '[THREAD]'     },
    UserData    = { Tipe = 'userdata',  Output = '[USERDATA]'   },
}

Config.DebugTypes = {
    { Name = 'Internal Error', String = 'FKNA', int = 0},
    { Name = 'Information', String = 'INFO', int = 1},
    { Name = 'Notification', String = 'NOTIF', int = 2},
    { Name = 'Warning', String = 'WARN', int = 3},
    { Name = 'Low Level Issue', String = 'ISSUE', int = 4},
    { Name = 'Error in Code', String = 'ERROR', int = 5},
    { Name = 'Critical Error', String = 'CRITICAL', int = 6},
    { Name = 'Fatal Error', String = 'FATAL', int = 66}
}

---@param args{level:number,msg:string,value?:any,time?:any}
function SetMsg(args)
    Msg = nil
    local lvl
    local time
    local val
    if args.time then time = args.time else time = GetTime() end
    local sTime = FormatTime{tipe = 'short', time = time}
    for i,v in ipairs(Config.DebugTypes) do
        if args.level == v.int then lvl = v.String break end
    end
    Msg = sTime..' ['..lvl..'] '..args.msg
    if type(args.value) ~= "nil" then Msg = Msg..' [Value]: '..args.value end
    if not Msg or Msg == '' or #Msg < 20 then Msg = FormatTime{tipe = 'short'}..' [CRITICAL]: Message Not Found' end
    return Msg
end

---@return table
function GetTime()
    local years, months, days, hours, minutes, seconds = Citizen.InvokeNative(0x50C7A99057A69748, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local time = {year = years, month = months, day = days, hour = hours, min = minutes, sec = seconds}
    ---@diagnostic disable-next-line
    return time
end

--- Format Time into one of two formats and return. File: Uses '-' and '.' Console: Uses '-' and '/' Error: Returns Time NOT Date
---@param args{tipe:string,time?:table}
---@diagnostic disable-next-line 
---@param tipe string
---|"'console'" # 0000/00/00 00:00:00
---|"'file'"    # 0000-00-00 00.00.00
---|"'short'"   # 00:00:00
function FormatTime(args)
    local tipe = args.tipe
    local time = args.time or GetTime()
    local formatted = nil
    if tipe == 'file' then
        formatted = string.format("%04d-%02d-%02d%2d.%02d.%02d", time.year,time.month,time.day,time.hour,time.min,time.sec)
    elseif tipe == 'console' then
        formatted = string.format("%04d/%02d/%02d%2d:%02d:%02d", time.year,time.month,time.day,time.hour,time.min,time.sec)
    elseif tipe == 'short' then
        formatted = string.format("%02d:%02d:%02d", time.hour,time.min,time.sec)
    end
    return formatted
end

---@param args{dest:number,level:number,msg:string,value?:any}
---@diagnostic disable-next-line
---@param dest number
---|"0" # -- Chat
---|"1" # -- Console
---|"2" # -- Server
---|"3" # -- Server+Console
---@diagnostic disable-next-line 
---@param level number
---|"0" # ---FKNA ----- Internal Error ---- Internal Error that should not occur. Fuckin' a
---|"1" # ---INFO ------- Information ----- Debug info or just a way to print to console
---|"2" # --NOTIFY ------ Notification ---- Notification of task completing or similar
---|"3" # ---WARN --------- Warning ------- Warning message. E.g. No Access etc.
---|"4" # ---ISSUE ---- Low Level Issue --- Low level issue i.e. a non-core function failure
---|"5" # --ERROR ---------- Error -------- Script Errored. Logged to file by server
---|"6" # -CRITICAL --- Critical Error ---- Error that may have broken some functionality
---|"66" # ---FATAL ----- Fatal Error ----- Encountered error that won't recover
function TriggerDebug(args)
    if args then
        local temp = { level = args.level, msg = args.msg }
        if type(args.value) ~= 'nil' then
            temp.value = args.value
            if args.dest < 0 or args.dest > 3 then TriggerEvent('js-debug-getDebug-chat', {level = 0, msg = "Destination value out of range", value = args.dest})
            elseif args.dest == 0 then TriggerEvent('js-debug-getDebug-chat', temp)
            elseif args.dest == 1 then TriggerEvent('js-debug-getDebug-console', temp)
            elseif args.dest == 2 then TriggerServerEvent('js-debug-getDebug-server', temp)
            elseif args.dest == 3 then
                TriggerEvent('js-debug-getDebug-console', temp)
                TriggerServerEvent('js-debug-getDebug-server', temp)
            end
            if args.dest < 0 or args.dest > 3 then TriggerEvent('js-debug-getDebug-chat', {level = 0, msg = "Destination value out of range", value = args.dest})
            elseif args.dest == 0 then 
            end
        elseif type(args.value) == 'nil' then
            if args.dest == 0 then TriggerEvent('js-debug-getDebug-chat', temp)
            elseif args.dest == 1 then TriggerEvent('js-debug-getDebug-console', temp)
            elseif args.dest == 2 then TriggerServerEvent('js-debug-getDebug-server', temp)
            elseif args.dest == 3 then
                TriggerEvent('js-debug-getDebug-console', temp)
                TriggerServerEvent('js-debug-getDebug-server', temp)
            end
        end 
    else TriggerEvent('js-debug-getDebug-console',{level = 0, msg = "Args found as nil", value = nil}) end
end
-- exports('TriggerDebug', JSDebug.TriggerDebug)