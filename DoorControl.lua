local component = require("component")
local sd = require("sides")
local rs = component.redstone
local cl = require("colors")

local SIDE = sd.top
local doorClosed = rs.getBundledOutput(SIDE,cl.white)


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
	if rs.getBundledInput(SIDE,cl.cyan)>0 and doorClosed==1 then
		open()
	else if rs.getBundledInput(SIDE,cl.cyan)==0 and doorClosed==0 then
		close()
	end
end
