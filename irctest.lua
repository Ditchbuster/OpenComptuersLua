--this is just a basic split function we'll use to split the messages
function split(data, pat)
    local ret = {}
    for i in string.gmatch(data,pat) do
        table.insert(ret,i)
    end
    return ret
end
--config
local nickname = "myircbot"
local channel = "#ditchbuster"
 
local net = require("internet")
local con = net.open("irc.esper.net",6667) --define server / port here, this will connect to the server
if(con) then
    local line,png,linesplt,msgfrom = " "
    con:write(" ")
    while(true) do
        line = con:read() --read a line from the socket
        print(line)
        linesplt = split(line,"[^:]+")
        if #linesplt >= 2 and string.find(linesplt[2], "No Ident response") ~= nil then
            print("JOIN")
            con:write("USER " .. nickname .. " 0 * :" .. nickname .. "\r\n") --con:write(msg) is used to send messages, con:read() will read a line
            con:write("NICK " .. nickname .. "\r\n") --for IRC, remember to append the \r\n on the end of all messages
            con:write("/JOIN " .. channel .. "\r\n")
        elseif linesplt[1] == "PING" or linesplt[1] == "PING " then
            print("PING")
            png = split(line,"[^:]+")
            con:write("PONG :"..png[#png].."\r\n") --respond to pings so we don't get disconnected
        elseif string.find(linesplt[1], "PRIVMSG #") ~= nil then
            msgfrom = split(linesplt[1],"[^ ]+")
            msgfrom = msgfrom[3]
            con:write("PRIVMSG "..msgfrom.." :"..linesplt[2].."\r\n")
        elseif #linesplt >= 2 and string.find(linesplt[2], "+i") ~= nil then
            con:write("/JOIN " .. channel .."\r\n")
        end
    end
else
    print("Connection failed.")
end