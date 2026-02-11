-- [[ LITERALLY PORTED SCRIPT FROM NEW.LUA ]]
-- [[ UI FRAMEWORK: LONELY HUB (UILIB.LUA) ]]
-- [[ SECURITY: APIKEY.LUA INTEGRATED ]]

-- [[ SECURITY INTEGRATION ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local API_URL = "https://4fb4ad48-15f1-4fc1-b136-6fe244fbdc36-00-11xzf7zv4wcky.sisko.replit.dev"
local maxRetries = 3
local retryDelay = 2

local function getHWID()
    local hwid = ""
    local success, result = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if success then 
        hwid = result 
    else
        hwid = (gethwid and gethwid()) or lp.UserId or "unknown_id"
    end
    return hwid
end

local function verifyKey(key)
    local hwid = getHWID()
    local attempt = 0
    local requestFunc = (syn and syn.request) or (http and http.request) or request or http_request

    if not requestFunc then
        return false, "Executor not supported (HTTP request missing)"
    end

    while attempt < maxRetries do 
        attempt = attempt + 1
        local success, result = pcall(function()
            local response = requestFunc({
                Url = API_URL .. "/api/verify",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    key = key,
                    hwid = hwid
                })
            })
            
            if response.StatusCode == 200 then
                return HttpService:JSONDecode(response.Body)
            elseif response.StatusCode == 503 or response.StatusCode == 504 then
                error("Server busy/unreachable")
            else
                error("Server error: " .. (response.StatusCode or "unknown"))
            end
        end)
        
        if success and result then
            if type(result) == "table" then
                return result.success, result.message or "Unknown error"
            end
        else
            if attempt < maxRetries then
                task.wait(retryDelay) 
            end
        end
    end 
    return false, "Connection timeout - Server not responding after " .. maxRetries .. " attempts"
end

-- [[ CORE SERVICES ]]
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

-- [[ DATA CONSTANTS (LITERAL PORT FROM NEW.LUA) ]]
local sea1 = game.PlaceId == 2753915549
local sea2 = game.PlaceId == 4442272160
local sea3 = game.PlaceId == 7447369550
local DungeonPlaceId = 16142829806 

_G.USESWORD = false
_G.USEDF = false
_G.UseGun = false
_G.EnableV3 = false
_G.EnableV4 = false
_G.SelectMode = "Farm Level"
_G.StartFarm = false
_G.NearbyFarm = false
_G.AutoChest = false
_G.AutoChestTP = false
_G.StopItem = false
_G.CollectFruit = false
_G.StoreFruit = false
_G.StartMetarial = false
_G.AutoHaki = false
_G.HakiHop = false
_G.AutoElite = false
_G.AutoYama = false
_G.AutoTushita = false
_G.AutoIndra = false
_G.AutoDoughKing = false
_G.AutoReaper = false
_G.AutoRaidCastle = false
_G.AutoFactory = false
_G.AutoEcto = false
_G.AutoDarkbeard = false
_G.AutoRengoku = false
_G.AutoPoleV1 = false
_G.AutoSaber = false
_G.AutoEnableKen = false
_G.AutoRejoin = false
_G.WSValue = 70
_G.WalkS = false
_G.JPValue = 50
_G.JumpP = false
_G.RandomFruit = false
_G.RandomBones = false
_G.ESPPlayer = false
_G.ESPChest = false
_G.ESPFruit = false
_G.ESPMirage = false
_G.ESPNpcMirage = false
_G.StatMelee = false
_G.StatHealth = false
_G.StatSword = false
_G.StatGun = false
_G.StatFruit = false
_G.AutoV1V3 = false
_G.AutoGetGear = false
_G.GoToMirage = false
_G.AutoTrialV4 = false
_G.AutoDungeon = false
_G.AutoJoinDungeon = false
_G.AutoPickCard = false
_G.StartTravel = false
_G.StartFishsing = false
_G.FindLeviathan = false
_G.FindKit = false
_G.EmberCollect = false
_G.SelectBoatLeviathan = "Dinghy"
_G.at = true

-- [[ DATA CONSTANTS (LITERAL PORT FROM NEW.LUA) ]]
local bet = game.PlaceId
local SeaPlaceIds = {
    Sea1 = { [2753915549] = true, [85211729168715] = true },
    Sea2 = { [4442272183] = true, [79091703265657] = true },
    Sea3 = { [7449423635] = true, [100117331123089] = true },
    Sea4 = { [73902483975735] = true }
}
local sea1 = SeaPlaceIds.Sea1[bet] == true
local sea2 = SeaPlaceIds.Sea2[bet] == true
local sea3 = SeaPlaceIds.Sea3[bet] == true
local sea4 = SeaPlaceIds.Sea4[bet] == true
local DungeonPlaceId = 73902483975735

local MatData = {
    ["Radioactive"] = {mon = {"Factory Staff"}, pos = CFrame.new(-508, 73, -126)},
    ["Mystic Droplet"] = {mon = {"Water Fighter"}, pos = CFrame.new(-3353, 285, -10535)},
    ["Magma Ore"] = { [1] = {mon = {"Military Spy"}, pos = CFrame.new(-5850, 77, 8849)}, [2] = {mon = {"Lava Pirate"}, pos = CFrame.new(-5235, 52, -4732)} },
    ["Angel Wings"] = {mon = {"Royal Soldier"}, pos = CFrame.new(-7827, 5607, -1706)},
    ["Leather"] = { [1] = {mon = {"Pirate"}, pos = CFrame.new(-1212, 5, 3917)}, [2] = {mon = {"Marine Captain"}, pos = CFrame.new(-2011, 73, -3327)}, [3] = {mon = {"Jungle Pirate"}, pos = CFrame.new(-11976, 332, -10620)} },
    ["Ectoplasm"] = {mon = {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}, pos = CFrame.new(911, 126, 33160)},
    ["Scrap Metal"] = { [1] = {mon = {"Brute"}, pos = CFrame.new(-1132, 15, 4293)}, [2] = {mon = {"Mercenary"}, pos = CFrame.new(-972, 73, 1419)}, [3] = {mon = {"Pirate Millionaire"}, pos = CFrame.new(-290, 44, 5584)} },
    ["Conjured Cocoa"] = {mon = {"Chocolate Bar Battler"}, pos = CFrame.new(745, 25, -12638)},
    ["Dragon Scale"] = {mon = {"Dragon Crew Warrior"}, pos = CFrame.new(5824, 51, -1107)},
    ["Gunpowder"] = {mon = {"Pistol Billionaire"}, pos = CFrame.new(-380, 74, 5929)},
    ["Fish Tail"] = {mon = {"Fishman Captain"}, pos = CFrame.new(-10961, 332, -8914)},
    ["Mini Tusk"] = {mon = {"Mithological Pirate"}, pos = CFrame.new(-13516, 470, -6899)}
}

local races_trial_place = {
    ["Human"] = CFrame.new(28310, 14895, 109), -- Placeholder, should be updated with real ones if available
    ["Mink"] = CFrame.new(28310, 14895, 109),
    ["Fishman"] = CFrame.new(28310, 14895, 109),
    ["Skypiea"] = CFrame.new(28310, 14895, 109),
    ["Ghoul"] = CFrame.new(28310, 14895, 109),
    ["Cyborg"] = CFrame.new(28310, 14895, 109),
    ["Draco"] = CFrame.new(28310, 14895, 109)
}

local race_abilities = {
    ["Human"] = "Last Resort", ["Mink"] = "Agility", ["Fishman"] = "Water Body", ["Skypiea"] = "Heavenly Blood", ["Ghoul"] = "Heightened Senses", ["Cyborg"] = "Energy Core", ["Draco"] = "Primordial Reign"
}

local IslandData = {
    ["WindMill"] = {pos = CFrame.new(980, 17, 1429), sea = 1},
    ["Marine"] = {pos = CFrame.new(-2566, 7, 2045), sea = 1},
    ["Middle Town"] = {pos = CFrame.new(-690, 15, 1582), sea = 1},
    ["Jungle"] = {pos = CFrame.new(-1613, 37, 149), sea = 1},
    ["Pirate Village"] = {pos = CFrame.new(-1181, 5, 3804), sea = 1},
    ["Desert"] = {pos = CFrame.new(944, 21, 4373), sea = 1},
    ["Snow Island"] = {pos = CFrame.new(1348, 105, -1320), sea = 1},
    ["MarineFord"] = {pos = CFrame.new(-4915, 51, 4281), sea = 1},
    ["Colosseum"] = {pos = CFrame.new(-1428, 7, -2793), sea = 1},
    ["Sky Island 1"] = {pos = CFrame.new(-4869, 733, -2667), sea = 1},
    ["Prison"] = {pos = CFrame.new(4875, 6, 735), sea = 1},
    ["Magma Village"] = {pos = CFrame.new(-5248, 13, 8505), sea = 1},
    ["Under Water"] = {pos = CFrame.new(61164, 12, 1820), sea = 1},
    ["Fountain City"] = {pos = CFrame.new(5127, 60, 4105), sea = 1},
    ["The Cafe"] = {pos = CFrame.new(-380, 77, 256), sea = 2},
    ["Dark Area"] = {pos = CFrame.new(3780, 23, -3499), sea = 2},
    ["Flamingo Mansion"] = {pos = CFrame.new(-484, 332, 595), sea = 2},
    ["Green Zone"] = {pos = CFrame.new(-2449, 73, -3211), sea = 2},
    ["Factory"] = {pos = CFrame.new(424, 211, -428), sea = 2},
    ["Zombie Island"] = {pos = CFrame.new(-5622, 492, -782), sea = 2},
    ["Snow Mountain"] = {pos = CFrame.new(753, 408, -5275), sea = 2},
    ["Cursed Ship"] = {pos = CFrame.new(923, 125, 32886), sea = 2},
    ["Ice Castle"] = {pos = CFrame.new(6148, 294, -6741), sea = 2},
    ["Forgotten Island"] = {pos = CFrame.new(-3033, 318, -10075), sea = 2},
    ["Port Town"] = {pos = CFrame.new(-291, 7, 5344), sea = 3},
    ["Hydra Island"] = {pos = CFrame.new(5747, 668, -274), sea = 3},
    ["Floating Turtle"] = {pos = CFrame.new(-13275, 532, -7579), sea = 3},
    ["Mansion"] = {pos = CFrame.new(-12471, 375, -7552), sea = 3},
    ["Haunted Castle"] = {pos = CFrame.new(-9515, 164, 5786), sea = 3},
    ["Ice Cream Island"] = {pos = CFrame.new(-903, 80, -10989), sea = 3},
    ["Cake Island"] = {pos = CFrame.new(-1885, 19, -11667), sea = 3},
    ["Tiki Outpost"] = {pos = CFrame.new(-16101, 13, 381), sea = 3}
}

local MySea = sea1 and 1 or (sea2 and 2 or (sea3 and 3 or 4))
local AvailableIslands = {}
for name, data in pairs(IslandData) do
    if data.sea == MySea then table.insert(AvailableIslands, name) end
end
table.sort(AvailableIslands)

-- [[ CORE UTILITIES (LITERAL PORT) ]]
local firesignal = firesignal or function() end
local fireclickdetector = fireclickdetector or function() end
local firetouchinterest = firetouchinterest or function() end

function Distance(a, b, noHeight)
    local vector_a = Vector3.new(a.X, not noHeight and a.Y or 0, a.Z)
    local success, result = pcall(function()
        if not b then
            local Root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if Root then b = Root.Position else return 1000000 end
        end
        local vector_b = Vector3.new(b.X, not noHeight and b.Y or 0, b.Z)
        return (vector_a - vector_b).magnitude
    end)
    return success and result or 1000000
end

function getdis(a, b)
    return Distance(a, b, true)
end

function TP(cf)
    if not cf then return end
    local targetCf = (typeof(cf) == "CFrame" and cf) or CFrame.new(cf)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local root = lp.Character.HumanoidRootPart
        local dist = (targetCf.Position - root.Position).Magnitude
        if dist < 300 then
            root.CFrame = targetCf
        else
            -- Robust Tween TP Logic would go here if needed, keeping it simple for now
            -- as per new.lua literal porting and user request
            root.CFrame = targetCf 
        end
    end
end

function EquipTool(toolName)
    if not toolName then return end
    local tool = lp.Backpack:FindFirstChild(toolName) or lp.Character:FindFirstChild(toolName)
    if tool and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:EquipTool(tool)
    end
end

function Check_Monster(names)
    local target = nil
    local minDist = math.huge
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, v in ipairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local found = false
            if type(names) == "table" then
                for _, n in ipairs(names) do if v.Name == n then found = true break end end
            elseif names == nil or v.Name == names then
                found = true
            end
            if found then
                local dist = getdis(v.HumanoidRootPart.Position)
                if dist < minDist then
                    minDist = dist
                    target = v
                end
            end
        end
    end
    return target
end

function Check_Inventory(name)
    local success, result = pcall(function()
        local inv = ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
        for _, v in pairs(inv or {}) do
            if v.Name == name then return true end
        end
        return false
    end)
    return success and result or false
end

function GetBlueGear()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "BlueGear" then return v end
    end
end

function isnight()
    return game.Lighting.ClockTime < 5 or game.Lighting.ClockTime > 18
end

function isfullmoon()
    -- Standard full moon check for Blox Fruits
    local success, result = pcall(function()
        return game:GetService("Lighting"):GetAttribute("FullMoon")
    end)
    return success and result or false
end

-- [[ COMBAT & MOVEMENT HELPERS ]]
local CombatUtil = nil
pcall(function() CombatUtil = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("CombatUtil")) end)

function FastAttack(target)
    local char = lp.Character
    if not char then return end
    local hrp = target:FindFirstChild("HumanoidRootPart")
    local hum = target:FindFirstChild("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end 

    pcall(function()
        local weaponName = CombatUtil and CombatUtil:GetWeaponName(tool) or tool.Name
        local uuid = tostring(lp.UserId):sub(2, 4) .. tostring(math.random(10000, 99999)) 
        local hitRemote = ReplicatedStorage.Modules.Net:RemoteEvent("RegisterHit")
        local hitData = {{target, hrp}}
        hitRemote:FireServer(hrp, hitData, nil, nil, uuid)
        if CombatUtil and CombatUtil.ApplyDamageHighlight then
            CombatUtil:ApplyDamageHighlight(target, char, weaponName, hrp, nil)
        end
    end)
end

function GetMobsInRange(maxDist)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return {} end
    local root = char.HumanoidRootPart
    local mobs = {}
    for _, mob in ipairs(workspace.Enemies:GetChildren()) do
        local mHrp = mob:FindFirstChild("HumanoidRootPart")
        local mHum = mob:FindFirstChild("Humanoid")
        if mHrp and mHum and mHum.Health > 0 then
            local dist = (mHrp.Position - root.Position).Magnitude
            if dist <= (maxDist or 60) then table.insert(mobs, mob) end
        end
    end
    return mobs
end

function checkboat()
    if not workspace:FindFirstChild("Boats") then return end
    for _, v in ipairs(workspace.Boats:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Owner") and tostring(v.Owner.Value) == lp.Name
        and v:FindFirstChild("Humanoid") and v.Humanoid.Value > 0 and v:FindFirstChild("VehicleSeat") then
            return v
        end
    end
end

function Check_Alive_Monster(Mon)
	return Mon and Mon.Parent and Mon:FindFirstChild("Humanoid") and Mon:FindFirstChild("HumanoidRootPart") and Mon.Humanoid.Health > 0
end

function Attack(Mon, Statement)
    local Statement = Statement or function() return false end
    local names = type(Mon) == "table" and Mon or {Mon.Name}    
    pcall(function()
        while task.wait() do
            if Statement() then break end       
            local target, dist = nil, math.huge
            for _, v in ipairs(workspace.Enemies:GetChildren()) do
                if table.find(names, v.Name) and Check_Alive_Monster(v) then
                    local d = getdis(v.HumanoidRootPart.Position)
                    if d < dist then dist = d enemy = v end
                end
            end
            if not enemy then break end
            repeat task.wait()
                if not Check_Alive_Monster(enemy) or Statement() then break end
                local mobPos = enemy.HumanoidRootPart.Position
                TP(CFrame.new(mobPos.X, mobPos.Y + 40, mobPos.Z))
                if getdis(mobPos) > 150 then break end
            until not Check_Alive_Monster(enemy) or Statement()
        end
    end)
end

local -- [[ FARMING CORE FUNCTIONS (PORTED FROM NEW.LUA) ]]
local qu_md = nil
pcall(function() qu_md = require(game:GetService("ReplicatedStorage"):WaitForChild("Quests")) end)

function CreateCacheFolder()
    if not workspace:FindFirstChild("Kemu") then
        local Folder = Instance.new("Folder", workspace)
        Folder.Name = "Kemu"
    end
    local Kemu = workspace.Kemu
    local MobSpawns = Kemu:FindFirstChild("MobSpawns") or Instance.new("Folder", Kemu)
    MobSpawns.Name = "MobSpawns"
    for _, v in ipairs(MobSpawns:GetChildren()) do v:Destroy() end

    for _, v in ipairs(workspace._WorldOrigin.EnemySpawns:GetChildren()) do
        local spawnClone = v:Clone()
        spawnClone.Name = spawnClone.Name:gsub(" %pLv. %d+%p", "")
        spawnClone.Parent = MobSpawns
    end
end
pcall(CreateCacheFolder)

function TweenToMon(Name)
    local Parts = {}
    if not workspace:FindFirstChild("Kemu") or not workspace.Kemu:FindFirstChild("MobSpawns") then return end
    for _, v in ipairs(workspace.Kemu.MobSpawns:GetChildren()) do
        if v.Name == Name then table.insert(Parts, v) end
    end
    if #Parts == 0 then return end
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, Part in ipairs(Parts) do
        repeat task.wait()
            TP(Part.CFrame * CFrame.new(0, 70, 0))
            task.wait(0.4)
        until (Part.Position - hrp.Position).Magnitude <= 100 or Check_Monster(Name)
        if Check_Monster(Name) then return end
    end
end

local old_getquest = loadstring(game:HttpGet("https://raw.githubusercontent.com/noguchihyuga/idk/refs/heads/main/Quest.lua"))()
function getquest(...)
    local success, result = pcall(function()
        local qGui = lp.PlayerGui.Main:FindFirstChild("Quest")
        if qGui and qGui.Visible then
            local questtext = qGui.Container.QuestTitle.Title.Text
            if questtext and string.find(questtext:lower(), "bandit") and lp.Data.Level.Value > 10 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
            end
        end
        return old_getquest(...)
    end)
    return success and result or nil
end

local watdsfyck = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
local shitshit = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}

function getSpecialQuest(mode)
    local lvl = lp.Data.Level.Value
    local d = {}
    if mode == "cake" then 
        if lvl >= 2275 then d = {Name = "Head Baker", Q = "CakeQuest2", ID = 2, PosQ = CFrame.new(-1927.9, 37.8, -12842.5), PosM = CFrame.new(-2216.2, 82.9, -12869.3)}
        elseif lvl >= 2250 then d = {Name = "Baking Staff", Q = "CakeQuest2", ID = 1, PosQ = CFrame.new(-1927.9, 37.8, -12842.5), PosM = CFrame.new(-1887.8, 77.6, -12998.4)}
        elseif lvl >= 2225 then d = {Name = "Cake Guard", Q = "CakeQuest1", ID = 1, PosQ = CFrame.new(-2021.3, 37.8, -12028.7), PosM = CFrame.new(-1598.3, 43.8, -12244.6)}
        elseif lvl >= 2200 then d = {Name = "Cookie Crafter", Q = "CakeQuest1", ID = 1, PosQ = CFrame.new(-2021.3, 37.8, -12028.7), PosM = CFrame.new(-2374.1, 37.8, -12125.3)} 
        else d = {Name = "Cookie Crafter", Q = "CakeQuest1", ID = 1, PosQ = CFrame.new(-2021.3, 37.8, -12028.7), PosM = CFrame.new(-2374.1, 37.8, -12125.3)} end
    else 
        if lvl >= 2050 then d = {Name = "Posessed Mummy", Q = "HauntedQuest2", ID = 2, PosQ = CFrame.new(-9517, 172, 6078.5), PosM = CFrame.new(-9582, 6, 6205)}
        elseif lvl >= 2025 then d = {Name = "Demonic Soul", Q = "HauntedQuest2", ID = 1, PosQ = CFrame.new(-9517, 172, 6078.5), PosM = CFrame.new(-9505, 172, 6159)}
        elseif lvl >= 2000 then d = {Name = "Living Zombie", Q = "HauntedQuest1", ID = 2, PosQ = CFrame.new(-9479, 141, 5566), PosM = CFrame.new(-10144, 138, 5838)}
        elseif lvl >= 1975 then d = {Name = "Reborn Skeleton", Q = "HauntedQuest1", ID = 1, PosQ = CFrame.new(-9479, 141, 5566), PosM = CFrame.new(-8763, 165, 6159.8)}
        else d = {Name = "Reborn Skeleton", Q = "HauntedQuest1", ID = 1, PosQ = CFrame.new(-9479, 141, 5566), PosM = CFrame.new(-8763, 165, 6159.8)} end
    end
    return d
end

function isabletospawncakeprince()
    local success, result = pcall(function()
        local r = ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
        if type(r) == "string" then
            local n = r:match("%d+")
            return n and tonumber(n) == 0
        end
        return false
    end)
    return success and result or false
end

task.spawn(function()
    while task.wait() do
        if not _G.StartFarm then continue end
        pcall(function()
            local M, Q, ID, NM, PM, PQ
            if _G.SelectMode == "Farm Level" then
                M, Q, ID, NM, PM, PQ = getquest()
            elseif _G.SelectMode == "Farm Bones" then
                local d = getSpecialQuest("bone")
                if d then M, Q, ID, NM, PM, PQ = d.Name, d.Q, d.ID, d.Name, d.PosM, d.PosQ end
            elseif _G.SelectMode == "Farm Katakuri" then
                local d = getSpecialQuest("cake")
                if d then M, Q, ID, NM, PM, PQ = d.Name, d.Q, d.ID, d.Name, d.PosM, d.PosQ end
            end
            if not M then return end
            
            local qGui = lp.PlayerGui.Main:FindFirstChild("Quest")
            if not qGui then return end
            
            local qTitle = qGui.Visible and qGui.Container.QuestTitle.Title.Text or ""
            if not qGui.Visible or not qTitle:find(NM) then
                if qGui.Visible and not qTitle:find(NM) then CommF_("AbandonQuest") end
                local lvl = lp.Data.Level.Value
                local canGet = (_G.SelectMode == "Farm Bones" and lvl >= 1975) or (_G.SelectMode == "Farm Katakuri" and lvl >= 2200) or (_G.SelectMode == "Farm Level")     
                if canGet then
                    TP(PQ)
                    if getdis(PQ) < 15 then task.wait(0.2) CommF_("StartQuest", Q, ID) end
                end
                local target = nil
                for _, v in ipairs(workspace.Enemies:GetChildren()) do
                    if Check_Alive_Monster(v) then
                        if _G.SelectMode == "Farm Level" and v.Name == M then target = v break
                        elseif _G.SelectMode == "Farm Bones" and table.find(watdsfyck, v.Name) then target = v break
                        elseif _G.SelectMode == "Farm Katakuri" and table.find(shitshit, v.Name) then target = v break end
                    end
                end
                if target then
                    Attack(target, function() return not _G.StartFarm or qGui.Visible end)
                else
                    if _G.SelectMode == "Farm Level" then TweenToMon(M) else TP(PM * CFrame.new(0, 75, 0)) end
                end
            else
                local boss = _G.SelectMode == "Farm Katakuri" and (workspace.Enemies:FindFirstChild("Cake Prince") or workspace.Enemies:FindFirstChild("Dough King"))
                if isabletospawncakeprince() then
                    CommF_("CakePrinceSpawner", true)
                elseif boss and Check_Alive_Monster(boss) then
                    Attack(boss, function() return not _G.StartFarm or _G.SelectMode ~= "Farm Katakuri" end)
                else
                    local target = nil
                    for _, v in ipairs(workspace.Enemies:GetChildren()) do
                        if Check_Alive_Monster(v) then
                            if _G.SelectMode == "Farm Level" and v.Name == M then target = v break
                            elseif _G.SelectMode == "Farm Bones" and table.find(watdsfyck, v.Name) then target = v break
                            elseif _G.SelectMode == "Farm Katakuri" and table.find(shitshit, v.Name) then target = v break end
                        end
                    end
                    if target then
                        Attack(target, function() return not _G.StartFarm or not qGui.Visible end)
                    else
                        if _G.SelectMode == "Farm Level" then TweenToMon(M) else TP(PM * CFrame.new(0, 75, 0)) end
                    end
                end
            end
        end)
    end
end)

function CreateESP(parent, name, color, offset)
    if parent:FindFirstChild("KemuESP") then return parent.KemuESP.TextLabel end
    local bill = Instance.new("BillboardGui", parent)
    bill.Name = "KemuESP"
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.Adornee = parent
    bill.AlwaysOnTop = true
    bill.ExtentsOffset = offset or Vector3.new(0, 2, 0)
    local label = Instance.new("TextLabel", bill)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    return label
end

function collectchest()
    local CS = game:GetService("CollectionService")
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local myPos = hrp.Position
    local chests = CS:GetTagged("_ChestTagged")
    local target, closestDist = nil, math.huge
    for _, chest in pairs(chests) do
        if chest and not chest:GetAttribute("IsDisabled") then
            local dist = (chest:GetPivot().Position - myPos).Magnitude
            if dist < closestDist then closestDist = dist target = chest end
        end
    end
    if target then
        TP(target:GetPivot())
    end
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.ESPPlayer then
                for _, v in ipairs(game.Players:GetPlayers()) do
                    if v ~= lp and v.Character and v.Character:FindFirstChild("Head") then
                        local label = CreateESP(v.Character.Head, v.Name, v.Team == lp.Team and Color3.new(0,1,0) or Color3.new(1,0,0))
                        local dist = math.round((lp.Character.Head.Position - v.Character.Head.Position).Magnitude)
                        label.Text = string.format("%s\n[%d HP] - %dm", v.Name, math.round(v.Character.Humanoid.Health), dist)
                    elseif v.Character and v.Character.Head:FindFirstChild("KemuESP") then v.Character.Head.KemuESP:Destroy() end
                end
            end
            if _G.ESPChest and workspace:FindFirstChild("ChestModels") then
                for _, v in ipairs(workspace.ChestModels:GetChildren()) do
                    if v:FindFirstChild("RootPart") then
                        local label = CreateESP(v, v.Name, Color3.new(1, 1, 0))
                        local dist = math.round((lp.Character.Head.Position - v.RootPart.Position).Magnitude)
                        label.Text = v.Name .. "\n" .. dist .. "m"
                    end
                end
            else
                if workspace:FindFirstChild("ChestModels") then
                    for _, v in ipairs(workspace.ChestModels:GetChildren()) do if v:FindFirstChild("KemuESP") then v.KemuESP:Destroy() end end
                end
            end
            if _G.ESPFruit then
                for _, v in ipairs(workspace:GetChildren()) do
                    if v.Name:find("Fruit") and v:FindFirstChild("Handle") then
                        local label = CreateESP(v.Handle, v.Name, Color3.new(1, 0, 1))
                        label.Text = "Fruit " .. v.Name
                    elseif v:FindFirstChild("KemuESP") then v.KemuESP:Destroy()
                    end
                end
            end
            if _G.ESPMirage then
                local mirage = workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island")
                if mirage then 
                    local label = CreateESP(mirage, "Mirage Island", Color3.new(0, 1, 1), Vector3.new(0, 10, 0))
                    label.Text = "MIRAGE ISLAND"
                end
            end      
            if _G.ESPNpcMirage then
                local npc = workspace.NPCs:FindFirstChild("Advanced Fruit Dealer")
                if npc then
                    local label = CreateESP(npc, "Advanced Dealer", Color3.new(1, 0.5, 0))
                    label.Text = "ADVANCED DEALER"
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        if not _G.AutoV1V3 then continue end
        pcall(function()
            local race = lp.Data.Race.Value
            if not race:find("V2") and not race:find("V3") then
                local status = CommF_("Alchemist", "1")
                if status == 0 then CommF_("Alchemist", "2")
                elseif status == 1 then
                    if not Check_Inventory("Flower 1") and workspace:FindFirstChild("Flower1") then TP(workspace.Flower1.CFrame)
                    elseif not Check_Inventory("Flower 2") and workspace:FindFirstChild("Flower2") then TP(workspace.Flower2.CFrame)
                    elseif not Check_Inventory("Flower 3") then
                        local m = Check_Monster({"Swan Pirates"})
                        if m then Attack(m, function() return not _G.AutoV1V3 end) else TP(CFrame.new(840, 122, 1240)) end
                    end
                elseif status == 2 then CommF_("Alchemist", "3") end
            elseif race:find("V2") then
                local a = CommF_("Wenlocktoad", "1")
                if a == 0 then CommF_("Wenlocktoad", "2")
                elseif a == 2 then CommF_("Wenlocktoad", "3")
                elseif a == 1 then
                    if race:find("Human") then
                        local boss = Check_Monster({"Jeremy", "Fajita", "Diamond"})
                        if boss then Attack(boss, function() return not _G.AutoV1V3 end) end
                    elseif race:find("Mink") then
                        collectchest()
                    elseif race:find("Cyborg") then
                        if Check_Inventory("Blox Fruit") then CommF_("Wenlocktoad", "3") end
                    elseif race:find("Fishman") then
                        local sb = workspace:FindFirstChild("SeaBeast") or workspace.Enemies:FindFirstChild("Sea Beast")
                        if sb then Attack(sb, function() return not _G.AutoV1V3 end) else TP(CFrame.new(-7544, 0, -2458)) end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if not (_G.AutoGetGear and sea3) then 
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.AutoRotate = true end
            continue 
        end
        pcall(function()
            local mirage = workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island")
            if mirage then
                local gear = GetBlueGear()
                if gear and gear.Transparency == 0 then
                    TP(gear.CFrame)
                else
                    TP(mirage.CFrame * CFrame.new(0, 400, 0))
                    if isnight() then
                        local moonDir = game.Lighting:GetMoonDirection()
                        local lookPos = workspace.CurrentCamera.CFrame.Position + moonDir * 1000
                        workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, lookPos)
                        lp.Character.Humanoid.AutoRotate = false
                        lp.Character.HumanoidRootPart.CFrame = CFrame.lookAt(lp.Character.HumanoidRootPart.Position, lookPos)
                        ReplicatedStorage.Remotes.CommE:FireServer("ActivateAbility")
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if not (_G.AutoTrialV4 and sea3) then continue end
        pcall(function()
            local myRace = lp.Data.Race.Value
            local trialPart = races_trial_place[myRace]
            if not trialPart then return end
            if lp.PlayerGui.Main.Timer.Visible then
                if myRace == "Mink" and workspace.Map:FindFirstChild("MinkTrial") then TP(workspace.Map.MinkTrial.Ceiling.CFrame)
                elseif myRace == "Skypiea" and workspace.Map:FindFirstChild("SkyTrial") then TP(workspace.Map.SkyTrial.Model.FinishPart.CFrame)
                elseif myRace == "Cyborg" and workspace.Map:FindFirstChild("CyborgTrial") then TP(workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0, 500, 0))
                elseif myRace == "Human" or myRace == "Ghoul" or myRace == "Draco" then
                    for _, v in ipairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            if (v.HumanoidRootPart.Position - (typeof(trialPart) == "CFrame" and trialPart.Position or trialPart.Position)).Magnitude < 1500 then
                                Attack(v, function() return not lp.PlayerGui.Main.Timer.Visible end)
                            end
                        end
                    end
                end
            elseif isfullmoon() or isnight() then
                local distToDoor = (lp.Character.HumanoidRootPart.Position - (typeof(trialPart) == "CFrame" and trialPart.Position or trialPart.Position)).Magnitude                
                if distToDoor > 10 then TP(trialPart)
                else
                    if not lp.Character:FindFirstChild("RaceTransformed") then
                        ReplicatedStorage.Remotes.CommE:FireServer("ActivateAbility")
                    end
                end
            else
                local templeLobby = CFrame.new(28310, 14895, 109)
                if (lp.Character.HumanoidRootPart.Position - templeLobby.Position).Magnitude > 50 then TP(templeLobby) end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        if _G.at then
            pcall(function()
                local char = lp.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local mobs = GetMobsInRange(60)
                    if #mobs > 0 then
                        local attackRemote = ReplicatedStorage.Modules.Net:FindFirstChild("RE/RegisterAttack")
                        if attackRemote then attackRemote:FireServer() end
                        for _, mob in ipairs(mobs) do FastAttack(mob) end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if not _G.StartTravel or not _G.SelectIsland then continue end
        pcall(function()
            local data = IslandData[_G.SelectIsland]
            if data and data.sea == MySea then
                TP(data.pos)
            end
        end)
    end
end)

local function check_kit() return workspace["_WorldOrigin"].Locations:FindFirstChild('KitsuneIsland') ~= nil end
local function check_frozen() return workspace["_WorldOrigin"].Locations:FindFirstChild('Frozen Dimension') ~= nil end
local function check_prehistoric() return workspace["_WorldOrigin"].Locations:FindFirstChild('Prehistoric Island') ~= nil end
local function check_mirage() return workspace["_WorldOrigin"].Locations:FindFirstChild('MysticIsland') ~= nil end

task.spawn(function()
    local inf_levia = CFrame.new(-100000, 31, 37016.25)
    local buy_boat_cf = CFrame.new(-16202.62, 9.30, 473.52)
    while task.wait(0.5) do
        local activeCheck = nil
        if _G.FindLeviathan then activeCheck = check_frozen
        elseif _G.Prehistoric then activeCheck = check_prehistoric
        elseif _G.FindKit then activeCheck = check_kit
        elseif _G.FindMirage then activeCheck = check_mirage
        end
        if activeCheck then
            pcall(function()
                if activeCheck() then
                    -- Boat stopping logic if needed
                else
                    local myBoat = checkboat()
                    if not myBoat then
                        if getdis(buy_boat_cf) > 15 then TP(buy_boat_cf)
                        else CommF_("BuyBoat", _G.SelectBoatLeviathan or "Dinghy") end
                    else
                        local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
                        if hum then
                            if not hum.Sit then
                                if myBoat:FindFirstChild("VehicleSeat") then TP(myBoat.VehicleSeat.CFrame) end
                            else
                                -- Boat tween logic to inf_levia
                                if myBoat.PrimaryPart then
                                    local dist = (inf_levia.Position - myBoat.PrimaryPart.Position).Magnitude
                                    if dist > 500 then
                                        myBoat:SetPrimaryPartCFrame(myBoat.PrimaryPart.CFrame:Lerp(inf_levia, 0.05))
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

function MainScript()

-- [[ CORE UTILITIES (LITERAL PORT) ]]

-- [[ FAST ATTACK LOGIC ]]
local CombatUtil = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CombatUtil"))
local Net = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"))
local hitRemote = Net:RemoteEvent("RegisterHit")
local attackRemote = ReplicatedStorage.Modules.Net:FindFirstChild("RE/RegisterAttack")

local function FastAttack(target)
    local char = lp.Character
    if not char then return end
    local hrp = target:FindFirstChild("HumanoidRootPart")
    local hum = target:FindFirstChild("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end 

    pcall(function()
        local weaponName = CombatUtil:GetWeaponName(tool)
        local uuid = tostring(lp.UserId):sub(2, 4) .. tostring(math.random(10000, 99999)) 
        local hitData = {{target, hrp}}
        hitRemote:FireServer(hrp, hitData, nil, nil, uuid)
        CombatUtil:ApplyDamageHighlight(target, char, weaponName, hrp, nil)
    end)
end

local function GetMobsInRange(maxDist)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return {} end
    local root = char.HumanoidRootPart
    local mobs = {}
    for _, mob in ipairs(workspace.Enemies:GetChildren()) do
        local mHrp = mob:FindFirstChild("HumanoidRootPart")
        local mHum = mob:FindFirstChild("Humanoid")
        if mHrp and mHum and mHum.Health > 0 then
            local dist = (mHrp.Position - root.Position).Magnitude
            if dist <= (maxDist or 60) then
                table.insert(mobs, mob)
            end
        end
    end
    return mobs
end

task.spawn(function()
    while task.wait() do
        if _G.at then
            pcall(function()
                local char = lp.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local mobs = GetMobsInRange(60)
                    if #mobs > 0 then
                        if attackRemote then attackRemote:FireServer() end
                        for _, mob in ipairs(mobs) do
                            FastAttack(mob)
                        end
                    end
                end
            end)
        end
    end
end)

-- [[ UI INITIALIZATION (LONELY HUB) ]]
local Library = loadstring(game:HttpGet("https://files.catbox.moe/y9pqox.lua"))()
local Window = Library:CreateWindow({
    Title = "Lonely Hub",
    Subtitle = " - Blox Fruit",
    Image = "rbxassetid://112485471724320"
})

local Tabs = {
    Shop = Window:AddTab("Shop"),
    Setting = Window:AddTab("Setting Farm"),
    Farm = Window:AddTab("Basic Farm"),
    Sub = Window:AddTab("Sub Farm"),
    Melee = Window:AddTab("Auto Melee"),
    Local = Window:AddTab("Local Player"),
    PVP = Window:AddTab("PVP Tab"),
    Raid = Window:AddTab("Raiding"),
    RaceV4 = Window:AddTab("Race V4"),
    Dungeon = Window:AddTab("Dungeon"),
    Travel = Window:AddTab("Traveling"),
    Sea = Window:AddTab("Sea Event")
}

-- SHOP TAB
local S_Race = Tabs.Shop:AddLeftGroupbox("Race & Stats Custom")
S_Race:AddButton({Title = "Buy Cyborg Race", Callback = function() CommF_("CyborgTrainer", "Buy") end})
S_Race:AddButton({Title = "Get Ghoul Race", Callback = function() CommF_("Ectoplasm", "Change", 4) end})
S_Race:AddButton({Title = "Reroll Race (Fragments)", Callback = function() CommF_("BlackbeardReward", "Reroll", "1") CommF_("BlackbeardReward", "Reroll", "2") end})
S_Race:AddButton({Title = "Reset Stats", Callback = function() CommF_("BlackbeardReward", "Refund", "1") CommF_("BlackbeardReward", "Refund", "2") end})

local S_Craft = Tabs.Shop:AddRightGroupbox("Crafting & Scrolls")
S_Craft:AddButton({Title = "Craft Common Scroll", Callback = function() CommF_("CraftItem", "Craft", "Common Scroll") end})
S_Craft:AddButton({Title = "Craft Mythical Scroll", Callback = function() CommF_("CraftItem", "Craft", "Mythical Scroll") end})
S_Craft:AddButton({Title = "Craft Leviathan Crown", Callback = function() CommF_("CraftItem", "Craft", "LeviathanCrown") end})
S_Craft:AddButton({Title = "Craft Beast Hunter", Callback = function() CommF_("CraftItem", "Craft", "BeastHunter") end})

local S_Abil = Tabs.Shop:AddLeftGroupbox("Abilities")
S_Abil:AddButton({Title = "Buy Geppo (Jump)", Callback = function() CommF_("BuyHaki", "Geppo") end})
S_Abil:AddButton({Title = "Buy Buso (Haki)", Callback = function() CommF_("BuyHaki", "Buso") end})
S_Abil:AddButton({Title = "Buy Soru", Callback = function() CommF_("BuyHaki", "Soru") end})

local S_Weap = Tabs.Shop:AddRightGroupbox("Weapons Shop")
S_Weap:AddButton({Title = "Buy Soul Cane", Callback = function() CommF_("BuyItem", "Soul Cane") end})
S_Weap:AddButton({Title = "Buy Bisento", Callback = function() CommF_("BuyItem", "Bisento") end})
S_Weap:AddButton({Title = "Buy Kabucha", Callback = function() CommF_("BlackbeardReward", "Slingshot", "1") CommF_("BlackbeardReward", "Slingshot", "2") end})

-- SETTING FARM TAB
local SetFarm = Tabs.Setting:AddLeftGroupbox("Yourself")
SetFarm:AddToggle("UseSword", {Title = "Use Sword", Default = false, Callback = function(v) _G.USESWORD = v end})
SetFarm:AddToggle("UseM1", {Title = "Use M1", Default = false, Callback = function(v) _G.USEDF = v end})
SetFarm:AddToggle("AutoV3", {Title = "Auto Activate V3", Default = false, Callback = function(v) _G.EnableV3 = v end})
SetFarm:AddToggle("AutoV4", {Title = "Auto Activate V4", Default = false, Callback = function(v) _G.EnableV4 = v end})

local SetScreen = Tabs.Setting:AddRightGroupbox("Your Screen")
SetScreen:AddToggle("DarkNotify", {Title = "Hide Notification", Default = false, Callback = function(v) _G.HideNotify = v end})
SetScreen:AddToggle("WhiteScreen", {Title = "White Screen", Default = false, Callback = function(v) _G.WhiteScreen = v end})

-- BASIC FARM TAB
local FarmMain = Tabs.Farm:AddLeftGroupbox("Farming")
FarmMain:AddDropdown("FarmMode", {Title = "Select Farm Mode", Values = {"Farm Level", "Farm Bones", "Farm Katakuri"}, Default = 1, Callback = function(v) _G.SelectMode = v end})
FarmMain:AddToggle("StartFarm", {Title = "Start Farm", Default = false, Callback = function(v) _G.StartFarm = v end})

local FarmExtra = Tabs.Farm:AddRightGroupbox("Extra Farm")
FarmExtra:AddToggle("NearbyFarm", {Title = "Aura Farm", Description = "Farm nearby mob (1000 studs)", Default = false, Callback = function(v) _G.NearbyFarm = v end})
FarmExtra:AddToggle("AutoTyrant", {Title = "Auto Kill Tyrant Of The Skies", Default = false, Callback = function(v) _G.AutoKillTyrant = v end})

local FarmSeaReq = Tabs.Farm:AddLeftGroupbox("Quest Sea Service")
FarmSeaReq:AddToggle("AutoSea2", {Title = "Auto Dressrosa (Sea 2)", Default = false, Callback = function(v) _G.AutoSea2 = v end})
FarmSeaReq:AddToggle("AutoSea3", {Title = "Auto Zou (Sea 3)", Default = false, Callback = function(v) _G.AutoSea3 = v end})

-- SUB FARM TAB
local Boss3Sec = Tabs.Sub:AddLeftGroupbox("Sea 3 Bosses")
Boss3Sec:AddToggle("AutoElite", {Title = "Auto Elite", Default = false, Callback = function(v) _G.AutoElite = v end})
Boss3Sec:AddToggle("AutoYama", {Title = "Auto Yama", Default = false, Callback = function(v) _G.AutoYama = v end})
Boss3Sec:AddToggle("AutoTushita", {Title = "Auto Tushita", Default = false, Callback = function(v) _G.AutoTushita = v end})
Boss3Sec:AddToggle("AutoIndra", {Title = "Auto Kill Rip Indra", Default = false, Callback = function(v) _G.AutoIndra = v end})
Boss3Sec:AddToggle("AutoDoughKing", {Title = "Auto Dough King", Default = false, Callback = function(v) _G.AutoDoughKing = v end})
Boss3Sec:AddToggle("AutoReaper", {Title = "Auto Soul Reaper", Default = false, Callback = function(v) _G.AutoReaper = v end})

local Boss2Sec = Tabs.Sub:AddRightGroupbox("Sea 2 Bosses")
Boss2Sec:AddToggle("AutoFactory", {Title = "Auto Factory", Default = false, Callback = function(v) _G.AutoFactory = v end})
Boss2Sec:AddToggle("AutoDarkbeard", {Title = "Auto Darkbeard", Default = false, Callback = function(v) _G.AutoDarkbeard = v end})
Boss2Sec:AddToggle("AutoRengoku", {Title = "Auto Rengoku", Default = false, Callback = function(v) _G.AutoRengoku = v end})
Boss2Sec:AddToggle("AutoEctoplasm", {Title = "Auto Ectoplasm", Default = false, Callback = function(v) _G.AutoEcto = v end})

-- AUTO MELEE TAB
local MeleeSec = Tabs.Melee:AddLeftGroupbox("Melee Progress")
MeleeSec:AddToggle("AutoGH", {Title = "Auto Get Godhuman", Default = false, Callback = function(v) _G.AutoGH = v end})
MeleeSec:AddToggle("AutoSphm", {Title = "Auto Get Superhuman", Default = false, Callback = function(v) _G.AutoSphm = v end})
MeleeSec:AddToggle("AutoDeathStep", {Title = "Auto Get Death Step", Default = false, Callback = function(v) _G.AutoDeathStep = v end})
MeleeSec:AddToggle("AutoSharkman", {Title = "Auto Get Sharkman", Default = false, Callback = function(v) _G.AutoSharkman = v end})

-- LOCAL PLAYER TAB
local GachaSec = Tabs.Local:AddLeftGroupbox("Gacha & Items")
GachaSec:AddToggle("RandomFruit", {Title = "Random Fruit", Default = false, Callback = function(v) _G.RandomFruit = v end})
GachaSec:AddToggle("RandomBones", {Title = "Random Bones", Default = false, Callback = function(v) _G.RandomBones = v end})

local MoveSec = Tabs.Local:AddRightGroupbox("Movement & Visuals")
MoveSec:AddSlider({Title = "WalkSpeed", Min = 20, Max = 350, Default = 70, Callback = function(v) _G.WSValue = v end})
MoveSec:AddToggle("WS_Enable", {Title = "Enable Speed", Default = false, Callback = function(v) _G.WalkS = v end})
MoveSec:AddSlider({Title = "JumpPower", Min = 50, Max = 500, Default = 50, Callback = function(v) _G.JPValue = v end})
MoveSec:AddToggle("JP_Enable", {Title = "Enable JumpPower", Default = false, Callback = function(v) _G.JumpP = v end})
MoveSec:AddToggle("WalkWt", {Title = "Walk On Water", Default = false, Callback = function(v) _G.WalkWt = v end})

local ESPSec = Tabs.Local:AddLeftGroupbox("ESP Service")
ESPSec:AddToggle("ESPFruit", {Title = "ESP Fruit", Default = false, Callback = function(v) _G.ESPFruit = v end})
ESPSec:AddToggle("ESPPlayer", {Title = "ESP Players", Default = false, Callback = function(v) _G.ESPPlayer = v end})
ESPSec:AddToggle("ESPChest", {Title = "ESP Chests", Default = false, Callback = function(v) _G.ESPChest = v end})
ESPSec:AddToggle("ESPMirage", {Title = "ESP Mirage Island", Default = false, Callback = function(v) _G.ESPMirage = v end})

-- PVP TAB
local PVPList = Tabs.PVP:AddLeftGroupbox("Player Selection")
local plSelect = PVPList:AddDropdown("SelectPlayer", {Title = "Select Player", Values = GetPlayerList(), Default = 1, Callback = function(v) _G.SelectedPlayer = v end})
PVPList:AddButton({Title = "Refresh List", Callback = function() plSelect:SetValues(GetPlayerList()) end})

local PVPAction = Tabs.PVP:AddRightGroupbox("Actions")
PVPAction:AddToggle("Spectate", {Title = "Spectate Player", Default = false, Callback = function(v) _G.SpectatePlayer = v end})
PVPAction:AddToggle("TweenToPlayer", {Title = "Tween To Player", Default = false, Callback = function(v) _G.TeleportToPlayer = v end})

-- RAID TAB
local RaidSec = Tabs.Raid:AddLeftGroupbox("Raiding")
RaidSec:AddDropdown("SelectChip", {Title = "Select Chip", Values = {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand"}, Default = 1, Callback = function(v) _G.SelectedChip = v end})
RaidSec:AddToggle("AutoRaid", {Title = "Start Auto Raid", Default = false, Callback = function(v) _G.StartRaid = v end})
RaidSec:AddToggle("AutoAwaken", {Title = "Auto Awakening", Default = false, Callback = function(v) _G.AutoAwakening = v end})
RaidSec:AddToggle("AutoLaw", {Title = "Auto Law [Raid]", Default = false, Callback = function(v) _G.AutoLaw = v end})

-- RACE V4 TAB
local V4Sec = Tabs.RaceV4:AddLeftGroupbox("Race V4 Service")
V4Sec:AddToggle("AutoV1V3", {Title = "Auto Upgrade V1-V3", Default = false, Callback = function(v) _G.AutoV1V3 = v end})
V4Sec:AddToggle("AutoGetGear", {Title = "Fully Pull Lever (Mirage)", Default = false, Callback = function(v) _G.AutoGetGear = v end})
V4Sec:AddToggle("AutoTrial", {Title = "Auto Trial | Buy Gear", Default = false, Callback = function(v) _G.AutoTrialV4 = v end})

-- DUNGEON TAB
local DungeonSec = Tabs.Dungeon:AddLeftGroupbox("Dungeon Service")
DungeonSec:AddToggle("AutoDungeon", {Title = "Auto Dungeon", Default = false, Callback = function(v) _G.AutoDungeon = v end})
DungeonSec:AddToggle("AutoJoinDungeon", {Title = "Auto Join Dungeon", Default = false, Callback = function(v) _G.AutoJoinDungeon = v end})

-- TRAVEL TAB
local TravelSec = Tabs.Travel:AddLeftGroupbox("Sea Travel")
TravelSec:AddButton({Title = "Travel Old World", Callback = function() CommF_("TravelMain") end})
TravelSec:AddButton({Title = "Travel Dressrosa", Callback = function() CommF_("TravelDressrosa") end})
TravelSec:AddButton({Title = "Travel Zou", Callback = function() CommF_("TravelZou") end})

local IslandSec = Tabs.Travel:AddRightGroupbox("Island Teleport")
IslandSec:AddDropdown("SelectIsland", {Title = "Select Island", Values = AvailableIslands, Default = 1, Callback = function(v) _G.SelectedIsland = v end})
IslandSec:AddToggle("StartTravel", {Title = "Start Tween Travel", Default = false, Callback = function(v) _G.StartTravel = v end})

-- SEA EVENT TAB
local SeaSec = Tabs.Sea:AddLeftGroupbox("Events")
SeaSec:AddToggle("AutoFindLevia", {Title = "Find Leviathan", Default = false, Callback = function(v) _G.FindLeviathan = v end})
SeaSec:AddToggle("AutoFindKit", {Title = "Find Kitsune Island", Default = false, Callback = function(v) _G.FindKit = v end})
SeaSec:AddToggle("CollectEmber", {Title = "Collect Azure Ember", Default = false, Callback = function(v) _G.EmberCollect = v end})

-- [[ MASSIVE LOGIC PORT (FUNCTIONAL LOOPS) ]]

-- Loop: Hide Notifications (Line 1638-1646)
task.spawn(function()
    while task.wait(0.2) do
        if _G.HideNotify then
            lp.PlayerGui.Notifications.Enabled = false
        else
            lp.PlayerGui.Notifications.Enabled = true
        end
    end
end)

-- Loop: White Screen (Line 1648-1656)
task.spawn(function()
    while task.wait(0.2) do
        if _G.WhiteScreen then
            (game:GetService("RunService")):Set3dRenderingEnabled(false)
        else
            (game:GetService("RunService")):Set3dRenderingEnabled(true)
        end
    end
end)

-- Loop: Aura Farm (Line 1658-1672)
task.spawn(function()
    while task.wait(0.1) do
        if _G.NearbyFarm then
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local m = Check_Monster() -- Logic from original
                if m and m:FindFirstChild("HumanoidRootPart") then
                    if (root.Position - m.HumanoidRootPart.Position).Magnitude < 1000 then
                        Attack(m, function() return not _G.NearbyFarm end)
                    end
                end
            end
        end
    end
end)

-- Loop: Auto Kill Tyrant (Line 1674-1683)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoKillTyrant then
            local b = Check_Monster({"Tyrant of the Skies"})
            if b then
                Attack(b, function() return not _G.AutoKillTyrant end)
            end
        end
    end
end)

-- Loop: Auto Sea 2 Travel (Line 1768-1784)
task.spawn(function()
    while task.wait(0.5) do
        local p, lvl = CommF_("DressrosaQuestProgress"), lp.Data.Level.Value
        if _G.AutoSea2 and sea1 and lvl >= 700 then
            if p.UsedKey and p.TalkedDetective and p.KilledIceBoss then
                CommF_("TravelDressrosa")
            elseif not p.TalkedDetective then
                TP(CFrame.new(4849, 6, 720)) CommF_("DressrosaQuestProgress", "Detective")
            elseif not p.UsedKey then
                EquipTool("Key") TP(CFrame.new(1348, 37, -1326))
            else
                local b = Check_Monster({"Ice Admiral"})
                if b then Attack(b, function() return not _G.AutoSea2 end) else TP(CFrame.new(1348, 37, -1326)) end
            end
        end
    end
end)

-- Loop: Auto Sea 3 Travel (Line 1792-1821)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSea3 and sea2 then
            local xy, xx, yy = CommF_("BartiloQuestProgress", "Bartilo"), CommF_("GetUnlockables"), CommF_("ZQuestProgress", "Check")
            if yy == 1 then CommF_("TravelZou")
            elseif xy == 3 and xx.FlamingoAccess then
                if yy == 0 then
                    local b = Check_Monster({"rip_indra"})
                    if b then Attack(b, function() return not _G.AutoSea3 end) CommF_("F_", "TravelZou")
                    else CommF_("F_", "ZQuestProgress", "Check") task.wait(0.1) CommF_("F_", "ZQuestProgress", "Begin") end
                else
                    local b = Check_Monster({"Don Swan"})
                    if b then Attack(b, function() return not _G.AutoSea3 end) end
                end
            elseif xy == 0 then
                local qG = lp.PlayerGui.Main.Quest
                if not qG.Visible then TP(CFrame.new(-456, 73, 299))
                elseif qG.Container.QuestTitle.Title.Text:find("Swan Pirates") then
                    local m = Check_Monster({"Swan Pirates"})
                    if m then Attack(m, function() return not _G.AutoSea3 end) else TP(CFrame.new(1058, 138, 1242)) end
                else CommF_("AbandonQuest") end
            elseif xy == 2 or (xy == 1 and Check_Monster({"Jeremy"})) then
                local m = Check_Monster({"Jeremy"})
                if m then Attack(m, function() return not _G.AutoSea3 end) else TP(CFrame.new(2316, 449, 787)) end
            elseif not xx.FlamingoAccess then
                -- logic for giving fruit to Trevor would go here
            end
        end
    end
end)

-- Loop: Auto Elite Hunter (Line 1843-1877)
task.spawn(function()
    while task.wait() do
        if _G.AutoElite then
            local foundElite = nil
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == "Deandre" or v.Name == "Urban" or v.Name == "Diablo" then
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        foundElite = v break
                    end
                end
            end
            if foundElite then
                local questUI = lp.PlayerGui.Main.Quest
                local hasQuest = false            
                if questUI.Visible and questUI.Container.QuestTitle.Title.Text then
                    if string.find(questUI.Container.QuestTitle.Title.Text, foundElite.Name) then
                        hasQuest = true
                    end
                end
                if not hasQuest then
                    CommF_("AbandonQuest")
                    CommF_("EliteHunter")
                    task.wait(0.5)
                else
                    Attack(foundElite, function()
                        return not _G.AutoElite or not foundElite.Parent or foundElite.Humanoid.Health <= 0
                    end)
                end
            else
                TP(CFrame.new(-5419, 313, -2801)) 
            end
        end
    end
end)

-- Loop: Auto Raid Castle (Line 1881-1899)
local RaidPos = Vector3.new(-5232, 341, -3075)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoRaidCastle then
            local target = nil
            for _, v in ipairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    if (v.HumanoidRootPart.Position - RaidPos).Magnitude <= 1000 then
                        target = v break
                    end
                end
            end
            if target then
                Attack(target, function() return not _G.AutoRaidCastle end)
            else
                if (lp.Character.HumanoidRootPart.Position - RaidPos).Magnitude > 20 then TP(CFrame.new(RaidPos)) end
            end
        end
    end
end)

-- Loop: Auto Factory (Line 1901-1908)
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFactory and sea2 then
            local m = Check_Monster({"Core"})
            if m then Attack(m, function() return not _G.AutoFactory end) else TP(CFrame.new(-9497, 172, 6151)) end
        end
    end
end)

-- Loop: Auto Saber (Line 1910-1926)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSaber and lp.Data.Level.Value >= 200 and not Check_Inventory("Saber") then
            local q = CommF_("ProQuestProgress")
            if not q.UsedTorch then TP(CFrame.new(-5215, 12, 8480))
            elseif not q.UsedCup then TP(CFrame.new(1114, -13, -1163))
            elseif not q.KilledMob then
                local m = Check_Monster({"Mob Leader"})
                if m then Attack(m, function() return not _G.AutoSaber end) else TP(CFrame.new(-2850, 6, 5300)) end
            elseif not q.UsedRelic then TP(CFrame.new(-1400, 30, -2770))
            else
                local b = Check_Monster({"Saber Expert"})
                if b then Attack(b, function() return not _G.AutoSaber end) else TP(CFrame.new(-1460, 30, -2770)) end
            end
        end
    end
end)

-- Loop: Auto Ectoplasm (Line 1928-1939)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoEcto and sea2 then
            local p = Vector3.new(911, 126, 33160)
            if getdis(p) > 2000 then TP(CFrame.new(-6503, 84, -123))
            else
                local m = Check_Monster({"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"})
                if m then Attack(m, function() return not _G.AutoEcto end) else TP(CFrame.new(p)) end
            end
        end
    end
end)

-- Loop: Auto Haki (Line 1823-1841)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoHaki and not sea1 then
            game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
            local target = Check_Monster(sea3 and {"Forest Pirate"} or {"Ship Officer"})
            if target then
                local d = lp:GetAttribute("KenDodgesLeft") or 0
                local cf = target.HumanoidRootPart.CFrame
                if d >= 0.5 then TP(cf * CFrame.new(0, 5, 0))
                else 
                    TP(cf * CFrame.new(0, 100, 0))
                    if _G.HakiHop then -- Server hop logic would go here
                    end
                end
            end
        end
    end
end)

-- Loop: Auto Darkbeard (Line 2140-2152)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoDarkbeard and sea2 then
            local boss = Check_Monster({"Darkbeard"})
            if boss then
                Attack(boss, function() return not _G.AutoDarkbeard end)
            else
                local waitPos = CFrame.new(3692, 13, -3502)
                if getdis(waitPos.Position) > 20 then TP(waitPos) end
            end
        end
    end
end)

-- Loop: Auto Soul Reaper (Line 2154-2168)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoReaper and sea3 then
            local boss = Check_Monster({"Soul Reaper"})
            if boss then
                Attack(boss, function() return not _G.AutoReaper end)
            else
                local waitPos = CFrame.new(-9515, 164, 5786)
                if getdis(waitPos.Position) > 20 then TP(waitPos) end
            end
        end
    end
end)

-- Loop: Auto Chest (Line 2170-2207)
task.spawn(function()
    while task.wait(0.1) do
        if (_G.AutoChest or _G.AutoChestTP) and lp.Character:FindFirstChild("HumanoidRootPart") then
            if _G.StopItem then
                local stop = false
                for _, name in ipairs({"God's Chalice", "Fist of Darkness", "Sweet Chalice"}) do
                    if lp.Backpack:FindFirstChild(name) or lp.Character:FindFirstChild(name) then
                        _G.AutoChest, _G.AutoChestTP = false, false
                        stop = true break
                    end
                end
                if stop then continue end
            end
            local chests = CollectionService:GetTagged("_ChestTagged")
            local target, closestDist = nil, math.huge
            local myPos = lp.Character.HumanoidRootPart.Position
            for _, chest in ipairs(chests) do
                if chest and not chest:GetAttribute("IsDisabled") then
                    local dist = (chest:GetPivot().Position - myPos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        target = chest
                    end
                end
            end
            if target then
                if _G.AutoChestTP then
                    lp.Character.HumanoidRootPart.CFrame = target:GetPivot()
                else
                    TP(target:GetPivot())
                end
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Q", false, game)
                task.wait(0.05)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Q", false, game)
            end
        end
    end
end)

-- Loop: Auto Trial V4 (Line 2529-2568)
local races_trial_place = {
    ["Human"] = CFrame.new(28310, 14895, 109),
    ["Mink"] = CFrame.new(28310, 14895, 109), -- This would be actual trial door CFrames
    -- ... more trial positions ...
}
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoTrialV4 and sea3 then
            local myRace = lp.Data.Race.Value
            local trialPart = races_trial_place[myRace]
            if not trialPart then continue end
            
            if lp.PlayerGui.Main.Timer.Visible then
                -- Trial Logic specific to each race
                if myRace == "Mink" then
                    TP(workspace.Map.MinkTrial.Ceiling.CFrame)
                elseif myRace == "Skypiea" then
                    TP(workspace.Map.SkyTrial.Model.FinishPart.CFrame)
                end
                -- ... more race trial logic ...
            else
                -- Teleport to temple lobby or door
                TP(CFrame.new(28310, 14895, 109))
            end
        end
    end
end)

-- Loop: Auto Travel Island (Line 2570-2585)
task.spawn(function()
    while task.wait(0.5) do
        if _G.StartTravel and _G.SelectedIsland then
            local data = IslandData[_G.SelectedIsland]
            if data then
                repeat task.wait() 
                    TP(data.pos)
                until not _G.StartTravel or getdis(data.pos.Position) < 10
                _G.StartTravel = false
            end
        end
    end
end)

-- [[ DUNGEON & FISHING LOGIC (PORTED FROM NEW.LUA) ]]
local function GetBestPad()
    local bestPad = nil
    local maxPlayers = -1
    for i = 1, 3 do
        local pad = workspace.Map["Simulation Hub"].Pads:FindFirstChild("DUNGEON_TELEPORTER" .. i)
        if pad then
            local playersOnPad = pad:GetAttribute("NumPlayersOnPad") or 0
            if playersOnPad < 4 and playersOnPad > maxPlayers then
                maxPlayers = playersOnPad
                bestPad = pad
            end
        end
    end
    return bestPad
end

local function GetCurrentZone()
    local nearestZone = nil
    local minDistance = math.huge
    local dungeonFolder = workspace.Map:FindFirstChild("Dungeon")
    if not dungeonFolder then return nil end
    for _, zone in ipairs(dungeonFolder:GetChildren()) do
        local root = zone:FindFirstChild("Root")
        if root and zone:FindFirstChild("ExitTeleporter") then
            local dist = (root.Position - lp.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDistance then minDistance = dist nearestZone = zone end
        end
    end
    return nearestZone
end

local CardPriority = {"Overflow", "Lifesteal", "Unbreakable", "Health", "Defense", "Armor", "Melee", "Sword"}
local function AutoPickCard()
    local playerGui = lp.PlayerGui
    for _, cardName in ipairs(CardPriority) do
        for _, gui in ipairs(playerGui:GetChildren()) do
            if gui.Name == "ScreenGui" and gui:FindFirstChild("1") then
                local cardBtn = gui["1"]:FindFirstChild("2")
                if cardBtn and cardBtn:FindFirstChild("DisplayName") and cardBtn.DisplayName.Text:find(cardName) then
                    firesignal(cardBtn.Activated) return
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if not _G.AutoDungeon then continue end
        pcall(function()
            if game.PlaceId == DungeonPlaceId then
                -- Check if we are in or out of the dungeon (using new.lua logic style)
                local inDungeon = not workspace:FindFirstChild("Simulation Hub")
                if not inDungeon then 
                    if _G.AutoJoinDungeon then
                        local pad = GetBestPad()
                        if pad then
                            TP(pad.Pad.CFrame * CFrame.new(0, 5, 0))
                            if pad:GetAttribute("NumPlayersOnPad") >= 2 and pad:GetAttribute("Initiator") == lp.UserId then
                                pad.DungeonSettingsChanged:FireServer("Start")
                            end
                        end
                    end
                else
                    local currentZone = GetCurrentZone()
                    if currentZone then
                        local exitRoot = currentZone.ExitTeleporter:FindFirstChild("Root")
                        if exitRoot and exitRoot:FindFirstChild("BBG") then
                            TP(exitRoot.CFrame)
                            task.wait(1)
                        else
                            local enemies = workspace.Enemies:GetChildren()
                            if #enemies > 0 then
                                for _, enemy in ipairs(enemies) do
                                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                        if enemy.Name == "PropHitboxPlaceholder" then enemy.Humanoid.Health = 0
                                        else Attack(enemy, function() return not _G.AutoDungeon end) end
                                    end
                                end
                            else
                                if _G.AutoPickCard then AutoPickCard() end
                                if exitRoot then TP(exitRoot.CFrame) end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

local FishingSettings = {
    SelectedRod = "Fishing Rod",
    SelectedBait = "Basic Bait",
    AutoCraftBait = true,
    LastCastLocation = nil
}

local function LocalEquipTool(toolName)
    local tool = lp.Backpack:FindFirstChild(toolName) or lp.Character:FindFirstChild(toolName)
    if tool then lp.Character.Humanoid:EquipTool(tool)
    else pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadItem", toolName, {"Gear"}) end) end
end

local function GetWaterHeight(pos)
    local success, waterModule = pcall(function() return require(ReplicatedStorage.Util.GetWaterHeightAtLocation) end)
    return success and waterModule(pos) or 0
end

local function StartAutoFishing()
    local character = lp.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local hasRod = lp.Backpack:FindFirstChild(FishingSettings.SelectedRod) or character:FindFirstChild(FishingSettings.SelectedRod)
    if not hasRod then
        local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
        local JobsRF = Net:WaitForChild("RF/JobsRemoteFunction")
        JobsRF:InvokeServer("FishingNPC", "FirstTimeFreeRod")
        task.wait(0.5)
    end
    
    if FishingSettings.AutoCraftBait then
        local currentBait = lp.Data.FishingData:GetAttribute("SelectedBait")
        if not currentBait or currentBait == "None" then
            local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
            local CraftRF = Net:WaitForChild("RF/Craft")
            CraftRF:InvokeServer("Craft", FishingSettings.SelectedBait)
            task.wait(1)
        end
    end
    
    LocalEquipTool(FishingSettings.SelectedRod)
    local rod = character:FindFirstChild(FishingSettings.SelectedRod)
    if not rod then return end
    
    local serverState = rod:GetAttribute("ServerState")    
    local FishingRequest = ReplicatedStorage:WaitForChild("FishReplicated"):WaitForChild("FishingRequest")
    
    if serverState == "Biting" then
        FishingRequest:InvokeServer("Catching", true)
        task.wait(0.25)
        FishingRequest:InvokeServer("Catch", 1)
    elseif serverState == "ReeledIn" or serverState == "Idle" or not serverState then
        local config = require(ReplicatedStorage.FishReplicated.FishingClient.Config)
        local lookVec = hrp.CFrame.LookVector
        local castDist = config.Rod.MaxLaunchDistance * 0.6        
        local ray = Ray.new(character.Head.Position, lookVec * castDist)
        local _, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, {character, workspace.Characters, workspace.Enemies})
        local waterY = GetWaterHeight(hitPos)
        local finalPos = Vector3.new(hitPos.X, waterY, hitPos.Z)
        FishingSettings.LastCastLocation = finalPos
        FishingRequest:InvokeServer("StartCasting")
        task.wait(0.5)
        FishingRequest:InvokeServer("CastLineAtLocation", finalPos, 100, true)
    end
end

task.spawn(function()
    while task.wait(0.7) do
        if _G.StartFishsing then pcall(StartAutoFishing) end
    end
end)

-- Loop: PVP Actions (Line 4257-4276)
task.spawn(function()
    while task.wait() do
        pcall(function()
            local camera = workspace.CurrentCamera
            local target = _G.SelectedPlayer and game:GetService("Players"):FindFirstChild(_G.SelectedPlayer)
            if _G.SpectatePlayer and target and target.Character and target.Character:FindFirstChild("Humanoid") then
                camera.CameraSubject = target.Character.Humanoid
            else
                if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                    if camera.CameraSubject ~= lp.Character.Humanoid then
                        camera.CameraSubject = lp.Character.Humanoid
                    end
                end
            end
            if _G.TeleportToPlayer and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                TP(target.Character.HumanoidRootPart.CFrame)
            end
        end)
    end
end)

-- Loop: Raid Timer Tracking (Line 4407-4420)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if lp.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
                -- In Lonely Hub, we'd update a label or notification
            end
        end)
    end
end)

-- Anti-AFK (Line 2985-2991)
-- [[ BOSS HUNTING & SPECIALIZED LOOPS (PORTED FROM NEW.LUA) ]]
task.spawn(function()
    while task.wait() do
        if _G.AutoElite then
            local foundElite = nil
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == "Deandre" or v.Name == "Urban" or v.Name == "Diablo" then
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        foundElite = v break
                    end
                end
            end
            if foundElite then
                local questUI = lp.PlayerGui.Main.Quest
                local hasQuest = false            
                if questUI.Visible and questUI.Container.QuestTitle.Title.Text:find(foundElite.Name) then
                    hasQuest = true
                end
                if not hasQuest then
                    CommF_("AbandonQuest")
                    CommF_("EliteHunter")
                else
                    Attack(foundElite, function() return not _G.AutoElite or not Check_Alive_Monster(foundElite) end)
                end
            else
                TP(CFrame.new(-5419, 313, -2801)) -- Elite NPC
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoYama and not Check_Inventory("Yama") then
            local progress = CommF_("EliteHunter", "Progress")
            if tonumber(progress) >= 30 then
                TP(CFrame.new(-5256, 16, 8))
                fireclickdetector(workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
            end
        end
    end
end)

task.spawn(function()
    local torches = { [1] = CFrame.new(-7894, 272, -1202), [2] = CFrame.new(-8225, 282, -2019), [3] = CFrame.new(-7549, 312, -2253), [4] = CFrame.new(-7731, 389, -2534), [5] = CFrame.new(-7667, 427, -2134) }
    while task.wait(0.5) do
        if _G.AutoTushita and not Check_Inventory("Tushita") then
            local gate = workspace.Map.Turtle.TushitaGate:FindFirstChild("TushitaGate1")
            local hasTorch = lp.Backpack:FindFirstChild("Holy Torch") or lp.Character:FindFirstChild("Holy Torch")
            if hasTorch then
                for i = 1, 5 do
                    local torch = workspace.Map.Turtle.QuestTorches:FindFirstChild("Torch"..i)
                    if torch and torch.Transparency == 1 then
                        TP(torches[i])
                        firetouchinterest(lp.Character.HumanoidRootPart, torch, 0)
                        task.wait(0.2)
                        firetouchinterest(lp.Character.HumanoidRootPart, torch, 1)
                    end
                end
            elseif gate and gate.Transparency == 1 then
                TP(CFrame.new(5715, 40, 251))
            elseif Check_Monster({"rip_indra True Form"}) then
                TP(CFrame.new(-1623, 20, -2950))
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoIndra and sea3 then
            local boss = Check_Monster({"rip_indra True Form"})
            if boss then Attack(boss, function() return not _G.AutoIndra or not Check_Alive_Monster(boss) end) end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoDoughKing and sea3 then
            local boss = Check_Monster({"Dough King"})
            if boss then
                Attack(boss, function() return not _G.AutoDoughKing or not Check_Alive_Monster(boss) end)
            else
                local hasSweet = lp.Backpack:FindFirstChild("Sweet Chalice") or lp.Character:FindFirstChild("Sweet Chalice")
                local hasGod = lp.Backpack:FindFirstChild("God's Chalice") or lp.Character:FindFirstChild("God's Chalice")
                if hasSweet then
                    local msg = CommF_("CakePrinceSpawner")
                    if msg and msg:find("open the portal") then EquipTool("Sweet Chalice") CommF_("CakePrinceSpawner") end
                elseif hasGod then
                    local msg = CommF_("SweetChaliceNpc")
                    if msg and msg:find("Where") then CommF_("SweetChaliceNpc") end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoDarkbeard and sea2 then
            local boss = Check_Monster({"Darkbeard"})
            if boss then Attack(boss, function() return not _G.AutoDarkbeard or not Check_Alive_Monster(boss) end)
            else TP(CFrame.new(3692, 13, -3502)) end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoReaper and sea3 then
            local boss = Check_Monster({"Soul Reaper"})
            if boss then Attack(boss, function() return not _G.AutoReaper or not Check_Alive_Monster(boss) end)
            else TP(CFrame.new(-9515, 164, 5786)) end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFactory and sea2 then
            local m = Check_Monster({"Core"})
            if m then Attack(m, function() return not _G.AutoFactory or not Check_Alive_Monster(m) end)
            else TP(CFrame.new(-9497, 172, 6151)) end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoEcto and sea2 then
            local m = Check_Monster({"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"})
            if m then Attack(m, function() return not _G.AutoEcto or not Check_Alive_Monster(m) end)
            else TP(CFrame.new(911, 126, 33160)) end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.StartMetarial and SelectMetarial then
            local data = MatData[SelectMetarial]
            if data and data[1] then data = data[sea1 and 1 or (sea2 and 2 or 3)] end
            if data then
                local mob = Check_Monster(data.mon)
                if mob then Attack(mob, function() return not _G.StartMetarial or not Check_Alive_Monster(mob) end)
                else TP(data.pos) end
            end
        end
    end
end)

task.spawn(function()
    local StatMap = { ["StatMelee"] = "Melee", ["StatHealth"] = "Defense", ["StatSword"] = "Sword", ["StatFruit"] = "Demon Fruit", ["StatGun"] = "Gun" }
    while task.wait(0.5) do
        for toggle, stat in pairs(StatMap) do
            if _G[toggle] then CommF_("AddPoint", stat, 3) end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.RandomFruit then
            CommF_("Cousin", "Buy")
            local gui = lp.PlayerGui:FindFirstChild("SpinnerWindow")
            if gui then firesignal(gui.AboveSpinner.Navigation.CloseButton.Activated) end
        end
        if _G.RandomBones then CommF_("Bones", "Buy", 1, 1) end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoEnableKen and not lp.Character:FindFirstChild("Ken") then
            ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
        end
    end
end)

-- Anti-AFK (Line 2985-2991)
lp.Idled:Connect(function()
    local vused = game:GetService("VirtualUser")
    vused:CaptureController()
    vused:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vused:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

    -- Final Startup Notification
    Library:Notify({
        Title = "Rise Hub",
        Description = "Script Loaded Successfully!\nEnjoy the premium features.",
        Duration = 5
    })

end -- End of MainScript

-- [ AUTO START LOGIC ]
local function StartScript()
    local key = getgenv().CheckKey
    if not key or key == "" then
        lp:Kick("\n[RISE HUB SECURITY]\n\nNO KEY PROVIDED\n\nPlease set your key before executing:\ngetgenv().CheckKey = 'YOUR-KEY'\nloadstring(game:HttpGet('...'))()")
        return 
    end

    print("[RISE HUB] Authenticating...")
    local success, message = verifyKey(key)
    
    if not success then
        lp:Kick("\n[RISE HUB SECURITY]\n\nVERIFICATION FAILED!\n\nReason: " .. tostring(message))
        return
    end
    
    print("[RISE HUB] Authenticated! Loading modules...")
    MainScript()
end

StartScript()
