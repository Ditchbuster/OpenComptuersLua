local component = require("component")
local sd = require("sides")
local rs = component.redstone
local cl = require("colors")
local event = require("event")
local modem = component.modem

local SIDE = sd.east
local doorClosed = rs.getBundledOutput(SIDE,cl.white)
local myEventHandlers = setmetatable({},{__index = function() return unknownEvent end})
local cyanState = 0

function unknownEvent() --dummy function for unknown events

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

function handleEvents(eventID, ... )
    if (eventID) then   -- can be nil if no event was triggered in some time
        myEventHandlers[eventID](...)
    end
end

function myEventHandlers.modem_message(recAddr,sendAddr,port,dis,...)
    local payload = ...
    if payload == "open" then
        open()
    elseif payload == "closed" then
        close()
    else
        print("Bad Mesg")
    end
end


function myEventHandlers.redstone_changed(address, side)
    if side==SIDE and cyanState~=rs.getBundledInput(SIDE,cl.cyan) then
        cyanState=rs.getBundledInput(SIDE,cl.cyan)
        if doorClosed == 0 then
            close()

        elseif doorClosed == 1 then
            open()
        end
    end
end
-- *********************** Main Program ************************
cyanState = rs.getBundledInput(SIDE,cl.cyan)
modem.open(123)
print(modem.isOpen(123))
while true do
    print("Waiting")
    handleEvents(event.pull())
    print("Pulled Event")
end
