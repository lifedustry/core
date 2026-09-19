local client = {}
local enet = require("enet")
local map = require("src.map")
local player = require("src.player")
local protol = require("src.multiplayer.protocol")
local function protocol.decode(str)
    local tbl = {}
    for k, v in str:gmatch("([^;=]+)=([^;=]+)") do
        tbl[k] = tonumber(v) or v
    end
    return tbl
end

local function protocol.code(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        table.insert(result, k .. "=" .. tostring(v))
    end
    return table.concat(result, ";")
end



function client.connect()
    client.host = enet.host_create()
    client.server = client.host:connect(client.host_ip .. ":9111")
end

function client.update()
    client.event = client.host:service(0)
    client.server:send(protocol.code({ x = player.x, y = player.y }))
    if client.event then
        if client.event.type == "receive" then
            local data = protocol.decode(client.event.data)
            print(data.seed)
            map.seed = tonumber(data.seed)
        end
    end
end

return client