local component = require("component")
local sd = require("sides")
local rb = require("robot")

local maxZ = 2, maxY = 2

rb.swing()
rb.forward() --moves in to the area that you want hollowed out
rb.turnRight() -- aligns robot from my starting position of front left of area to be dug
for y=0,maxY do
    for z =0,maxZ do
        for i=0,1 do
            rb.swing()
            rb.forward()
            print("@".. i .."," .. y .. "," .. z)
        end
        if z ~=maxZ then
            if y%2==0 then
                rb.swingUp()
                rb.up()
            else
                rb.swingDown()
                rb.down()
            end

            rb.turnAround()
        end
    end
    if y ~= maxY then
        if y%2==0 then
            rb.turnLeft()
            rb.swing()
            rb.forward()
            rb.turnLeft()
        else
            rb.turnRight()
            rb.swing()
            rb.forward()
            rb.turnRight()
        end
    end
end
