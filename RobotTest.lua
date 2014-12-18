--local component = require("component")
--local sd = require("sides")
rb = require("robot")

function digBox( maxY , maxX , maxZ )
    rb.swing()
    rb.forward() --moves in to the area that you want hollowed out
    rb.turnRight() -- aligns robot from my starting position of front left of area to be dug
    for y=0,maxY do
        for z =0,maxZ do
            for i=0,maxX-1 do
                if rb.durability()==nil then
                    return "No Pickaxe"
                end
                rb.swing()
                local move = {rb.forward()}
                if move[1]==nil then
                    if move[2]=='entity' then
                        repeat
                            os.sleep(100)
                        until rb.detect()==false
                    else
                        return move[2]
                    end
                end
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
            if y%2==1 then
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
    return "Done"
end


print(digBox(3,3,3))