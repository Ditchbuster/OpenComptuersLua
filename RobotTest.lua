--local component = require("component")
--local sd = require("sides")
local rb = require("robot")
local absX,absY,absZ = 0,0,0 -- these are the coords of the bot reletive to the starting point, X is in the +north -south direction, Y in the +east -west direction and Z in the +up -down direction
local facing = 0 -- facing relative to starting direction. north is forward (0), east is right (1), south is back (2), west is left(3) from the staring position

function digBox( maxY , maxX , maxZ )
    rb.swing()
    forward() --moves in to the area that you want hollowed out
    turnRight() -- aligns robot from my starting position of front left of area to be dug
    for y=0,maxY do
        for z =0,maxZ do
            for i=0,maxX-1 do
                if rb.durability()==nil then
                    return "No Pickaxe"
                end
                rb.swing()
                local move = {forward()}
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
                        if y%2==1 then
                            rb.swingUp()
                            up()
                        else
                            rb.swingDown()
                            down()
                        end

                        turnRight()
                        turnRight()
                    end
                end
                if y ~= maxY then
                    if y%2==1 then
                        turnLeft()
                        rb.swing()
                        forward()
                        turnLeft()
                    else
                        turnRight()
                        rb.swing()
                        forward()
                        turnRight()
                    end
                end
            end
            return "Done"
        end
function forward() --adjusts the abs vars appropreatly and returns robot.forward() return
    if facing==0 then
        absX=absX+1
    elseif facing ==1 then
        absY=absY+1
    elseif facing ==2 then
        absX=absX-1
    elseif facing ==3 then
        absY=absY-1
    end
    return rb.forward()
end
function up() -- adjusts the absX for up and down
    absZ=absZ+1
    return rb.up()
end
function down()
    absZ=absZ-1
    return rb.down()
end
function turnRight() --adj facing var and turns
    if facing==3 then
        facing=0
    else
        facing=facing+1
    end
    return rb.turnRight()
end
function turnLeft()
    if facing ==0 then
        facing=3
    else
        facing=facing-1
    end
    return rb.turnLeft()
end
function turn(desFacing) -- no one seems to know if robot.turnLeft/Right() returns anything or not... 
    if type(desFacing)~="number" then error ("Turn desired should be a number") end
    if desFacing>3 or desFacing<0 then error("Turn desired between 0 and 3") end

    local tn = desFacing-facing
    if tn== 1 or tn==-3 then
        return turnRight()
    elseif tn==-2 or tn == 2 then
        turnRight()
        turnRight()
        return --until i find doc or code showing if robot.turnRight() returns anything i am just not returning anything..

    elseif tn == -1 or tn == 3 then
        return turnLeft()
    else
        return nil,"No turn desired"
    end
end
print(facing)
turn(2)
print(facing)
--print(digBox(3,3,3))
print(absX.." "..absY.." "..absZ)