local protol = require("src.multiplayer.protocol")
local enet = require "enet"

-- set the server
local host = enet.host_create("0.0.0.0:9111") -- set the target of data to 0.0.0.0 (like all adresse) and port 9111
server = {}
server.player = {}




-- starting print
print("server starting at 0.0.0.0:9111")
print("seed = 123")



while true do -- holy infinte loop
  local event = host:service(100) -- time in ms to wait ?
  while event do
    local seed = 123 -- seed to sent for test
    
     if event then -- if new thing on serv

        if event.type == "connect" then
            event.peer:send(protcol.code({seed = 123})) -- send to the new player the seed
            server.player[event.peer] = {} -- make a table 4 the new player
        end
        
        if event.type == "receive" then -- if new info in serv like pos and all
            local data = protcol.decode(event.data)
            if server.player[event.peer] then
                server.player[event.peer] = {x = data.x, y = data.y}
            else
                print("Who is" .. event.peer "🥀")
            end
        end
    end 
    
    host:service()
  end
end