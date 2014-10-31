local component = require("component")
local br = component.br_reactor

if br.getConnected()=true then
	repeat
		print(br.getEnergyStored)
	end 
end