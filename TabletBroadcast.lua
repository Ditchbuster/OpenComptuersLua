local component = require("component")
local event = require("event")
local modem = component.modem

local args = {...}

modem.broadcast(123,args[1])
