local component = require("component")
local event = require("event")
local cl = require("colors")
--local modem = component.modem
local rs = component.redstone

local net = require("internet")
--local con = net.open("irc.esper.net",6667)

local SIDE = 0

--event.listen("modem_message",function(evt,_,_,_,_,...) print(...) end)
--modem.open(2412)

function displayMenu()
    print("Choose below:")
    print("1: Display current position")
    print("2: Send move command")
    print("3:Toggle doors")
    print("4:Open Standalone Complex")
    return io.read()
end

function door()
    SIDE = 4
    close()
    SIDE = 5 
    close()
    SIDE = 4
    open()
    SIDE = 5
    open()
end

function on(color)
    rs.setBundledOutput(SIDE,color,255)
end
function off(color)
    rs.setBundledOutput(SIDE,color,0)
end

function close()
on(cl.green)
off(cl.green)
on(cl.white)
on(cl.green)
off(cl.green)
doorClosed = 1
end

function open()
on(cl.blue)
off(cl.blue)
off(cl.white)
on(cl.green)
on(cl.red)
off(cl.red)
off(cl.green)
on(cl.blue)
off(cl.blue)
doorClosed = 0
end

while true do
    local num = displayMenu()
    if num=="3" then
        print("Doors moving")
        door()
    elseif num=="4"
        net.open("127.0.0.1",4440)
    elseif num=="q"
        return
    end
    --modem.broadcast(2412,num)
end