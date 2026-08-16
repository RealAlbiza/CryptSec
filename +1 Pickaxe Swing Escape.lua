-- [[ SERVICES ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- [[ OBSIDIAN UI LIBRARY ]]
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "CryptSec",
    Footer = "+1 Pickaxe Swing Escape",
    Icon = 121626436575118,
    NotifySide = "Right",
    ShowCustomCursor = false
})

local Tabs = {
    Autofarm        = Window:AddTab("Autofarm", "zap"),
    Shop            = Window:AddTab("Shop", "shopping-cart"),
    Teleport        = Window:AddTab("Teleport", "map"),
    Training        = Window:AddTab("Training", "swords"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local connections = {}

-- [[ WORLD DATA ]]
local WORLDS = {
    [1] = {
        start  = Vector3.new(-5.431, 5.471, 176.500),
        stages = {
            { label = "Stage 1",  pos = Vector3.new(92.195,  5.501, 161.343) },
            { label = "Stage 2",  pos = Vector3.new(163.195, 5.501, 161.347) },
            { label = "Stage 3",  pos = Vector3.new(238.195, 5.501, 161.347) },
            { label = "Stage 4",  pos = Vector3.new(313.112, 5.501, 161.347) },
            { label = "Stage 5",  pos = Vector3.new(399.112, 5.501, 161.347) },
            { label = "Stage 6",  pos = Vector3.new(493.112, 5.501, 161.347) },
            { label = "Stage 7",  pos = Vector3.new(591.112, 5.501, 161.347) },
            { label = "Stage 8",  pos = Vector3.new(690.112, 5.501, 162.347) },
            { label = "Stage 9",  pos = Vector3.new(805.112, 5.501, 162.347) },
            { label = "Stage 10", pos = Vector3.new(929.112, 5.501, 162.347) },
            { label = "Stage 11", pos = Vector3.new(1060.112, 5.501, 162.347) },
            { label = "Stage 12", pos = Vector3.new(1207.537, 5.501, 162.347) },
        },
    },
    [2] = {
        start  = Vector3.new(-5.431, 5.443, 510.045),
        stages = {
            { label = "Stage 1",  pos = Vector3.new(119.386, 5.472, 489.515) },
            { label = "Stage 2",  pos = Vector3.new(218.386, 5.472, 489.515) },
            { label = "Stage 3",  pos = Vector3.new(321.386, 5.472, 489.515) },
            { label = "Stage 4",  pos = Vector3.new(439.386, 5.472, 489.515) },
            { label = "Stage 5",  pos = Vector3.new(561.386, 5.472, 489.515) },
            { label = "Stage 6",  pos = Vector3.new(687.386, 5.472, 489.515) },
            { label = "Stage 7",  pos = Vector3.new(824.386, 5.472, 489.515) },
            { label = "Stage 8",  pos = Vector3.new(969.386, 5.472, 489.515) },
            { label = "Stage 9",  pos = Vector3.new(1115.386, 5.472, 489.515) },
            { label = "Stage 10", pos = Vector3.new(1282.386, 5.472, 489.515) },
            { label = "Stage 11", pos = Vector3.new(1471.890, 5.472, 489.515) },
        },
    },
    [3] = {
        start  = Vector3.new(-5.431, 5.443, 868.045),
        stages = {
            { label = "Stage 1", pos = Vector3.new(119.386, 5.472, 847.515) },
            { label = "Stage 2", pos = Vector3.new(218.386, 5.472, 847.515) },
            { label = "Stage 3", pos = Vector3.new(321.386, 5.472, 847.515) },
            { label = "Stage 4", pos = Vector3.new(439.386, 5.472, 847.515) },
            { label = "Stage 5", pos = Vector3.new(561.386, 5.472, 847.515) },
            { label = "Stage 6", pos = Vector3.new(687.386, 5.472, 847.515) },
            { label = "Stage 7", pos = Vector3.new(818.845, 5.471, 847.514) },
            { label = "Stage 8", pos = Vector3.new(976.233, 5.471, 847.514) },
            { label = "Stage 9", pos = Vector3.new(1146.200, 5.471, 847.514) },
            { label = "Stage 10", pos = Vector3.new(1335.200, 5.471, 847.514) },
            { label = "Stage 11", pos = Vector3.new(1548.200, 5.471, 847.514) },
            { label = "Stage 12", pos = Vector3.new(1769.200, 5.471, 847.514) },
        },
    },
    [4] = {
        start  = Vector3.new(-5.431, 5.443, 1221.015),
        stages = {
            { label = "Stage 1",  pos = Vector3.new(119.386, 5.472, 1221.015) },
            { label = "Stage 2",  pos = Vector3.new(218.386, 5.472, 1221.015) },
            { label = "Stage 3",  pos = Vector3.new(321.386, 5.472, 1221.015) },
            { label = "Stage 4",  pos = Vector3.new(439.386, 5.472, 1221.015) },
            { label = "Stage 5",  pos = Vector3.new(561.386, 5.472, 1221.015) },
            { label = "Stage 6",  pos = Vector3.new(687.386, 5.472, 1221.015) },
            { label = "Stage 7",  pos = Vector3.new(818.845, 5.472, 1221.015) },
            { label = "Stage 8",  pos = Vector3.new(976.233, 5.472, 1221.015) },
            { label = "Stage 9",  pos = Vector3.new(1146.200, 5.472, 1221.015) },
            { label = "Stage 10", pos = Vector3.new(1335.200, 5.472, 1221.015) },
            { label = "Stage 11", pos = Vector3.new(1548.200, 5.472, 1221.015) },
            { label = "Stage 12", pos = Vector3.new(1769.200, 5.472, 1221.015) },
        },
    },
}

-- Training dummies
local TRAINING = {
    [1] = {
        free = {
            Vector3.new(-60.699, 7.772, 236.827),
            Vector3.new(-60.684, 7.772, 225.339),
            Vector3.new(-60.774, 8.871, 212.595),
        },
        paid = {
            Vector3.new(-60.774, 8.871, 199.147),
            Vector3.new(-60.774, 8.871, 186.352),
            Vector3.new(-60.903, 10.464, 172.954),
            Vector3.new(-61.010, 11.353, 157.390),
            Vector3.new(-61.169, 13.309, 138.945),
            Vector3.new(-61.391, 16.038, 117.856),
        },
    },
    [2] = {
        free = {
            Vector3.new(-60.699, 7.772, 564.163),
            Vector3.new(-60.684, 7.772, 552.675),
            Vector3.new(-60.774, 8.871, 539.931),
        },
        paid = {
            Vector3.new(-60.774, 8.871, 526.483),
            Vector3.new(-60.774, 8.871, 513.688),
            Vector3.new(-60.903, 10.464, 500.290),
            Vector3.new(-61.010, 11.353, 484.726),
            Vector3.new(-61.169, 13.309, 466.281),
            Vector3.new(-61.391, 16.038, 445.192),
        },
    },
    [3] = {
        free = {
            Vector3.new(-60.699, 7.772, 922.163),
            Vector3.new(-60.684, 7.772, 910.675),
            Vector3.new(-60.774, 8.871, 897.931),
        },
        paid = {
            Vector3.new(-60.774, 8.871, 884.483),
            Vector3.new(-60.774, 8.871, 871.688),
            Vector3.new(-60.903, 10.464, 858.290),
            Vector3.new(-61.010, 11.353, 842.726),
            Vector3.new(-61.169, 13.309, 824.281),
            Vector3.new(-61.391, 16.038, 803.192),
        },
    },
    [4] = {
        free = {
            Vector3.new(-60.699, 7.772, 1295.663),
            Vector3.new(-60.684, 7.772, 1284.175),
            Vector3.new(-60.774, 8.871, 1271.431),
        },
        paid = {
            Vector3.new(-60.774, 8.871, 1257.983),
            Vector3.new(-60.774, 8.871, 1245.188),
            Vector3.new(-60.903, 10.464, 1231.790),
            Vector3.new(-61.010, 11.353, 1216.226),
            Vector3.new(-61.169, 13.309, 1197.781),
            Vector3.new(-61.391, 16.038, 1176.692),
        },
    },
}

-- [[ TRAIL DATA ]]
local TRAILS = {
    { name = "Orange",  wins = 10 },
    { name = "Green",   wins = 25 },
    { name = "Blue",    wins = 50 },
    { name = "Purple",  wins = 75 },
    { name = "White",   wins = 250 },
    { name = "Black",   wins = 550 },
    { name = "Rainbow", wins = 1250 },
    { name = "Lava",    wins = 5250 },
    { name = "Inferno", wins = 12500 },
}

-- [[ PICKAXE DATA ]]
local PICKAXES = {
    -- World 1
    { name = "Wood_Pickaxe",      wins = 0 },
    { name = "Stone_Pickaxe",     wins = 3 },
    { name = "Gold_Pickaxe",      wins = 10 },
    { name = "Iron_Pickaxe",      wins = 30 },
    { name = "Diamond_Pickaxe",   wins = 50 },
    { name = "Purple_Pickaxe",    wins = 100 },
    { name = "Emerald_Pickaxe",   wins = 250 },
    { name = "Ruby_Pickaxe",      wins = 500 },
    { name = "Obsidian_Pickaxe",  wins = 750 },
    { name = "Mythril_Pickaxe",   wins = 1250 },
    { name = "Rainbow_Pickaxe",   wins = 1750 },
    -- World 2
    { name = "Bedrock_Pickaxe",   wins = 0 },
    { name = "Lava_Pickaxe",      wins = 3500 },
    { name = "Tnt_Pickaxe",       wins = 5500 },
    { name = "Skelly_Pickaxe",    wins = 7500 },
    { name = "Magma_Pickaxe",     wins = 12500 },
    { name = "Inferno_Pickaxe",   wins = 17500 },
    { name = "Molten_Pickaxe",    wins = 22500 },
    { name = "Spikes_Pickaxe",    wins = 30000 },
    { name = "Bat_Pickaxe",       wins = 45000 },
    { name = "RainbowBat_Pickaxe",wins = 65000 },
    -- World 3
    { name = "Sand_Pickaxe",      wins = 0 },
    { name = "Yellow_Pickaxe",    wins = 90000 },
    { name = "Evolved_Pickaxe",   wins = 135000 },
    { name = "Orc_Pickaxe",       wins = 175000 },
    { name = "GoldenAxe_Pickaxe", wins = 250000 },
    { name = "Cactus_Pickaxe",    wins = 335000 },
    { name = "Ancient_Pickaxe",   wins = 425000 },
    { name = "Aetherium_Pickaxe", wins = 650000 },
    { name = "Mummy_Pickaxe",     wins = 800000 },
    { name = "RainbowMummy_Pickaxe", wins = 1000000 },
    -- World 4
    { name = "Yellow_LuckyBlock",    wins = 0 },
    { name = "Gray_LuckyBlock",      wins = 1250000 },
    { name = "White_LuckyBlock",     wins = 3350000 },
    { name = "Black_LuckyBlock",     wins = 5000000 },
    { name = "Blue_LuckyBlock",      wins = 7000000 },
    { name = "Pink_LuckyBlock",      wins = 10000000 },
    { name = "Purple_LuckyBlock",    wins = 25000000 },
    { name = "Red_LuckyBlock",       wins = 50000000 },
    { name = "Green_LuckyBlock",     wins = 75000000 },
    { name = "Rainbow_LuckyBlock",   wins = 100000000 },
}

-- [[ HELPERS ]]
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function teleport(pos)
    local root = getRoot()
    if root then root.CFrame = CFrame.new(pos) end
end

local function getWins()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        local w = ls:FindFirstChild("Wins") or ls:FindFirstChild("wins") or ls:FindFirstChild("Points")
        if w then return w.Value end
    end
    return 0
end

local function getRebirths()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        local r = ls:FindFirstChild("Rebirths") or ls:FindFirstChild("rebirths")
        if r then return r.Value end
    end
    return 0
end

-- Track equipped trail via the game's own SyncTrails remote
local _equippedTrail = "None"
local SyncTrails = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SyncTrails")
SyncTrails.OnClientEvent:Connect(function(data)
    if data and data.Equipped then
        _equippedTrail = data.Equipped
    else
        _equippedTrail = "None"
    end
end)
task.defer(function()
    local RequestSync = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("RequestSync")
    if RequestSync then RequestSync:FireServer() end
end)

local function getCurrentPickaxe()
    local name = LocalPlayer:GetAttribute("PickaxeName")
    if name and name ~= "" then
        return name:gsub("_", " ")
    end
    return "None"
end

local function getCurrentTrail()
    return _equippedTrail
end

local function getNextPickaxeReal()
    local current = getCurrentPickaxe()
    local foundIdx = 0
    for i, p in ipairs(PICKAXES) do
        if p.name == current or p.name:gsub("_", " ") == current then
            foundIdx = i
        end
    end
    if foundIdx > 0 and foundIdx < #PICKAXES then
        local np = PICKAXES[foundIdx + 1]
        return np.name:gsub("_", " "), np.wins
    elseif foundIdx == #PICKAXES then
        return "MAX", 0
    else
        local wins = getWins()
        for _, p in ipairs(PICKAXES) do
            if wins < p.wins then return p.name:gsub("_", " "), p.wins end
        end
        return "Unknown", 0
    end
end

local function getNextTrailReal()
    local current = getCurrentTrail()
    local foundIdx = 0
    for i, t in ipairs(TRAILS) do
        if t.name == current then
            foundIdx = i
        end
    end
    if foundIdx > 0 and foundIdx < #TRAILS then
        local nt = TRAILS[foundIdx + 1]
        return nt.name, nt.wins
    elseif foundIdx == #TRAILS then
        return "MAX", 0
    else
        local wins = getWins()
        for _, t in ipairs(TRAILS) do
            if wins < t.wins then return t.name, t.wins end
        end
        return "Unknown", 0
    end
end

-- [[ AUTOFARM STATE ]]
local farmRunning    = { false, false, false, false }
local farmTargetStage = { 1, 1, 1, 1 }
local farmThreads    = { nil, nil, nil, nil }

local danceAnim = Instance.new("Animation")
danceAnim.AnimationId = "rbxassetid://507771019"
local activeDanceTracks = {}

local function stopAllFarms()
    for i = 1, 4 do
        farmRunning[i] = false
        if farmThreads[i] then task.cancel(farmThreads[i]) farmThreads[i] = nil end
    end
    for _, track in pairs(activeDanceTracks) do
        if track then track:Stop() end
    end
    table.clear(activeDanceTracks)
end

local function runFarm(worldIndex)
    local worldData = WORLDS[worldIndex]
    local allStages = worldData.stages
    local angle = 0
    local radius = 10

    while farmRunning[worldIndex] do
        local root = getRoot()
        local hum = getHumanoid()
        if not root or not hum then task.wait(1) continue end
        
        local track = activeDanceTracks[hum]
        if not track then
            local animator = hum:FindFirstChildOfClass("Animator")
            if not animator then
                animator = Instance.new("Animator")
                animator.Parent = hum
            end
            track = animator:LoadAnimation(danceAnim)
            track.Looped = true
            track:Play()
            activeDanceTracks[hum] = track
        elseif not track.IsPlaying then
            track:Play()
        end

        local targetIdx = math.clamp(farmTargetStage[worldIndex], 1, #allStages)
        local stagePos  = allStages[targetIdx].pos
        
        angle = angle + math.rad(5)
        if angle >= math.pi * 2 then angle = angle - (math.pi * 2) end
        
        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        root.CFrame = CFrame.new(stagePos + offset, stagePos)
        
        RunService.Heartbeat:Wait()
    end
    
    local hum = getHumanoid()
    if hum and activeDanceTracks[hum] then
        activeDanceTracks[hum]:Stop()
        activeDanceTracks[hum] = nil
    end
end

-- [[ UI - AUTOFARM TAB ]]
local worldStageLabels = {}
for i = 1, 4 do
    worldStageLabels[i] = {}
    for _, s in ipairs(WORLDS[i].stages) do
        table.insert(worldStageLabels[i], s.label)
    end
end

for i = 1, 4 do
    local wGroup = Tabs.Autofarm:AddLeftGroupbox("World " .. i .. " Autofarm", "zap")

    wGroup:AddDropdown("W" .. i .. "StageDropdown", {
        Values = worldStageLabels[i],
        Default = #worldStageLabels[i],
        Text = "Farm Up To Stage",
        Callback = function(val)
            for idx, s in ipairs(WORLDS[i].stages) do
                if s.label == val then
                    farmTargetStage[i] = idx
                    break
                end
            end
        end,
    })

    farmTargetStage[i] = #WORLDS[i].stages

    wGroup:AddToggle("AutoFarmW" .. i, {
        Text = "Enable World " .. i .. " Farm",
        Default = false,
        Callback = function(value)
            if value then
                for j = 1, 4 do
                    if j ~= i then
                        farmRunning[j] = false
                        if farmThreads[j] then task.cancel(farmThreads[j]) farmThreads[j] = nil end
                        for _, track in pairs(activeDanceTracks) do if track then track:Stop() end end
                        table.clear(activeDanceTracks)
                        if Toggles["AutoFarmW" .. j] then
                            Toggles["AutoFarmW" .. j]:SetValue(false)
                        end
                    end
                end
                farmRunning[i] = true
                farmThreads[i] = task.spawn(function() runFarm(i) end)
            else
                farmRunning[i] = false
                if farmThreads[i] then task.cancel(farmThreads[i]) farmThreads[i] = nil end
                for _, track in pairs(activeDanceTracks) do if track then track:Stop() end end
                table.clear(activeDanceTracks)
            end
        end,
    })
end

local speedGroup = Tabs.Autofarm:AddRightGroupbox("Settings", "settings")

speedGroup:AddToggle("AutoRebirth", {
    Text = "Auto Rebirth",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while Toggles.AutoRebirth.Value do
                    pcall(function() ReplicatedStorage.Remotes.Rebirth:InvokeServer() end)
                    task.wait(1)
                end
            end)
        end
    end,
})

speedGroup:AddToggle("AutoWheel", {
    Text = "Auto Wheel",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while Toggles.AutoWheel.Value do
                    pcall(function() ReplicatedStorage.Remotes.SpinRequest:InvokeServer() end)
                    task.wait(1)
                end
            end)
        end
    end,
})

local StatsGroup = Tabs.Autofarm:AddRightGroupbox("Your Stats", "bar-chart")
local winsLabel       = StatsGroup:AddLabel("Wins: Loading...")
local rebirthsLabel   = StatsGroup:AddLabel("Rebirths: Loading...")
local curPLabel       = StatsGroup:AddLabel("Pickaxe: Loading...")
local curTLabel       = StatsGroup:AddLabel("Trail: Loading...")
local nextPLabel      = StatsGroup:AddLabel("Next Pick: Loading...")
local nextTLabel      = StatsGroup:AddLabel("Next Trail: Loading...")

task.spawn(function()
    while task.wait(2) do
        local wins = getWins()
        local rebs = getRebirths()
        local curP = getCurrentPickaxe()
        local curT = getCurrentTrail()
        local np, npc = getNextPickaxeReal()
        local nt, ntc = getNextTrailReal()
        
        winsLabel:SetText("Wins: " .. wins)
        rebirthsLabel:SetText("Rebirths: " .. rebs)
        curPLabel:SetText("Pickaxe: " .. curP)
        curTLabel:SetText("Trail: " .. curT)
        nextPLabel:SetText("Next Pick: " .. np .. (npc > 0 and (" (" .. (npc - wins) .. " to go)") or ""))
        nextTLabel:SetText("Next Trail: " .. nt .. (ntc > 0 and (" (" .. (ntc - wins) .. " to go)") or ""))
    end
end)

-- [[ UI - SHOP TAB ]]
local PickaxeGroup = Tabs.Shop:AddLeftGroupbox("Pickaxe Shop", "pickaxe")

PickaxeGroup:AddToggle("AutoBuyPickaxe", {
    Text = "Auto Buy Next Pickaxe",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while Toggles.AutoBuyPickaxe.Value do
                    local nextPickaxe, neededWins = getNextPickaxeReal()
                    local wins = getWins()
                    if nextPickaxe ~= "MAX" and nextPickaxe ~= "Unknown" and wins >= neededWins then
                        local rawName = nextPickaxe:gsub(" ", "_")
                        pcall(function() ReplicatedStorage.Remotes.PickaxeShop:FireServer(rawName) end)
                    end
                    task.wait(3)
                end
            end)
        end
    end,
})

local pickaxeNames = {}
for _, p in ipairs(PICKAXES) do
    local displayName = p.name:gsub("_", " ")
    table.insert(pickaxeNames, displayName)
end

PickaxeGroup:AddDropdown("PickaxeDropdown", {
    Values = pickaxeNames,
    Default = 1,
    Text = "Select Pickaxe to Buy",
    Callback = function(Value) end,
})
PickaxeGroup:AddButton({
    Text = "Buy Selected Pickaxe",
    Func = function()
        local selected = Options.PickaxeDropdown.Value:gsub(" ", "_")
        pcall(function() ReplicatedStorage.Remotes.PickaxeShop:FireServer(selected) end)
        Library:Notify({ Title = "Pickaxe Shop", Description = "Bought: " .. selected, Duration = 3 })
    end,
})

local TrailGroup = Tabs.Shop:AddRightGroupbox("Trail Shop", "star")

TrailGroup:AddToggle("AutoBuyTrail", {
    Text = "Auto Buy Next Trail",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while Toggles.AutoBuyTrail.Value do
                    local nextTrail, neededWins = getNextTrailReal()
                    local wins = getWins()
                    if nextTrail ~= "MAX" and nextTrail ~= "Unknown" and wins >= neededWins then
                        pcall(function() ReplicatedStorage.Remotes.BuyTrail:InvokeServer(nextTrail) end)
                    end
                    task.wait(3)
                end
            end)
        end
    end,
})

local trailNames = {}
for _, t in ipairs(TRAILS) do table.insert(trailNames, t.name) end

TrailGroup:AddDropdown("TrailDropdown", {
    Values = trailNames,
    Default = 1,
    Text = "Select Trail to Buy",
    Callback = function(Value) end,
})
TrailGroup:AddButton({
    Text = "Buy Selected Trail",
    Func = function()
        local selected = Options.TrailDropdown.Value
        pcall(function() ReplicatedStorage.Remotes.BuyTrail:InvokeServer(selected) end)
        Library:Notify({ Title = "Trail Shop", Description = "Bought: " .. selected, Duration = 3 })
    end,
})

-- [[ UI - TELEPORT TAB ]]
for i = 1, 4 do
    local funcName = (i % 2 == 0) and "AddRightGroupbox" or "AddLeftGroupbox"
    
    local TpGroup = Tabs.Teleport[funcName](Tabs.Teleport, "World " .. i, "map-pin")
    TpGroup:AddButton({
        Text = "World " .. i .. " Start",
        Func = function() teleport(WORLDS[i].start) end,
    })
    for _, s in ipairs(WORLDS[i].stages) do
        local label = s.label
        local pos   = s.pos
        TpGroup:AddButton({ Text = "→ " .. label, Func = function() teleport(pos) end })
    end
end

-- [[ UI - TRAINING TAB ]]
for i = 1, #TRAINING do
    local funcName = (i % 2 == 0) and "AddRightGroupbox" or "AddLeftGroupbox"
    
    local DGroup = Tabs.Training[funcName](Tabs.Training, "W" .. i .. " Training", "swords")
    DGroup:AddLabel("Free Dummies:")
    for di, pos in ipairs(TRAINING[i].free) do
        DGroup:AddButton({ Text = "Free Dummy " .. di, Func = function() teleport(pos) end })
    end
    DGroup:AddLabel("Paid Dummies:")
    for di, pos in ipairs(TRAINING[i].paid) do
        DGroup:AddButton({ Text = "Paid Dummy " .. di, Func = function() teleport(pos) end })
    end
end

-- [[ UI SETTINGS ]]
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value) Library.KeybindFrame.Visible = value end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = Library.ShowCustomCursor,
    Callback = function(Value) Library.ShowCustomCursor = Value end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value) Library:SetNotifySide(Value) end,
})
MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        Library:SetDPIScale(tonumber(Value))
    end,
})
MenuGroup:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = Library.CornerRadius,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value) Window:SetCornerRadius(value) end
})
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton({ Text = "Unload", Func = function() Library:Unload() end })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("CryptSec")
SaveManager:SetFolder("CryptSec/PickaxeSwingEscape")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

-- Mobile/PC Toggle Bar
Library:AddDraggableButton("Open/Close", function()
    Library:Toggle()
end, false, 94651747085280, "Left")

-- [[ CLEANUP ]]
Library:OnUnload(function()
    stopAllFarms()
    for _, conn in ipairs(connections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
end)
