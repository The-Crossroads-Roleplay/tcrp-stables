--
local entities = {}
local rhodesentities = {}
local bwentities = {}
local sdentities = {}
local strawberryentities = {}
local tbentities = {}
local vhentities = {}
local centities = {}
local npcs = {}
local bwnpcs = {}
local sdnpcs = {}
local sbnpcs = {}
local twnpcs = {}
local vhnpcs = {}
local rhnpcs = {}
local cnpcs = {}
--
local timeout = false
local timeoutTimer = 30
local horsePed = 0
local horseSpawned = false
local HorseCalled = false
local QRCore = exports['qr-core']:GetCoreObject()
local newnames = ''
local horseDBID
--
local SaddleUsing 
local BlanketUsing 
local HornUsing 
local BagUsing 
local StirrupUsing
local ManeUsing
local TailUsing
local LuggageUsing
local MaskUsing

local SaddleData = {}
local BlanketData = {}
local HornData = {}
local StirrupData = {}
local ManeData = {}
local TailData = {}
local MaskData = {}
local BagData = {}
local LuggageData = {}

local saddle 
local blanket
local horn
local stirrup
local mane
local tail
local mask
local bag
local luggage
--
local ped 
local coords
local hasSpawned = false
--
local inValentine = false
local inRhodes = false
local inBlackwater = false 
local inSD = false 
local inStrawberry = false
local inVanhorn = false
local inTumble = false
local inColter = false
--
RegisterNetEvent('tcrp-stables:client:custShop', function()
    local function createCamera(horsePed)
        local coords = GetEntityCoords(horsePed)
        TriggerEvent('tcrp-stables:custMenu')
        groundCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
        SetCamCoord(groundCam, coords.x + 0.5, coords.y - 3.6, coords.z )
        SetCamRot(groundCam, 10.0, 0.0, 0 + 20)
        SetCamActive(groundCam, true)
        RenderScriptCams(true, false, 1, true, true)
        --Wait(3000)
        -- last camera, create interpolate
        fixedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
        SetCamCoord(fixedCam, coords.x + 0.5,coords.y - 3.6,coords.z+1.8)
        SetCamRot(fixedCam, -20.0, 0, 0 + -10.0)
        SetCamActive(fixedCam, true)
        SetCamActiveWithInterp(fixedCam, groundCam, 3900, true, true)
        Wait(3900)
        DestroyCam(groundCam)
    end
    if horsePed ~= 0 then 
        createCamera(horsePed)
    else 
        QRCore.Functions.Notify('No Horse Detected', 'error', 7500)
    end
end)
RegisterCommand('sethorsename',function(input)
    local input = exports['qr-input']:ShowInput({
    header = "Name your horse",
    submitText = "Confirm",
    inputs = {
        {
            type = 'text',
            isRequired = true,
            name = 'realinput',
            text = 'text'
        }
    }
})
TriggerServerEvent('tcrp-stables:renameHorse', input)
end)

Citizen.CreateThread(function() -- Handle Colter
    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        local hcoords = Config.ColterCoords
        Wait(10000)
         if #(pcoords - hcoords) <= 300.7 then  
            Wait(1000)
            if inColter == false then
                inColter = true
                for k,v in pairs(Config.BoxZones) do
                    if k == "Colter" then
                        for j, n in pairs(v) do
                            Wait(1)
                            local model = GetHashKey(n.model)
                            while (not HasModelLoaded(model)) do
                                RequestModel(model)
                                Wait(1)
                            end
                            local entity = CreatePed(model, n.coords.x, n.coords.y, n.coords.z-1, n.heading, false, true, 0, 0)
                            while not DoesEntityExist(entity) do
                                Wait(1)
                            end
                            local hasSpawned = true
                            table.insert(centities, entity)
                            Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
                            FreezeEntityPosition(entity, true)
                            SetEntityCanBeDamaged(entity, false)
                            SetEntityInvincible(entity, true)
                            SetBlockingOfNonTemporaryEvents(npc, true)
                            exports['qr-target']:AddTargetEntity(entity, {
                                options = {
                                    {
                                        icon = "fas fa-horse-head",
                                        label =  n.names.." || " .. n.price ..  "$",
                                        targeticon = "fas fa-eye",
                                        action = function(newnames)
                                                AddTextEntry('FMMC_MPM_NA', "Set horse name")
                                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                                                while (UpdateOnscreenKeyboard() == 0) do
                                                    DisableAllControlActions(0);
                                                    Wait(0);
                                                end
                                                if (GetOnscreenKeyboardResult()) then
                                                    newnames = GetOnscreenKeyboardResult()
                                                    TriggerServerEvent('tcrp-stables:server:BuyHorse', n.price, n.model, newnames)
                                                else
                                            end
                                            
                                        end
                                    }
                                },
                                distance = 2.5,
                            })
                            Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)
                            SetModelAsNoLongerNeeded(model)
                        end
                    else 
                    end
                end
            
                for key,value in pairs(Config.ModelSpawns) do
                    while not HasModelLoaded(value.model) do
                        RequestModel(value.model)
                        Wait(1)
                    end
                    local ped = CreatePed(value.model, value.coords.x, value.coords.y, value.coords.z - 1.0, value.heading, false, false, 0, 0)
                    while not DoesEntityExist(ped) do
                        Wait(1)
                    end
            
                    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                    Citizen.InvokeNative(0x06FAACD625D80CAA, ped)
                    SetEntityCanBeDamaged(ped, false)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    Wait(1)
                    TriggerEvent('tcrp-stables:DoShit',function(cb)
                    end)
                    exports['qr-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                icon = "fas fa-horse-head",
                                label = "Get your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:menu")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Store Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:storehorse")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Sell your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:MenuDel")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Tack Shop",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:custShop')
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Trade Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:tradehorse')
                                end
                            }
                        },
                        distance = 2.5,
                    })
                    SetModelAsNoLongerNeeded(value.model)
                    table.insert(cnpcs, ped)
                end
            else
            end
        else 
            inColter = false
            Wait(1000)
            for k,v in pairs(centities) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
            for k,v in pairs(cnpcs) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
        end 
    end
end)

Citizen.CreateThread(function() -- Handle VanHorn
    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        local hcoords = Config.VanhornCoords
        Wait(10000)
         if #(pcoords - hcoords) <= 300.7 then  
            Wait(1000)
            if inVanhorn == false then
                inVanhorn = true
                for k,v in pairs(Config.BoxZones) do
                    if k == "Vanhorn" then
                        for j, n in pairs(v) do
                            Wait(1)
                            local model = GetHashKey(n.model)
                            while (not HasModelLoaded(model)) do
                                RequestModel(model)
                                Wait(1)
                            end
                            local entity = CreatePed(model, n.coords.x, n.coords.y, n.coords.z-1, n.heading, false, true, 0, 0)
                            while not DoesEntityExist(entity) do
                                Wait(1)
                            end
                            local hasSpawned = true
                            table.insert(vhentities, entity)
                            Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
                            FreezeEntityPosition(entity, true)
                            SetEntityCanBeDamaged(entity, false)
                            SetEntityInvincible(entity, true)
                            SetBlockingOfNonTemporaryEvents(npc, true)
                            exports['qr-target']:AddTargetEntity(entity, {
                                options = {
                                    {
                                        icon = "fas fa-horse-head",
                                        label =  n.names.." || " .. n.price ..  "$",
                                        targeticon = "fas fa-eye",
                                        action = function(newnames)
                                                AddTextEntry('FMMC_MPM_NA', "Set horse name")
                                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                                                while (UpdateOnscreenKeyboard() == 0) do
                                                    DisableAllControlActions(0);
                                                    Wait(0);
                                                end
                                                if (GetOnscreenKeyboardResult()) then
                                                    newnames = GetOnscreenKeyboardResult()
                                                    TriggerServerEvent('tcrp-stables:server:BuyHorse', n.price, n.model, newnames)
                                                else
                                            end
                                            
                                        end
                                    }
                                },
                                distance = 2.5,
                            })
                            Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)
                            SetModelAsNoLongerNeeded(model)
                        end
                    else 
                    end
                end
            
                for key,value in pairs(Config.ModelSpawns) do
                    while not HasModelLoaded(value.model) do
                        RequestModel(value.model)
                        Wait(1)
                    end
                    local ped = CreatePed(value.model, value.coords.x, value.coords.y, value.coords.z - 1.0, value.heading, false, false, 0, 0)
                    while not DoesEntityExist(ped) do
                        Wait(1)
                    end
            
                    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                    Citizen.InvokeNative(0x06FAACD625D80CAA, ped)
                    SetEntityCanBeDamaged(ped, false)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    Wait(1)
                    TriggerEvent('tcrp-stables:DoShit',function(cb)
                    end)
                    exports['qr-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                icon = "fas fa-horse-head",
                                label = "Get your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:menu")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Store Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:storehorse")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Sell your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:MenuDel")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Tack Shop",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:custShop')
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Trade Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:tradehorse')
                                end
                            }
                        },
                        distance = 2.5,
                    })
                    SetModelAsNoLongerNeeded(value.model)
                    table.insert(vhnpcs, ped)
                end
            else
            end
        else 
            inVanhorn = false
            Wait(1000)
            for k,v in pairs(vhentities) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
            for k,v in pairs(vhnpcs) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
        end 
    end
end)

Citizen.CreateThread(function() -- Handle Valentine
    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        local hcoords = Config.ValCoords
        Wait(10000)
         if #(pcoords - hcoords) <= 300.7 then  
            Wait(1000)
            if inValentine == false then
                inValentine = true
                for k,v in pairs(Config.BoxZones) do
                    if k == "Valentine" then
                        for j, n in pairs(v) do
                            Wait(1)
                            local model = GetHashKey(n.model)
                            while (not HasModelLoaded(model)) do
                                RequestModel(model)
                                Wait(1)
                            end
                            local entity = CreatePed(model, n.coords.x, n.coords.y, n.coords.z-1, n.heading, false, true, 0, 0)
                            while not DoesEntityExist(entity) do
                                Wait(1)
                            end
                            local hasSpawned = true
                            table.insert(entities, entity)
                            Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
                            FreezeEntityPosition(entity, true)
                            SetEntityCanBeDamaged(entity, false)
                            SetEntityInvincible(entity, true)
                            SetBlockingOfNonTemporaryEvents(npc, true)
                            exports['qr-target']:AddTargetEntity(entity, {
                                options = {
                                    {
                                        icon = "fas fa-horse-head",
                                        label =  n.names.." || " .. n.price ..  "$",
                                        targeticon = "fas fa-eye",
                                        action = function(newnames)
                                                AddTextEntry('FMMC_MPM_NA', "Set horse name")
                                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                                                while (UpdateOnscreenKeyboard() == 0) do
                                                    DisableAllControlActions(0);
                                                    Wait(0);
                                                end
                                                if (GetOnscreenKeyboardResult()) then
                                                    newnames = GetOnscreenKeyboardResult()
                                                    TriggerServerEvent('tcrp-stables:server:BuyHorse', n.price, n.model, newnames)
                                                else
                                            end
                                            
                                        end
                                    }
                                },
                                distance = 2.5,
                            })
                            Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)
                            SetModelAsNoLongerNeeded(model)
                        end
                    else 
                    end
                end
            
                for key,value in pairs(Config.ModelSpawns) do
                    while not HasModelLoaded(value.model) do
                        RequestModel(value.model)
                        Wait(1)
                    end
                    local ped = CreatePed(value.model, value.coords.x, value.coords.y, value.coords.z - 1.0, value.heading, false, false, 0, 0)
                    while not DoesEntityExist(ped) do
                        Wait(1)
                    end
            
                    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                    Citizen.InvokeNative(0x06FAACD625D80CAA, ped)
                    SetEntityCanBeDamaged(ped, false)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    Wait(1)
                    TriggerEvent('tcrp-stables:DoShit',function(cb)
                    end)
                    exports['qr-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                icon = "fas fa-horse-head",
                                label = "Get your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:menu")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Store Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:storehorse")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Sell your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:MenuDel")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Tack Shop",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:custShop')
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Trade Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:tradehorse')
                                end
                            }
                        },
                        distance = 2.5,
                    })
                    SetModelAsNoLongerNeeded(value.model)
                    table.insert(npcs, ped)
                end
            else
            end
        else 
            inValentine = false
            Wait(1000)
            for k,v in pairs(entities) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
            for k,v in pairs(npcs) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
        end 
    end
end)

Citizen.CreateThread(function() -- Handle Rhodes
    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        local hcoords = Config.RhodesCoords
        Wait(10000)
         if #(pcoords - hcoords) <= 300.7 then  
            Wait(100)
            if inRhodes == false then
                inRhodes = true
                for k,v in pairs(Config.BoxZones) do
                    if k == "Rhodes" then
                        for j, n in pairs(v) do
                            Wait(1)
                            local model = GetHashKey(n.model)
                            while (not HasModelLoaded(model)) do
                                RequestModel(model)
                                Wait(1)
                            end
                            local entity = CreatePed(model, n.coords.x, n.coords.y, n.coords.z-1, n.heading, false, true, 0, 0)
                            while not DoesEntityExist(entity) do
                                Wait(1)
                            end
                            local hasSpawned = true
                            table.insert(rhodesentities, entity)
                            Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
                            FreezeEntityPosition(entity, true)
                            SetEntityCanBeDamaged(entity, false)
                            SetEntityInvincible(entity, true)
                            SetBlockingOfNonTemporaryEvents(npc, true)
                            exports['qr-target']:AddTargetEntity(entity, {
                                options = {
                                    {
                                        icon = "fas fa-horse-head",
                                        label =  n.names.." || " .. n.price ..  "$",
                                        targeticon = "fas fa-eye",
                                        action = function(newnames)
                                                AddTextEntry('FMMC_MPM_NA', "Set horse name")
                                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                                                while (UpdateOnscreenKeyboard() == 0) do
                                                    DisableAllControlActions(0);
                                                    Wait(0);
                                                end
                                                if (GetOnscreenKeyboardResult()) then
                                                    newnames = GetOnscreenKeyboardResult()
                                                    TriggerServerEvent('tcrp-stables:server:BuyHorse', n.price, n.model, newnames)
                                                else
                                            end
                                            
                                        end
                                    }
                                },
                                distance = 2.5,
                            })
                            Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)
                            SetModelAsNoLongerNeeded(model)
                        end
                    else 
                    end
                end
            
                for key,value in pairs(Config.ModelSpawns) do
                    while not HasModelLoaded(value.model) do
                        RequestModel(value.model)
                        Wait(1)
                    end
                    local ped = CreatePed(value.model, value.coords.x, value.coords.y, value.coords.z - 1.0, value.heading, false, false, 0, 0)
                    while not DoesEntityExist(ped) do
                        Wait(1)
                    end
            
                    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                    Citizen.InvokeNative(0x06FAACD625D80CAA, ped)
                    SetEntityCanBeDamaged(ped, false)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    Wait(1)
                    TriggerEvent('tcrp-stables:DoShit',function(cb)
                    end)
                    exports['qr-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                icon = "fas fa-horse-head",
                                label = "Get your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:menu")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Store Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:storehorse")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Sell your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:MenuDel")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Tack Shop",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:custShop')
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Trade Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:tradehorse')
                                end
                            }
                        },
                        distance = 2.5,
                    })
                    SetModelAsNoLongerNeeded(value.model)
                    table.insert(rhnpcs, ped)
                end
            else
            end
        else 
            inRhodes = false
            Wait(1000)
            for k,v in pairs(rhodesentities) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
            for k,v in pairs(rhnpcs) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
        end 
    end
end)

Citizen.CreateThread(function() -- Handle Blackwater
    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        local hcoords = Config.BlackwaterCoords
        Wait(10000)
         if #(pcoords - hcoords) <= 300.7 then  
            Wait(100)
            if inBlackwater == false then
                inBlackwater = true
                for k,v in pairs(Config.BoxZones) do
                    if k == "Blackwater" then
                        for j, n in pairs(v) do
                            Wait(1)
                            local model = GetHashKey(n.model)
                            while (not HasModelLoaded(model)) do
                                RequestModel(model)
                                Wait(1)
                            end
                            local entity = CreatePed(model, n.coords.x, n.coords.y, n.coords.z-1, n.heading, false, true, 0, 0)
                            while not DoesEntityExist(entity) do
                                Wait(1)
                            end
                            local hasSpawned = true
                            table.insert(bwentities, entity)
                            Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
                            FreezeEntityPosition(entity, true)
                            SetEntityCanBeDamaged(entity, false)
                            SetEntityInvincible(entity, true)
                            SetBlockingOfNonTemporaryEvents(npc, true)
                            exports['qr-target']:AddTargetEntity(entity, {
                                options = {
                                    {
                                        icon = "fas fa-horse-head",
                                        label =  n.names.." || " .. n.price ..  "$",
                                        targeticon = "fas fa-eye",
                                        action = function(newnames)
                                                AddTextEntry('FMMC_MPM_NA', "Set horse name")
                                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                                                while (UpdateOnscreenKeyboard() == 0) do
                                                    DisableAllControlActions(0);
                                                    Wait(0);
                                                end
                                                if (GetOnscreenKeyboardResult()) then
                                                    newnames = GetOnscreenKeyboardResult()
                                                    TriggerServerEvent('tcrp-stables:server:BuyHorse', n.price, n.model, newnames)
                                                else
                                            end
                                            
                                        end
                                    }
                                },
                                distance = 2.5,
                            })
                            Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)
                            SetModelAsNoLongerNeeded(model)
                        end
                    else 
                    end
                end
            
                for key,value in pairs(Config.ModelSpawns) do
                    while not HasModelLoaded(value.model) do
                        RequestModel(value.model)
                        Wait(1)
                    end
                    local ped = CreatePed(value.model, value.coords.x, value.coords.y, value.coords.z - 1.0, value.heading, false, false, 0, 0)
                    while not DoesEntityExist(ped) do
                        Wait(1)
                    end
            
                    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                    Citizen.InvokeNative(0x06FAACD625D80CAA, ped)
                    SetEntityCanBeDamaged(ped, false)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    Wait(1)
                    TriggerEvent('tcrp-stables:DoShit',function(cb)
                    end)
                    exports['qr-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                icon = "fas fa-horse-head",
                                label = "Get your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:menu")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Store Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:storehorse")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Sell your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:MenuDel")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Tack Shop",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:custShop')
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Trade Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:tradehorse')
                                end
                            }
                        },
                        distance = 2.5,
                    })
                    SetModelAsNoLongerNeeded(value.model)
                    table.insert(bwnpcs, ped)
                end
            else
            end
        else 
            inBlackwater = false
            Wait(1000)
            for k,v in pairs(bwentities) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
            for k,v in pairs(bwnpcs) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
        end 
    end
end)

Citizen.CreateThread(function() -- Handle Strawberry
    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        local hcoords = Config.StrawberryCoords 
        Wait(10000)
         if #(pcoords - hcoords) <= 300.7 then  
            Wait(100)
            if inStrawberry == false then
                inStrawberry = true
                for k,v in pairs(Config.BoxZones) do
                    if k == "Strawberry" then
                        for j, n in pairs(v) do
                            Wait(1)
                            local model = GetHashKey(n.model)
                            while (not HasModelLoaded(model)) do
                                RequestModel(model)
                                Wait(1)
                            end
                            local entity = CreatePed(model, n.coords.x, n.coords.y, n.coords.z-1, n.heading, false, true, 0, 0)
                            while not DoesEntityExist(entity) do
                                Wait(1)
                            end
                            local hasSpawned = true
                            table.insert(strawberryentities, entity)
                            Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
                            FreezeEntityPosition(entity, true)
                            SetEntityCanBeDamaged(entity, false)
                            SetEntityInvincible(entity, true)
                            SetBlockingOfNonTemporaryEvents(npc, true)
                            exports['qr-target']:AddTargetEntity(entity, {
                                options = {
                                    {
                                        icon = "fas fa-horse-head",
                                        label =  n.names.." || " .. n.price ..  "$",
                                        targeticon = "fas fa-eye",
                                        action = function(newnames)
                                                AddTextEntry('FMMC_MPM_NA', "Set horse name")
                                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                                                while (UpdateOnscreenKeyboard() == 0) do
                                                    DisableAllControlActions(0);
                                                    Wait(0);
                                                end
                                                if (GetOnscreenKeyboardResult()) then
                                                    newnames = GetOnscreenKeyboardResult()
                                                    TriggerServerEvent('tcrp-stables:server:BuyHorse', n.price, n.model, newnames)
                                                else
                                            end
                                            
                                        end
                                    }
                                },
                                distance = 2.5,
                            })
                            Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)
                            SetModelAsNoLongerNeeded(model)
                        end
                    else 
                    end
                end
            
                for key,value in pairs(Config.ModelSpawns) do
                    while not HasModelLoaded(value.model) do
                        RequestModel(value.model)
                        Wait(1)
                    end
                    local ped = CreatePed(value.model, value.coords.x, value.coords.y, value.coords.z - 1.0, value.heading, false, false, 0, 0)
                    while not DoesEntityExist(ped) do
                        Wait(1)
                    end
            
                    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                    Citizen.InvokeNative(0x06FAACD625D80CAA, ped)
                    SetEntityCanBeDamaged(ped, false)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    Wait(1)
                    TriggerEvent('tcrp-stables:DoShit',function(cb)
                    end)
                    exports['qr-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                icon = "fas fa-horse-head",
                                label = "Get your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:menu")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Store Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:storehorse")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Sell your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:MenuDel")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Tack Shop",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:custShop')
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Trade Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:tradehorse')
                                end
                            }
                        },
                        distance = 2.5,
                    })
                    SetModelAsNoLongerNeeded(value.model)
                    table.insert(sbnpcs, ped)
                end
            else
            end
        else 
            inStrawberry = false
            Wait(1000)
            for k,v in pairs(strawberryentities) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
            for k,v in pairs(sbnpcs) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
        end 
    end
end)

Citizen.CreateThread(function() -- Handle Saint Denis
    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        local hcoords = Config.SDCoords 
        Wait(10000)
         if #(pcoords - hcoords) <= 300.7 then  
            Wait(100)
            if inSD == false then
                inSD = true
                for k,v in pairs(Config.BoxZones) do
                    if k == "Saint Denis" then
                        for j, n in pairs(v) do
                            Wait(1)
                            local model = GetHashKey(n.model)
                            while (not HasModelLoaded(model)) do
                                RequestModel(model)
                                Wait(1)
                            end
                            local entity = CreatePed(model, n.coords.x, n.coords.y, n.coords.z-1, n.heading, false, true, 0, 0)
                            while not DoesEntityExist(entity) do
                                Wait(1)
                            end
                            local hasSpawned = true
                            table.insert(sdentities, entity)
                            Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
                            FreezeEntityPosition(entity, true)
                            SetEntityCanBeDamaged(entity, false)
                            SetEntityInvincible(entity, true)
                            SetBlockingOfNonTemporaryEvents(npc, true)
                            exports['qr-target']:AddTargetEntity(entity, {
                                options = {
                                    {
                                        icon = "fas fa-horse-head",
                                        label =  n.names.." || " .. n.price ..  "$",
                                        targeticon = "fas fa-eye",
                                        action = function(newnames)
                                                AddTextEntry('FMMC_MPM_NA', "Set horse name")
                                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                                                while (UpdateOnscreenKeyboard() == 0) do
                                                    DisableAllControlActions(0);
                                                    Wait(0);
                                                end
                                                if (GetOnscreenKeyboardResult()) then
                                                    newnames = GetOnscreenKeyboardResult()
                                                    TriggerServerEvent('tcrp-stables:server:BuyHorse', n.price, n.model, newnames)
                                                else
                                            end
                                            
                                        end
                                    }
                                },
                                distance = 2.5,
                            })
                            Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)
                            SetModelAsNoLongerNeeded(model)
                        end
                    else 
                    end
                end
            
                for key,value in pairs(Config.ModelSpawns) do
                    while not HasModelLoaded(value.model) do
                        RequestModel(value.model)
                        Wait(1)
                    end
                    local ped = CreatePed(value.model, value.coords.x, value.coords.y, value.coords.z - 1.0, value.heading, false, false, 0, 0)
                    while not DoesEntityExist(ped) do
                        Wait(1)
                    end
            
                    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                    Citizen.InvokeNative(0x06FAACD625D80CAA, ped)
                    SetEntityCanBeDamaged(ped, false)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    Wait(1)
                    TriggerEvent('tcrp-stables:DoShit',function(cb)
                    end)
                    exports['qr-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                icon = "fas fa-horse-head",
                                label = "Get your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:menu")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Store Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:storehorse")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Sell your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:MenuDel")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Tack Shop",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:custShop')
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Trade Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:tradehorse')
                                end
                            }
                        },
                        distance = 2.5,
                    })
                    SetModelAsNoLongerNeeded(value.model)
                    table.insert(sdnpcs, ped)
                end
            else
            end
        else 
            inSD = false
            Wait(1000)
            for k,v in pairs(sdentities) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
            for k,v in pairs(sdnpcs) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
        end 
    end
end)
Citizen.CreateThread(function() -- Handle Tumbleweed
    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        local hcoords = Config.TumbleweedCoords 
        Wait(10000)
         if #(pcoords - hcoords) <= 300.7 then  
            Wait(100)
            if inTumble == false then
                inTumble = true
                for k,v in pairs(Config.BoxZones) do
                    if k == "Tumbleweed" then
                        for j, n in pairs(v) do
                            Wait(1)
                            local model = GetHashKey(n.model)
                            while (not HasModelLoaded(model)) do
                                RequestModel(model)
                                Wait(1)
                            end
                            local entity = CreatePed(model, n.coords.x, n.coords.y, n.coords.z-1, n.heading, false, true, 0, 0)
                            while not DoesEntityExist(entity) do
                                Wait(1)
                            end
                            local hasSpawned = true
                            table.insert(tbentities, entity)
                            Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
                            FreezeEntityPosition(entity, true)
                            SetEntityCanBeDamaged(entity, false)
                            SetEntityInvincible(entity, true)
                            SetBlockingOfNonTemporaryEvents(npc, true)
                            exports['qr-target']:AddTargetEntity(entity, {
                                options = {
                                    {
                                        icon = "fas fa-horse-head",
                                        label =  n.names.." || " .. n.price ..  "$",
                                        targeticon = "fas fa-eye",
                                        action = function(newnames)
                                                AddTextEntry('FMMC_MPM_NA', "Set horse name")
                                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                                                while (UpdateOnscreenKeyboard() == 0) do
                                                    DisableAllControlActions(0);
                                                    Wait(0);
                                                end
                                                if (GetOnscreenKeyboardResult()) then
                                                    newnames = GetOnscreenKeyboardResult()
                                                    TriggerServerEvent('tcrp-stables:server:BuyHorse', n.price, n.model, newnames)
                                                else
                                            end
                                            
                                        end
                                    }
                                },
                                distance = 2.5,
                            })
                            Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)
                            SetModelAsNoLongerNeeded(model)
                        end
                    else 
                    end
                end
            
                for key,value in pairs(Config.ModelSpawns) do
                    while not HasModelLoaded(value.model) do
                        RequestModel(value.model)
                        Wait(1)
                    end
                    local ped = CreatePed(value.model, value.coords.x, value.coords.y, value.coords.z - 1.0, value.heading, false, false, 0, 0)
                    while not DoesEntityExist(ped) do
                        Wait(1)
                    end
            
                    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                    Citizen.InvokeNative(0x06FAACD625D80CAA, ped)
                    SetEntityCanBeDamaged(ped, false)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    Wait(1)
                    TriggerEvent('tcrp-stables:DoShit',function(cb)
                    end)
                    exports['qr-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                icon = "fas fa-horse-head",
                                label = "Get your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:menu")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Store Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:storehorse")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label = "Sell your horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                    TriggerEvent("tcrp-stables:client:MenuDel")
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Tack Shop",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:custShop')
                                end
                            },
                            {
                                icon = "fas fa-horse-head",
                                label =  "Trade Horse",
                                targeticon = "fas fa-eye",
                                action = function()
                                TriggerEvent('tcrp-stables:client:tradehorse')
                                end
                            }
                        },
                        distance = 2.5,
                    })
                    SetModelAsNoLongerNeeded(value.model)
                    table.insert(twnpcs, ped)
                end
            else
            end
        else 
            inTumble = false
            Wait(1000)
            for k,v in pairs(tbentities) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
            for k,v in pairs(twnpcs) do
                DeletePed(v)
                SetEntityAsNoLongerNeeded(v)
            end
        end 
    end
end)


CreateThread(function()
    while true do
        Wait(1)
        if Citizen.InvokeNative(0x91AEF906BCA88877, 0, QRCore.Shared.Keybinds['B']) then -- openinventory
            InvHorse()
            Wait(1) -- Spam protect
        end
    end
end)

function InvHorse()
    QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
        if horsePed ~= 0 then
            local pcoords = GetEntityCoords(PlayerPedId())
            local hcoords = GetEntityCoords(horsePed)
            if #(pcoords - hcoords) <= 1.7 then
                --TriggerEvent('qr-stable:client:horseinventory')
                local horsestash = data.name..data.citizenid
                TriggerServerEvent("inventory:server:OpenInventory", "stash", horsestash, { maxweight = 15000, slots = 20, })
                TriggerEvent("inventory:client:SetCurrentStash", horsestash)
            else
                print("you are NOT in distance to open inventory")
            end 
        else
            print("you do not have a horse active")
        end
    end)       
end    

local function TradeHorse()
    QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
        if horsePed ~= 0 then
            local player, distance = QRCore.Functions.GetClosestPlayer()
            if player ~= -1 and distance < 1.5 then
                local playerId = GetPlayerServerId(player)
                local horseId = data.citizenid
                TriggerServerEvent('tcrp-stables:server:TradeHorse', playerId, horseId)
                QRCore.Functions.Notify('Horse has been traded with nearest person', 'success', 7500)
            else
                QRCore.Functions.Notify('No nearby person!', 'success', 7500)
            end
        end
    end)
end

local function SpawnHorse()
    QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
        if (data) then
            local ped = PlayerPedId()
            local model = GetHashKey(data.horse)
            local location = GetEntityCoords(ped)
            local howfar = math.random(50,100)
            local hname = data.name
            --local horseId = data.player.id
            --local horsestash = hname..model..

            if (location) then
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Wait(10)
                end

                local spawnPosition

                if atCoords == nil then
                    local x, y, z = table.unpack(location)
                    local bool, nodePosition = GetClosestVehicleNode(x, y, z, 0, 3.0, 0.0)
            
                    local index = 0
                    while index <= 25 do
                        local _bool, _nodePosition = GetNthClosestVehicleNode(x, y, z, index, 0, 3.0, 2.5)
                        if _bool == true or _bool == 1 then
                            bool = _bool
                            nodePosition = _nodePosition
                            index = index + 3
                        else
                            break
                        end
                    end
            
                    spawnPosition = nodePosition
                else
                    spawnPosition = atCoords
                end
            
                if spawnPosition == nil then
                    initializing = false
                    return
                end
                --local coords = GetEntityCoords(horsePed)
                local heading = 300
                if (horsePed == 0) then
                    horsePed = CreatePed(model, spawnPosition, GetEntityHeading(horsePed), true, true, 0, 0)
                    Citizen.InvokeNative(0x58A850EAEE20FAA3, horsePed, true)
                    while not DoesEntityExist(horsePed) do
                        Wait(10)
                    end
                    getControlOfEntity(horsePed)
                    Citizen.InvokeNative(0x283978A15512B2FE, horsePed, true)
                    Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1230993421, horsePed)
                    local hasp = GetHashKey("PLAYER")
                    Citizen.InvokeNative(0xADB3F206518799E8, horsePed, hasp)
                    Citizen.InvokeNative(0xCC97B29285B1DC3B, horsePed, 1)
                    Citizen.InvokeNative(0x931B241409216C1F , PlayerPedId(), horsePed , 0)
                    SetModelAsNoLongerNeeded(model)
                    SetPedNameDebug(horsePed, hname)
                    SetPedPromptName(horsePed, hname)
                    horseSpawned = true                    
                    moveHorseToPlayer()
                    applyImportantThings()
                    Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)

                end
            end
        end
    end)
end
exports('spawnHorse', handleSpawnHorse)
-------------- Tack Menu --------------
RegisterNetEvent('tcrp-stables:custMenu',function()
    exports['qr-menu']:openMenu({
        {
            header = "Horse Customization",
            isMenuHeader = true,
        },
        {
            header = "Select Saddle",
            txt = "Select a saddle for your horse",
            icon = "fas fa-angle-double-right",
            params = {
                event = 'tcrp-stables:client:saddleMenu',
                isServer = false,
                args = {}
            }
        },
        {
            header = "Select Blanket",
            txt = "Select a blanket for your horse",
            icon = "fas fa-angle-double-right",
            params = {
                event = 'tcrp-stables:client:blanketMenu',
                isServer = false,
                args = {}
            }
        },
        {
            header = "Select Horn",
            txt = "Select a horn for your horse",
            icon = "fas fa-angle-double-right",
            params = {
                event = 'tcrp-stables:client:hornMenu',
                isServer = false,
                args = {}
            }
        },
        {
            header = "Select Saddle Bag",
            txt = "Select a saddle bag for your horse",
            icon = "fas fa-angle-double-right",
            params = {
                event = 'tcrp-stables:client:bagMenu',
                isServer = false,
                args = {}
            }
        },
        {
            header = "Select Stirrup",
            txt = "Select a Stirrup for your horse",
            icon = "fas fa-angle-double-right",
            params = {
                event = 'tcrp-stables:client:stirrupMenu',
                isServer = false,
                args = {}
            }
        },
        {
            header = "Select Luggage",
            txt = "Select luggage for your horse",
            icon = "fas fa-angle-double-right",
            params = {
                event = 'tcrp-stables:client:luggageMenu',
                isServer = false,
                args = {}
            }
        },
        {
            header = "Select Mane",
            txt = "Select a mane for your horse",
            icon = "fas fa-angle-double-right",
            params = {
                event = 'tcrp-stables:client:maneMenu',
                isServer = false,
                args = {}
            }
        },
        {
            header = "Select Tail",
            txt = "Select a tail for your horse",
            icon = "fas fa-angle-double-right",
            params = {
                event = 'tcrp-stables:client:tailMenu',
                isServer = false,
                args = {}
            }
        },
        {
            header = "Select Mask",
            txt = "Select a mask for your horse",
            icon = "fas fa-angle-double-right",
            params = {
                event = 'tcrp-stables:client:maskMenu',
                isServer = false,
                args = {}
            }
        },
        {
            header = "Close Menu",
            txt = '',
            icon = "fas fa-angle-double-left",
            params = {
                event = 'tcrp-stables:closeMenu',
            }
        },
    })
end)

RegisterNetEvent('tcrp-stables:closeMenu', function()
    Wait(1000)
    DestroyAllCams(true)
end)

RegisterNetEvent('tcrp-stables:closeMenu', function()
    exports['qr-menu']:closeMenu()
    
end)
--[[ RegisterCommand('tack', function()
    TriggerEvent('tcrp-stables:custMenu')
end) ]]
    

---------------------------- Saddles Begin ---------------------------- End Line 308
function SaddleMenu(hash)
    local saddleMenu = {
        {
            header = "Saddles",
            isMenuHeader = true
        }
    }
    local saddles = Config.Saddles  

    saddleMenu[#saddleMenu+1] = {
        header = "Go Back",
        txt = "",
        icon = "fas fa-angle-double-left",
        params = {
            event = 'tcrp-stables:custMenu'
        }

    }

        saddleMenu[#saddleMenu+1] = {
            header = "Remove Saddle",
            txt = "",
            params = {
                event = "tcrp-stables:client:applySaddle",
                arg = {
                    saddle = nil
                }
            }
        }

    for k, v in pairs(saddles) do
        saddleMenu[#saddleMenu+1] = {
            header = v.Name,
            txt = "",
            params = {
                event = "tcrp-stables:client:applySaddle",
                args = {
                    saddle = v.Hash
                }
            }
        }
    end

    exports['qr-menu']:openMenu(saddleMenu)
end

RegisterNetEvent('tcrp-stables:client:saddleMenu',function()
    SaddleMenu()
end)

RegisterNetEvent('tcrp-stables:client:applySaddle',function(saddle,data)
    if saddle == nil then
        QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
            local ped = PlayerPedId()
            local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
            local SaddleUsing = 0
            print("saddle")
            if mount ~= nil then
                Citizen.InvokeNative(0xD710A5007C2AC539, mount, 0xBAA7E618, 0) -- HAT REMOVE
                Citizen.InvokeNative(0xCC8CA3E88256E58F, mount, 0, 1, 1, 1, 0) -- Actually remove the component
                local SaddleData = {
                    SaddleUsing
                } 
                local SaddleDataEncoded = SaddleUsing
                TriggerServerEvent('tcrp-stables:server:SaveSaddle',SaddleDataEncoded)
            else 
                QRCore.Functions.Notify('No Horse Found', 'error')
            end
        end)
        SaddleMenu()
    else
        for k,v in pairs(saddle) do
            QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
                local ped = PlayerPedId()
                local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
                local SaddleUsing = "0x"..v 
                if mount ~= nil then
                    Citizen.InvokeNative(0xD3A7B003ED343FD9, mount, tonumber(SaddleUsing), true, true, true) 
                    local SaddleData = {
                        SaddleUsing
                    } 
                    local SaddleDataEncoded = SaddleUsing
                    TriggerServerEvent('tcrp-stables:server:SaveSaddle',SaddleDataEncoded)
                else 
                    QRCore.Functions.Notify('No Horse Found', 'error')
                end
            end)
        end
        SaddleMenu()
    end
end)

---------------------------- Saddles End ----------------------------

---------------------------- Blankets Begin ------------------------- End Line 360
function BlanketMenu(hash)
    local blanketMenu = {
        {
            header = "Blankets",
            isMenuHeader = true
        }
    }
    local blankets = Config.Blankets  

    blanketMenu[#blanketMenu+1] = {
        header = "Go Back",
        txt = "",
        icon = "fas fa-angle-double-left",
        params = {
            event = 'tcrp-stables:custMenu'
        }

    }

        blanketMenu[#blanketMenu+1] = {
            header = "Remove Blanket",
            txt = "",
            params = {
                event = "tcrp-stables:client:applyBlanket",
                arg = {
                    blanket = nil
                }
            }
        }

    for k, v in pairs(blankets) do
        blanketMenu[#blanketMenu+1] = {
            header = v.Name,
            txt = "",
            params = {
                event = "tcrp-stables:client:applyBlanket",
                args = {
                    blanket = v.Hash
                }
            }
        }
    end

    exports['qr-menu']:openMenu(blanketMenu)
end

RegisterNetEvent('tcrp-stables:client:blanketMenu',function()
    BlanketMenu()
end)

RegisterNetEvent('tcrp-stables:client:applyBlanket',function(blanket,data)
    if blanket == nil then
        QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
            local ped = PlayerPedId()
            local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
            local BlanketUsing = 0
            print("blanket")
            if mount ~= nil then
                Citizen.InvokeNative(0xD710A5007C2AC539, mount, 0x17CEB41A, 0) -- HAT REMOVE
                Citizen.InvokeNative(0xCC8CA3E88256E58F, mount, 0, 1, 1, 1, 0) -- Actually remove the component
                local BlanketData = {
                    BlanketUsing
                } 
                local BlanketDataEncoded = BlanketUsing
                TriggerServerEvent('tcrp-stables:server:SaveBlanket',BlanketDataEncoded)
            else 
                QRCore.Functions.Notify('No Horse Found', 'error')
            end
        end)
        BlanketMenu()
    else
        for k,v in pairs(blanket) do
            QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
                local ped = PlayerPedId()
                local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
                local BlanketUsing = "0x"..v 
                if mount ~= nil then
                    Citizen.InvokeNative(0xD3A7B003ED343FD9, mount, tonumber(BlanketUsing), true, true, true) 
                    local BlanketData = {
                        BlanketUsing
                    } 
                    local BlanketDataEncoded = BlanketUsing
                    TriggerServerEvent('tcrp-stables:server:SaveBlanket',BlanketDataEncoded)
                else 
                    QRCore.Functions.Notify('No Horse Found', 'error')
                end
            end)
        end
        BlanketMenu()
    end
end)
---------------------------- Blankets End ------------------------- 


---------------------------- Horns Begin ------------------------- End Line 408 
function BagMenu(hash)
    local bagMenu = {
        {
            header = "Bags",
            isMenuHeader = true
        }
    }
    local bags = Config.Bags  

    bagMenu[#bagMenu+1] = {
        header = "Go Back",
        txt = "",
        icon = "fas fa-angle-double-left",
        params = {
            event = 'tcrp-stables:custMenu'
        }

    }

        bagMenu[#bagMenu+1] = {
            header = "Remove Bag",
            txt = "",
            params = {
                event = "tcrp-stables:client:applyBag",
                arg = {
                    bag = nil
                }
            }
        }

    for k, v in pairs(bags) do
        bagMenu[#bagMenu+1] = {
            header = v.Name,
            txt = "",
            params = {
                event = "tcrp-stables:client:applyBag",
                args = {
                    bag = v.Hash
                }
            }
        }
    end

    exports['qr-menu']:openMenu(bagMenu)
end

RegisterNetEvent('tcrp-stables:client:bagMenu',function()
    BagMenu()
end)

RegisterNetEvent('tcrp-stables:client:applyBag',function(bag,data)
    if bag == nil then
        QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
            local ped = PlayerPedId()
            local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
            local BagUsing = 0
            print("bag")
            if mount ~= nil then
                Citizen.InvokeNative(0xD710A5007C2AC539, mount, 0x80451C25, 0) -- HAT REMOVE
                Citizen.InvokeNative(0xCC8CA3E88256E58F, mount, 0, 1, 1, 1, 0) -- Actually remove the component
                local BagData = {
                    BagUsing
                } 
                local BagDataEncoded = BagUsing
                TriggerServerEvent('tcrp-stables:server:SaveBag',BagDataEncoded)
            else 
                QRCore.Functions.Notify('No Horse Found', 'error')
            end
        end)
        BagMenu()
    else
        for k,v in pairs(bag) do
            QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
                local ped = PlayerPedId()
                local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
                local BagUsing = "0x"..v 
                if mount ~= nil then
                    Citizen.InvokeNative(0xD3A7B003ED343FD9, mount, tonumber(BagUsing), true, true, true) 
                    local BagData = {
                        BagUsing
                    } 
                    local BagDataEncoded = BagUsing
                    TriggerServerEvent('tcrp-stables:server:SaveBag',BagDataEncoded)
                else 
                    QRCore.Functions.Notify('No Horse Found', 'error')
                end
            end)
        end
        BagMenu()
    end
end)

---------------------------- Horns End ------------------------- 

---------------------------- Saddle Bags Begin------------------------- 
function HornMenu(hash)
    local hornMenu = {
        {
            header = "Horns",
            isMenuHeader = true
        }
    }
    local horns = Config.Horns  

    hornMenu[#hornMenu+1] = {
        header = "Go Back",
        txt = "",
        icon = "fas fa-angle-double-left",
        params = {
            event = 'tcrp-stables:custMenu'
        }

    }

        hornMenu[#hornMenu+1] = {
            header = "Remove Horn",
            txt = "",
            params = {
                event = "tcrp-stables:client:applyHorn",
                arg = {
                    horn = nil
                }
            }
        }

    for k, v in pairs(horns) do
        hornMenu[#hornMenu+1] = {
            header = v.Name,
            txt = "",
            params = {
                event = "tcrp-stables:client:applyHorn",
                args = {
                    horn = v.Hash
                }
            }
        }
    end

    exports['qr-menu']:openMenu(hornMenu)
end

RegisterNetEvent('tcrp-stables:client:hornMenu',function()
    HornMenu()
end)

RegisterNetEvent('tcrp-stables:client:applyHorn',function(horn,data)
    if horn == nil then
        QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
            local ped = PlayerPedId()
            local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
            local HornUsing = 0
            print("horn")
            if mount ~= nil then
                Citizen.InvokeNative(0xD710A5007C2AC539, mount, 0x5447332, 0) -- HAT REMOVE
                Citizen.InvokeNative(0xCC8CA3E88256E58F, mount, 0, 1, 1, 1, 0) -- Actually remove the component
                local HornData = {
                    HornUsing
                } 
                local HornDataEncoded = HornUsing
                TriggerServerEvent('tcrp-stables:server:SaveHorn',HornDataEncoded)
            else 
                QRCore.Functions.Notify('No Horse Found', 'error')
            end
        end)
        HornMenu()
    else
        for k,v in pairs(horn) do
            QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
                local ped = PlayerPedId()
                local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
                local HornUsing = "0x"..v 
                if mount ~= nil then
                    Citizen.InvokeNative(0xD3A7B003ED343FD9, mount, tonumber(HornUsing), true, true, true) 
                    local HornData = {
                        HornUsing
                    } 
                    local HornDataEncoded = HornUsing
                    TriggerServerEvent('tcrp-stables:server:SaveHorn',HornDataEncoded)
                else 
                    QRCore.Functions.Notify('No Horse Found', 'error')
                end
            end)
        end
        HornMenu()
    end
end)

        

---------------------------- Saddle Bags End------------------------- 


---------------------------- Stirrups Begin ------------------------- 
function StirrupMenu(hash)
    local stirrupMenu = {
        {
            header = "Stirrups",
            isMenuHeader = true
        }
    }
    local stirrups = Config.Stirrups  

    stirrupMenu[#stirrupMenu+1] = {
        header = "Go Back",
        txt = "",
        icon = "fas fa-angle-double-left",
        params = {
            event = 'tcrp-stables:custMenu'
        }

    }

        stirrupMenu[#stirrupMenu+1] = {
            header = "Remove Stirrup",
            txt = "",
            params = {
                event = "tcrp-stables:client:applyStirrup",
                arg = {
                    stirrup = nil
                }
            }
        }

    for k, v in pairs(stirrups) do
        stirrupMenu[#stirrupMenu+1] = {
            header = v.Name,
            txt = "",
            params = {
                event = "tcrp-stables:client:applyStirrup",
                args = {
                    stirrup = v.Hash
                }
            }
        }
    end

    exports['qr-menu']:openMenu(stirrupMenu)
end

RegisterNetEvent('tcrp-stables:client:stirrupMenu',function()
    StirrupMenu()
end)

RegisterNetEvent('tcrp-stables:client:applyStirrup',function(stirrup,data)
    if stirrup == nil then
        QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
            local ped = PlayerPedId()
            local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
            local StirrupUsing = 0
            print("stirrup")
            if mount ~= nil then
                Citizen.InvokeNative(0xD710A5007C2AC539, mount, 0xDA6DADCA, 0) -- HAT REMOVE
                Citizen.InvokeNative(0xCC8CA3E88256E58F, mount, 0, 1, 1, 1, 0) -- Actually remove the component
                local StirrupData = {
                    StirrupUsing
                } 
                local StirrupDataEncoded = StirrupUsing
                TriggerServerEvent('tcrp-stables:server:SaveStirrup',StirrupDataEncoded)
            else 
                QRCore.Functions.Notify('No Horse Found', 'error')
            end
        end)
        StirrupMenu()
    else
        for k,v in pairs(stirrup) do
            QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
                local ped = PlayerPedId()
                local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
                local StirrupUsing = "0x"..v 
                if mount ~= nil then
                    Citizen.InvokeNative(0xD3A7B003ED343FD9, mount, tonumber(StirrupUsing), true, true, true) 
                    local StirrupData = {
                        StirrupUsing
                    } 
                    local StirrupDataEncoded = StirrupUsing
                    TriggerServerEvent('tcrp-stables:server:SaveStirrup',StirrupDataEncoded)
                else 
                    QRCore.Functions.Notify('No Horse Found', 'error')
                end
            end)
        end
        StirrupMenu()
    end
end)
---------------------------- Stirrups End ------------------------- 

---------------------------- Mane Begin ------------------------- 
function ManeMenu(hash)
    local maneMenu = {
        {
            header = "Manes",
            isMenuHeader = true
        }
    }
    local manes = Config.Manes  

    maneMenu[#maneMenu+1] = {
        header = "Go Back",
        txt = "",
        icon = "fas fa-angle-double-left",
        params = {
            event = 'tcrp-stables:custMenu'
        }

    }

        maneMenu[#maneMenu+1] = {
            header = "Remove Mane",
            txt = "",
            params = {
                event = "tcrp-stables:client:applyMane",
                arg = {
                    mane = nil
                }
            }
        }

    for k, v in pairs(manes) do
        maneMenu[#maneMenu+1] = {
            header = v.Name,
            txt = "",
            params = {
                event = "tcrp-stables:client:applyMane",
                args = {
                    mane = v.Hash
                }
            }
        }
    end

    exports['qr-menu']:openMenu(maneMenu)
end

RegisterNetEvent('tcrp-stables:client:maneMenu',function()
    ManeMenu()
end)

RegisterNetEvent('tcrp-stables:client:applyMane',function(mane,data)
    if mane == nil then
        QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
            local ped = PlayerPedId()
            local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
            local ManeUsing = 0
            print("mane")
            if mount ~= nil then
                Citizen.InvokeNative(0xD710A5007C2AC539, mount, 0xAA0217AB, 0) -- HAT REMOVE
                Citizen.InvokeNative(0xCC8CA3E88256E58F, mount, 0, 1, 1, 1, 0) -- Actually remove the component
                local ManeData = {
                    ManeUsing
                } 
                local ManeDataEncoded = ManeUsing
                TriggerServerEvent('tcrp-stables:server:SaveMane',ManeDataEncoded)
            else 
                QRCore.Functions.Notify('No Horse Found', 'error')
            end
        end)
        ManeMenu()
    else
        for k,v in pairs(mane) do
            QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
                local ped = PlayerPedId()
                local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
                local ManeUsing = "0x"..v 
                if mount ~= nil then
                    Citizen.InvokeNative(0xD3A7B003ED343FD9, mount, tonumber(ManeUsing), true, true, true) 
                    local ManeData = {
                        ManeUsing
                    } 
                    local ManeDataEncoded = ManeUsing
                    TriggerServerEvent('tcrp-stables:server:SaveMane',ManeDataEncoded)
                else 
                    QRCore.Functions.Notify('No Horse Found', 'error')
                end
            end)
        end
        ManeMenu()
    end
end)
---------------------------- Mane End ------------------------- 

---------------------------- Tail Begin ------------------------- 
function TailMenu(hash)
    local tailMenu = {
        {
            header = "Tails",
            isMenuHeader = true
        }
    }
    local tails = Config.Tails  

    tailMenu[#tailMenu+1] = {
        header = "Go Back",
        txt = "",
        icon = "fas fa-angle-double-left",
        params = {
            event = 'tcrp-stables:custMenu'
        }

    }

        tailMenu[#tailMenu+1] = {
            header = "Remove Tail",
            txt = "",
            params = {
                event = "tcrp-stables:client:applyTail",
                arg = {
                    tail = nil
                }
            }
        }

    for k, v in pairs(tails) do
        tailMenu[#tailMenu+1] = {
            header = v.Name,
            txt = "",
            params = {
                event = "tcrp-stables:client:applyTail",
                args = {
                    tail = v.Hash
                }
            }
        }
    end

    exports['qr-menu']:openMenu(tailMenu)
end

RegisterNetEvent('tcrp-stables:client:tailMenu',function()
    TailMenu()
end)

RegisterNetEvent('tcrp-stables:client:applyTail',function(tail,data)
    if tail == nil then
        QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
            local ped = PlayerPedId()
            local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
            local TailUsing = 0
            print("tail")
            if mount ~= nil then
                Citizen.InvokeNative(0xD710A5007C2AC539, mount, 0x17CEB41A, 0) -- HAT REMOVE
                Citizen.InvokeNative(0xCC8CA3E88256E58F, mount, 0, 1, 1, 1, 0) -- Actually remove the component
                local TailData = {
                    TailUsing
                } 
                local TailDataEncoded = TailUsing
                TriggerServerEvent('tcrp-stables:server:SaveTail',TailDataEncoded)
            else 
                QRCore.Functions.Notify('No Horse Found', 'error')
            end
        end)
        TailMenu()
    else
        for k,v in pairs(tail) do
            QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
                local ped = PlayerPedId()
                local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
                local TailUsing = "0x"..v 
                if mount ~= nil then
                    Citizen.InvokeNative(0xD3A7B003ED343FD9, mount, tonumber(TailUsing), true, true, true) 
                    local TailData = {
                        TailUsing
                    } 
                    local TailDataEncoded = TailUsing
                    TriggerServerEvent('tcrp-stables:server:SaveTail',TailDataEncoded)
                else 
                    QRCore.Functions.Notify('No Horse Found', 'error')
                end
            end)
        end
        TailMenu()
    end
end)
---------------------------- Tail End ------------------------- 

---------------------------- Mask Begin ------------------------- 
function MaskMenu(hash)
    local maskMenu = {
        {
            header = "Masks",
            isMenuHeader = true
        }
    }
    local masks = Config.Masks  

    maskMenu[#maskMenu+1] = {
        header = "Go Back",
        txt = "",
        icon = "fas fa-angle-double-left",
        params = {
            event = 'tcrp-stables:custMenu'
        }

    }

        maskMenu[#maskMenu+1] = {
            header = "Remove Mask",
            txt = "",
            params = {
                event = "tcrp-stables:client:applyMask",
                arg = {
                    mask = nil
                }
            }
        }

    for k, v in pairs(masks) do
        maskMenu[#maskMenu+1] = {
            header = v.Name,
            txt = "",
            params = {
                event = "tcrp-stables:client:applyMask",
                args = {
                    mask = v.Hash
                }
            }
        }
    end

    exports['qr-menu']:openMenu(maskMenu)
end

RegisterNetEvent('tcrp-stables:client:maskMenu',function()
    MaskMenu()
end)

RegisterNetEvent('tcrp-stables:client:applyMask',function(mask,data)
    if mask == nil then
        QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
            local ped = PlayerPedId()
            local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
            local MaskUsing = 0
            print("mask")
            if mount ~= nil then
                Citizen.InvokeNative(0xD710A5007C2AC539, mount, 0xD3500E5D, 0) -- HAT REMOVE
                Citizen.InvokeNative(0xCC8CA3E88256E58F, mount, 0, 1, 1, 1, 0) -- Actually remove the component
                local MaskData = {
                    MaskUsing
                } 
                local MaskDataEncoded = MaskUsing
                TriggerServerEvent('tcrp-stables:server:SaveMask',MaskDataEncoded)
            else 
                QRCore.Functions.Notify('No Horse Found', 'error')
            end
        end)
        MaskMenu()
    else
        for k,v in pairs(mask) do
            QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
                local ped = PlayerPedId()
                local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
                local MaskUsing = "0x"..v 
                if mount ~= nil then
                    Citizen.InvokeNative(0xD3A7B003ED343FD9, mount, tonumber(MaskUsing), true, true, true) 
                    local MaskData = {
                        MaskUsing
                    } 
                    local MaskDataEncoded = MaskUsing
                    TriggerServerEvent('tcrp-stables:server:SaveMask',MaskDataEncoded)
                else 
                    QRCore.Functions.Notify('No Horse Found', 'error')
                end
            end)
        end
        MaskMenu()
    end
end)
---------------------------- Mask End ------------------------- 

---------------------------- Luggage Begin ------------------------- 
function LuggageMenu(hash)
    local luggageMenu = {
        {
            header = "Luggages",
            isMenuHeader = true
        }
    }
    local luggages = Config.Luggage 

    luggageMenu[#luggageMenu+1] = {
        header = "Go Back",
        txt = "",
        icon = "fas fa-angle-double-left",
        params = {
            event = 'tcrp-stables:custMenu'
        }

    }

        luggageMenu[#luggageMenu+1] = {
            header = "Remove Luggage",
            txt = "",
            params = {
                event = "tcrp-stables:client:applyLuggage",
                arg = {
                    luggage = nil
                }
            }
        }

    for k, v in pairs(luggages) do
        luggageMenu[#luggageMenu+1] = {
            header = v.Name,
            txt = "",
            params = {
                event = "tcrp-stables:client:applyLuggage",
                args = {
                    luggage = v.Hash
                }
            }
        }
    end

    exports['qr-menu']:openMenu(luggageMenu)
end

RegisterNetEvent('tcrp-stables:client:luggageMenu',function()
    LuggageMenu()
end)

RegisterNetEvent('tcrp-stables:client:applyLuggage',function(luggage,data)
    if luggage == nil then
        QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
            local ped = PlayerPedId()
            local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
            local LuggageUsing = 0
            print("luggage")
            if mount ~= nil then
                Citizen.InvokeNative(0xD710A5007C2AC539, mount, 0xEFB31921, 0) -- HAT REMOVE
                Citizen.InvokeNative(0xCC8CA3E88256E58F, mount, 0, 1, 1, 1, 0) -- Actually remove the component
                local LuggageData = {
                    LuggageUsing
                } 
                local LuggageDataEncoded = LuggageUsing
                TriggerServerEvent('tcrp-stables:server:SaveLuggage',LuggageDataEncoded)
            else 
                QRCore.Functions.Notify('No Horse Found', 'error')
            end
        end)
        LuggageMenu()
    else
        for k,v in pairs(luggage) do
            QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
                local ped = PlayerPedId()
                local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)   
                local LuggageUsing = "0x"..v 
                if mount ~= nil then
                    Citizen.InvokeNative(0xD3A7B003ED343FD9, mount, tonumber(LuggageUsing), true, true, true) 
                    local LuggageData = {
                        LuggageUsing
                    } 
                    local LuggageDataEncoded = LuggageUsing
                    TriggerServerEvent('tcrp-stables:server:SaveLuggage',LuggageDataEncoded)
                else 
                    QRCore.Functions.Notify('No Horse Found', 'error')
                end
            end)
        end
        LuggageMenu()
    end
end)
------- Tack Menu End -------

function applyImportantThings()
    Citizen.InvokeNative(0x931B241409216C1F, PlayerPedId(), horsePed, 0)
    SetPedConfigFlag(horsePed, 297, true)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:CheckSaddle', function(cb,saddle)
        print(tonumber(cb.saddle))
        local ped = PlayerPedId()
        local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horsePed, tonumber(cb.saddle), true, true, true) 
    end)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:CheckBlanket', function(cb,blanket)
        print(tonumber(cb.blanket))
        local ped = PlayerPedId()
        local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horsePed, tonumber(cb.blanket), true, true, true) 
    end)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:CheckBag', function(cb,bag)
        print(tonumber(cb.bag))
        local ped = PlayerPedId()
        local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horsePed, tonumber(cb.bag), true, true, true) 
    end)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:CheckHorn', function(cb,horn)
        print(tonumber(cb.horn))
        local ped = PlayerPedId()
        local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horsePed, tonumber(cb.horn), true, true, true) 
    end)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:CheckStirrup', function(cb,stirrup)
        print(tonumber(cb.stirrup))
        local ped = PlayerPedId()
        local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horsePed, tonumber(cb.stirrup), true, true, true) 
    end)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:CheckMane', function(cb,mane)
        print(tonumber(cb.mane))
        local ped = PlayerPedId()
        local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horsePed, tonumber(cb.mane), true, true, true) 
    end)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:CheckTail', function(cb,tail)
        print(tonumber(cb.tail))
        local ped = PlayerPedId()
        local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horsePed, tonumber(cb.tail), true, true, true) 
    end)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:CheckLuggage', function(cb,luggage)
        print(tonumber(cb.luggage))
        local ped = PlayerPedId()
        local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horsePed, tonumber(cb.luggage), true, true, true) 
    end)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:CheckMask', function(cb,mask)
        print(tonumber(cb.mask))
        local ped = PlayerPedId()
        local mount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horsePed, tonumber(cb.mask), true, true, true) 
    end)
end

function moveHorseToPlayer()
    Citizen.CreateThread(function()
        Citizen.InvokeNative(0x6A071245EB0D1882, horsePed, PlayerPedId(), -1, 5.0, 15.0, 0, 0)
        while horseSpawned == true do
            local coords = GetEntityCoords(PlayerPedId())
            local horseCoords = GetEntityCoords(horsePed)
            local distance = #(coords - horseCoords)
            if (distance < 7.0) then
                ClearPedTasks(horsePed, true, true)
                horseSpawned = false
            end
            Wait(1000)
        end
    end)
end

function setPedDefaultOutfit(model)
    return Citizen.InvokeNative(0x283978A15512B2FE, model, true)
end

function getControlOfEntity(entity)
    NetworkRequestControlOfEntity(entity)
    SetEntityAsMissionEntity(entity, true, true)
    local timeout = 2000

    while timeout > 0 and NetworkHasControlOfEntity(entity) == nil do
        Wait(100)
        timeout = timeout - 100
    end
    return NetworkHasControlOfEntity(entity)
end


Citizen.CreateThread(function()
    while true do
        if (timeout) then
            if (timeoutTimer == 0) then
                timeout = false
            end
            timeoutTimer = timeoutTimer - 1
            Wait(1000)
        end
        Wait(0)
    end
end)


local function Flee()
    TaskAnimalFlee(horsePed, PlayerPedId(), -1)
    Wait(10000)
    DeleteEntity(horsePed)
    Wait(1000)
    horsePed = 0
    HorseCalled = false
end

CreateThread(function()
    while true do
        Wait(1)
        if Citizen.InvokeNative(0x91AEF906BCA88877, 0, QRCore.Shared.Keybinds['H']) then -- call horse
            if not HorseCalled then
            SpawnHorse()
            HorseCalled = true
            Wait(10000) -- Spam protect
     else
        moveHorseToPlayer()
         end
    elseif Citizen.InvokeNative(0x91AEF906BCA88877, 0, QRCore.Shared.Keybinds['HorseCommandFlee']) then -- flee horse
            if horseSpawned ~= 0 then
                Flee()
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if (resource == GetCurrentResourceName()) then
        for k,v in pairs(entities) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(rhodesentities) do 
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(tbentities) do 
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(sdentities) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(strawberryentities) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(bwentities) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(vhentities) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(centities) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(npcs) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(bwnpcs) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(sbnpcs) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(sdnpcs) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(twnpcs) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(vhnpcs) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(rhnpcs) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
        for k,v in pairs(cnpcs) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end

        if (horsePed ~= 0) then
            DeletePed(horsePed)
            SetEntityAsNoLongerNeeded(horsePed)
        end

        
    end
    DestroyAllCams()
end)

CreateThread(function()
    for key,value in pairs(Config.ModelSpawns) do
        local StablesBlip = N_0x554d9d53f696d002(1664425300, value.coords)
        SetBlipSprite(StablesBlip, 1938782895, 52)
        SetBlipScale(StablesBlip, 0.1)
        Citizen.InvokeNative(0x9CB1A1623062F402, tonumber(StablesBlip), "Horse Stable")
    end
end)

local HorseId = nil

RegisterNetEvent('tcrp-stables:client:SpawnHorse', function(data)
    HorseId = data.player.id
    TriggerServerEvent("tcrp-stables:server:SetHoresActive", data.player.id)
    QRCore.Functions.Notify('Horse has been set active call from back by whistling', 'success', 7500)
end)

RegisterNetEvent("tcrp-stables:client:storehorse", function(data)
 if (horsePed ~= 0) then
    TriggerServerEvent("tcrp-stables:server:SetHoresUnActive", HorseId)
    QRCore.Functions.Notify('Taking your horse to the back', 'success', 7500)
    Flee()
    Wait(10000)
    DeletePed(horsePed)
    SetEntityAsNoLongerNeeded(horsePed)
    HorseCalled = false
    end
end)

RegisterNetEvent("tcrp-stables:client:tradehorse", function(data)
    QRCore.Functions.TriggerCallback('tcrp-stables:server:GetActiveHorse', function(data,newnames)
        if (horsePed ~= 0) then
            TradeHorse()
            Flee()
            Wait(10000)
            DeletePed(horsePed)
            SetEntityAsNoLongerNeeded(horsePed)
            HorseCalled = false
        else
            QRCore.Functions.Notify('You dont have a horse out', 'success', 7500)
        end
    end)
end)

RegisterNetEvent('tcrp-stables:client:menu', function()
    local GetHorse = {
        {
            header = "| My Horses |",
            isMenuHeader = true,
            icon = "fa-solid fa-circle-user",
        },
    }
    QRCore.Functions.TriggerCallback('tcrp-stables:server:GetHorse', function(cb)
        for _, v in pairs(cb) do
            GetHorse[#GetHorse + 1] = {
                header = v.name,
                txt = "select you horse",
                icon = "fa-solid fa-circle-user",
                params = {
                    event = "tcrp-stables:client:SpawnHorse",
                    args = {
                        player = v,
                        active = 1
                    }
                }
            }
        end
        exports['qr-menu']:openMenu(GetHorse)
    end)
end)

RegisterNetEvent('tcrp-stables:client:MenuDel', function()
    local GetHorse = {
        {
            header = "| Sell Horses |",
            isMenuHeader = true,
            icon = "fa-solid fa-circle-user",
        },
    }
    QRCore.Functions.TriggerCallback('tcrp-stables:server:GetHorse', function(cb)
        for _, v in pairs(cb) do
            GetHorse[#GetHorse + 1] = {
                header = v.name,
                txt = "Sell you horse",
                icon = "fa-solid fa-circle-user",
                params = {
                    event = "tcrp-stables:client:MenuDelC",
                    args = {}
                }
            }
        end
        exports['qr-menu']:openMenu(GetHorse)
    end)
end)


RegisterNetEvent('tcrp-stables:client:MenuDelC', function(data)
    local GetHorse = {
        {
            header = "| Confirm Sell Horses |",
            isMenuHeader = true,
            icon = "fa-solid fa-circle-user",
        },
    }
    QRCore.Functions.TriggerCallback('tcrp-stables:server:GetHorse', function(cb)
        for _, v in pairs(cb) do
            GetHorse[#GetHorse + 1] = {
                header = v.name,
                txt = "Doing this will make you lose your horse forever!",
                icon = "fa-solid fa-circle-user",
                params = {
                    event = "tcrp-stables:client:DeleteHorse",
                    args = {
                        player = v,
                        active = 1
                    }
                }
            }
        end
        exports['qr-menu']:openMenu(GetHorse)
    end)
end)

RegisterNetEvent('tcrp-stables:client:DeleteHorse', function(data)
    QRCore.Functions.Notify('Horse has been successfully removed', 'success', 7500)
    TriggerServerEvent("tcrp-stables:server:DelHores", data.player.id)
end)

    ----------------------------- Humanity's Command Cave   -----------------------------
    RegisterCommand("hl", function()
        Citizen.InvokeNative(0xD3A7B003ED343FD9, SpawnplayerHorse, 0x635E387C, true, true, true) -- add comp
    end)
    RegisterCommand("hlx", function()
        Citizen.InvokeNative(0x0D7FFA1B2F69ED82, SpawnplayerHorse, 0x635E387C, true, true, true) -- remove comp
    end)
    --[[     RegisterCommand("saoff", function()
        Citizen.InvokeNative(0x0D7FFA1B2F69ED82, SpawnplayerHorse, 0x150D0DAA, true, true, true) -- remove comp
    end) ]]
    RegisterCommand("hfemale", function()
        Citizen.InvokeNative(0x5653AB26C82938CF, entity, 41611, 0.0)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, entity, 0, 1, 1, 1, 0)
    end) 
    RegisterCommand("hmale", function()
        Citizen.InvokeNative(0x5653AB26C82938CF, entity, 41611, 1.0) 
        Citizen.InvokeNative(0xCC8CA3E88256E58F, entity, 0, 1, 1, 1, 0)
    end) 
    -- Exiting Humanity's Command Cave

    ----------------------------- Chat Suggestions   -----------------------------
    TriggerEvent("chat:addSuggestion", "/hl", "Add a lantern to your horse!", {
        {name = "", help = "to remove do /hlx"}
    })
    TriggerEvent("chat:addSuggestion", "/hlx", "Remove the lantern from your horse", {
        {name = "", help = "Do /hl to add a lantern"}
    })
    TriggerEvent("chat:addSuggestion", "/hfemale", "Turn your horse female!", {
    })
    TriggerEvent("chat:addSuggestion", "/hmale", "Turn your horse male!", {
    })
    ----------------------------- Chat Suggestions End   -----------------------------

    ----------------------------- Inventory Shit   -----------------------------
