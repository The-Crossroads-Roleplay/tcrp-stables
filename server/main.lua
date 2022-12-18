local QRCore = exports['qr-core']:GetCoreObject()
--[[ RegisterServerEvent('tcrp-stables:renameHorse', function(input)
    local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    for k,v in pairs(input) do
        print(k .. " : " .. v)
        print('break')
        print(v)
        MySQL.update('UPDATE player_horses SET name = ? , {v,})
    end
end) ]]

RegisterServerEvent('tcrp-stables:server:BuyHorse', function(price, model, newnames,comps)
    local src = source
    local Player = QRCore.Functions.GetPlayer(src)
    if (Player.PlayerData.money.cash < price) then
        print("buy a horse")
        return
    end
    MySQL.insert('INSERT INTO player_horses(citizenid, name, horse, components, active) VALUES(@citizenid, @name, @horse, @components, @active)', {
        ['@citizenid'] = Player.PlayerData.citizenid,
        ['@name'] = newnames,
        ['@horse'] = model,
        ['@components'] = json.encode({}),
        ['@active'] = false,
    })
    Player.Functions.RemoveMoney('cash', price)
    print("You have successfully bought a horse")
end)

RegisterServerEvent('tcrp-stables:server:SetHoresActive', function(id)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    local activehorse = MySQL.scalar.await('SELECT id FROM player_horses WHERE citizenid = ? AND active = ?', {Player.PlayerData.citizenid, true})
    MySQL.update('UPDATE player_horses SET active = ? WHERE id = ? AND citizenid = ?', { false, activehorse, Player.PlayerData.citizenid })
    MySQL.update('UPDATE player_horses SET active = ? WHERE id = ? AND citizenid = ?', { true, id, Player.PlayerData.citizenid })
end)

RegisterServerEvent('tcrp-stables:server:SetHoresUnActive', function(id)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    local activehorse = MySQL.scalar.await('SELECT id FROM player_horses WHERE citizenid = ? AND active = ?', {Player.PlayerData.citizenid, false})
    MySQL.update('UPDATE player_horses SET active = ? WHERE id = ? AND citizenid = ?', { false, activehorse, Player.PlayerData.citizenid })
    MySQL.update('UPDATE player_horses SET active = ? WHERE id = ? AND citizenid = ?', { false, id, Player.PlayerData.citizenid })
end)

--[[ RegisterServerEvent('tcrp-stables:server:DelHores', function(id)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    print(id)
    print(Player)
    MySQL.update('DELETE FROM player_horses WHERE id = ? AND citizenid = ?', { id, Player.PlayerData.citizenid })
end) ]]

RegisterServerEvent('tcrp-stables:server:DelHores', function(id)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    local modelHorse = nil
    print(id)
    print(Player)
   
    local player_horses = MySQL.query.await('SELECT * FROM player_horses WHERE id = @id AND `citizenid` = @citizenid', {
        ['@id'] = id,
        ['@citizenid'] = Player.PlayerData.citizenid
    })
    

        print(player_horses)
        
        for i = 1, #player_horses do
            if tonumber(player_horses[i].id) == tonumber(id) then
                modelHorse = player_horses[i].horse
                MySQL.update('DELETE FROM player_horses WHERE id = ? AND citizenid = ?', { id, Player.PlayerData.citizenid })
                print('delete')
            end
    end
    
    for k,v in pairs(Config.BoxZones) do
        for j,n in pairs(v) do
            if n.model == modelHorse then
                print(n.model)
                print(modelHorse)
                Player.Functions.AddMoney('cash', n.price * 0.5)
            end
        end
    end
end)


 


QRCore.Functions.CreateCallback('tcrp-stables:server:GetHorse', function(source, cb,comps)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local GetHorse = {}
	local horses = MySQL.query.await('SELECT * FROM player_horses WHERE citizenid=@citizenid', {
        ['@citizenid'] = Player.PlayerData.citizenid,
    })    
	if horses[1] ~= nil then
        cb(horses)
	end
end)

QRCore.Functions.CreateCallback('tcrp-stables:server:GetActiveHorse', function(source, cb)
    local src = source
    local Player = QRCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT * FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = cid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)
------------------------------------- Horse Customization  -------------------------------------

QRCore.Functions.CreateCallback('tcrp-stables:server:CheckSaddle', function(source, cb)
	local src = source
	local encodedSaddle = json.encode(SaddleDataEncoded)
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT saddle FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-stables:server:CheckBlanket', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT blanket FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-stables:server:CheckHorn', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT horn FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-stables:server:CheckBag', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT bag FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-stables:server:CheckLuggage', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT luggage FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-stables:server:CheckStirrup', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT stirrup FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-stables:server:CheckMane', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT mane FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-stables:server:CheckTail', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT tail FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-stables:server:CheckMask', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT mask FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

RegisterNetEvent("tcrp-stables:server:SaveSaddle", function(SaddleDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if SaddleDataEncoded ~= nil then
        MySQL.update('UPDATE player_horses SET saddle = ?  WHERE citizenid = ? AND active = ?', {SaddleDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)


RegisterNetEvent("tcrp-stables:server:SaveBlanket", function(BlanketDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if BlanketDataEncoded ~= nil then
        MySQL.update('UPDATE player_horses SET blanket = ?  WHERE citizenid = ? AND active = ? ' , {BlanketDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)

RegisterNetEvent("tcrp-stables:server:SaveHorn", function(HornDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if HornDataEncoded ~= nil then
        MySQL.update('UPDATE player_horses SET horn = ?  WHERE citizenid = ? AND active = ?', {HornDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)

RegisterNetEvent("tcrp-stables:server:SaveBag", function(BagDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if BagDataEncoded ~= nil then
        MySQL.update('UPDATE player_horses SET bag = ?  WHERE citizenid = ? AND active = ?', {BagDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)

RegisterNetEvent("tcrp-stables:server:SaveLuggage", function(LuggageDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if LuggageDataEncoded ~= nil then
        MySQL.update('UPDATE player_horses SET luggage = ?  WHERE citizenid = ? AND active = ?', {LuggageDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)


RegisterNetEvent("tcrp-stables:server:SaveStirrup", function(StirrupDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if StirrupDataEncoded ~= nil then
        MySQL.update('UPDATE player_horses SET stirrup = ?  WHERE citizenid = ? AND active = ? ' , {StirrupDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)

RegisterNetEvent("tcrp-stables:server:SaveMane", function(ManeDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if ManeDataEncoded ~= nil then
        MySQL.update('UPDATE player_horses SET mane = ?  WHERE citizenid = ? AND active = ?', {ManeDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)

RegisterNetEvent("tcrp-stables:server:SaveTail", function(TailDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if TailDataEncoded ~= nil then
        MySQL.update('UPDATE player_horses SET tail = ?  WHERE citizenid = ? AND active = ?', {TailDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)

RegisterNetEvent("tcrp-stables:server:SaveMask", function(MaskDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if MaskDataEncoded ~= nil then
        MySQL.update('UPDATE player_horses SET mask = ?  WHERE citizenid = ? AND active = ?', {MaskDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)


RegisterNetEvent("tcrp-stables:server:TradeHorse", function(playerId, horseId, source, cb)
    print("server")
    local src = source
    local Player2 = QRCore.Functions.GetPlayer(playerId)
    local Playercid2 = Player2.PlayerData.citizenid
    local result = MySQL.update('UPDATE player_horses SET citizenid = ?  WHERE citizenid = ? AND active = ?', {Playercid2, horseId, 1})
    MySQL.update('UPDATE player_horses SET active = ?  WHERE citizenid = ? AND active = ?', {0, Playercid2, 1})
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)
