--local component = require("component")
--local sd = require("sides")
local rb = require("robot")
local absX,absY,absZ = 0,0,0 -- these are the coords of the bot reletive to the starting point, X is in the +north -south direction, Y in the +east -west direction and Z in the +up -down direction
local facing = 0 -- facing relative to starting direction. north is forward (0), east is right (1), south is back (2), west is left(3) from the staring position

function digBox( maxX , maxY , maxZ )
    maxX=maxX-1 --sets the vars to expected sizes from the function.
    maxY=maxY-1
    maxZ=maxZ-1

    if maxX<0 then error("MaxX needs to be 1 or greater") end
    if maxY<0 then error("MaxY needs to be 1 or greater") end
    if maxZ<0 then error("MaxZ needs to be 1 or greater") end
    rb.swing()
    forward() --moves in to the area that you want hollowed out
    turnRight() -- aligns robot from my starting position of front left of area to be dug
    for x=0,maxX do
        for z =0,maxZ do
            for y=0,maxY-1 do
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
                print("@".. absX .."," .. absY .. "," .. absZ)
            end
            if z ~=maxZ then
                if x%2==0 then
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
        if x ~= maxX then --if not the last row then move up a row (+X direction)
            local tmpFacing=facing --store direction just came from along Y
            turn(0) --turn north
            rb.swing() --swing pickaxe ******** TODO: needs durability check
            forward()
            if tmpFacing==1 then  -- then turn to opposite direction then it had been before moving north
                turn(3)
            else
                turn(1)
            end         
        end
    end
    return "Done"
end
function forward() --adjusts the abs vars appropreatly and returns robot.forward() return
    local moved = {rb.forward()}
    if moved[1]==true then
        if facing==0 then
            absX=absX+1
        elseif facing ==1 then
            absY=absY+1
        elseif facing ==2 then
            absX=absX-1
        elseif facing ==3 then
            absY=absY-1
        end
    end
    return moved
end
function up() -- adjusts the absX for up and down
    local moved = {rb.up()}
    if moved[1] == true then
        absZ=absZ+1
    end
    return moved

end
function down()
    local moved = {rb.down()}
    if moved[1] == true then
        absZ=absZ-1
    end
    return moved
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
function returnToOrigin() -- return from current location to starting spot 
    goTo(0,0,0)
    turn(0) --turn back to starting rotation
end
function goTo(inX,inY,inZ) --*******TODO: checking if a move happened, while loops would be better, check for neg abs vals

    if inZ-absZ>0 then
        for i=absZ,inZ do
            up()
        end
    else
        for i=inZ,absZ do
            down()
        end
    end
    if inY-absY>0 then
    turn(1) --turn east to increase absY
    for i=absY,inY do
        forward()
    end
else
    turn(3) -- turn west to decrease absY
    for i=inY,absY do
        forward()
    end
end
if inX-absX>0 then
    turn(0) -- turn north to increase absX
    for i=absX,inX do
        forward()
    end
    else
    turn(2)
    for i=inX,absX do
        forward()
    end
    end
end
--print(facing)
--turn(2)
--print(facing)
print(digBox(3,3,3))
print(absX.." "..absY.." "..absZ)
returnToOrigin()
print(absX.." "..absY.." "..absZ)