# js-debug
 QB Based Debugging Resource with functions for printing to chat, console and server.
 By Jacob Steel for FiveM b2944

# Variables
 Before you even try to run anything through an export, please, please read this 🙏
 The important thing to know is the what the hell `args` is like at all. Well:
 ```lua
 args = { dest:number, level:number, msg:string, value?:any }
 ```
 ```lua 
 ---@param dest number
 ---|"0" # -- Chat
 ---|"1" # -- Console
 ---|"2" # -- Server
 ---|"3" # -- Server+Console
 ```
 ```lua
 ---@param level number
 ---|"0" # ---FKNA ----- Internal Error ---- Internal Error that should not occur. Fuckin' a
 ---|"1" # ---INFO ------- Information ----- Debug info or just a way to print to console
 ---|"2" # --NOTIFY ------ Notification ---- Notification of task completing or similar
 ---|"3" # ---WARN --------- Warning ------- Warning message. E.g. No Access etc.
 ---|"4" # ---ISSUE ---- Low Level Issue --- Low level issue i.e. a non-core function failure
 ---|"5" # --ERROR ---------- Error -------- Script Errored. Logged to file by server
 ---|"6" # -CRITICAL --- Critical Error ---- Error that may have broken some functionality
 ---|"66" # --FATAL ------ Fatal Error ----- Encountered error that won't recover
 ```

# Exports
 Using this resource in your resources/resources you are working on is simple enough:
 ```lua
 exports['js-debug']:TriggerDebug{dest = 3, level = 1, msg = "Successful Test", value = 69}
 ```
 Here we can see that we set the destination to 3 which we know is the server AND client console.
 We have set the level to 1 or `'NOTIFY'` and the message to `'Successful Test'`.
 I've even been a little cheeky and set the value to a very nice number. The nicest some might say.

# The Function
 ```lua
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
 ```

# The Events
 ```lua
 RegisterNetEvent('js-debug-getDebug-chat', function(args)
     local msg
     if not args.value then msg = SetMsg{level = args.level, msg = args.msg} 
     else SetMsg{level = args.level, msg = args.msg, args.value} end
     TriggerEvent('chat:addMessage', {
         multiline = false,
         args = {"DEBUG", msg}
       })
 end)
 ```
 ```lua
 RegisterNetEvent('js-debug-getDebug-console', function(args)
    local msg
    if not args.value then msg = SetMsg{level = args.level, msg = args.msg}
    else msg = SetMsg{level = args.level, msg = args.msg, value = args.value} end
    if type(msg) == 'nil' then TriggerEvent('js-debug-getDebug-console',{level = 0, msg = "Output found as nil"})
    else print(msg) end
 end)
 ```
 ```lua
 RegisterNetEvent('js-debug-getDebug-server', function(args)
    local time = GetServerTime()
    local msg
    if not args.value then msg = SetMsg{time = time, level = args.level, msg = args.msg}
    else msg = SetMsg{time = time, level = args.level, msg = args.msg, value = args.value} end
    if type(msg) == 'nil' then TriggerEvent('js-debug-getDebug-server',{level = 0, msg = "Output found as nil"})
    else print(msg) end
 end)
 ```
 And SetMsg() cause im nice. You may notice that the server passes through the optional time value while the client does not.
 This is simply a quirk I found with the FiveM system where `os.date('*t')` works server-side but not client-side and honestly I don't care why anymore. 
 Server Uses `GetServerTime()`, a function in the server.lua
 Client Uses `GetTime()`, a function in functions.lua
 ```lua
 ---@param args{level:number,msg:string,value?:any,time?:string|osdate}
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
 ```