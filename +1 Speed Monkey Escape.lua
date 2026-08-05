-- Wait for the game to load completely
repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Game-specific remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Load Obsidian UI Library & Addons
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
	Footer = "+1 Speed Monkey Escape",
	Icon = 121626436575118,
	NotifySide = "Right",
	ShowCustomCursor = false
})

-- Define Tabs
local Tabs = {
    ["Teleports"] = Window:AddTab("Teleports", "map"),
    ["Upgrades"] = Window:AddTab("Upgrades", "star"),
    ["Player"] = Window:AddTab("Player", "user"),
    ["Admin"] = Window:AddTab("Admin", "shield"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- ===================== DATABASE =====================
local Auras = {
    {Name = "Amber",     Price = 5000},
    {Name = "Ice Cold",  Price = 150000},
    {Name = "Nature",    Price = 4000000},
    {Name = "Rainbow",   Price = 500000000},
    {Name = "Lunar",     Price = 135000000000},
    {Name = "Sparkle",   Price = 7875000000000},
    {Name = "Fairy",     Price = 3e+15},
    {Name = "Spectral",  Price = 1.35e+17},
    {Name = "Yin Yang",  Price = 3e+18},
    {Name = "Bloodmoon", Price = 6.875e+21},
    {Name = "Sakura",    Price = 1.5e+24},
}

local Trails = {
    {Name = "Red",       Price = 1000},
    {Name = "Blue",      Price = 30000},
    {Name = "Green",     Price = 750000},
    {Name = "Rainbow",   Price = 20000000},
    {Name = "Galaxy",    Price = 2500000000},
    {Name = "Divine",    Price = 900000000000},
    {Name = "Fairy",     Price = 262500000000000},
    {Name = "Spectral",  Price = 1.6e+16},
    {Name = "Yin Yang",  Price = 4.5e+18},
    {Name = "Bloodmoon", Price = 2.5e+2},
    {Name = "Sakura",    Price = 6.875e+22},
}

local function getAuraNames()
    local t = {}
    for _, v in ipairs(Auras) do table.insert(t, v.Name) end
    return t
end

local function getTrailNames()
    local t = {}
    for _, v in ipairs(Trails) do table.insert(t, v.Name) end
    return t
end

local function getWins()
    local ls = LP:FindFirstChild("leaderstats")
    if not ls then return 0 end
    local wins = ls:FindFirstChild("Wins") or ls:FindFirstChild("Win")
    if wins and (wins:IsA("NumberValue") or wins:IsA("IntValue")) then
        return wins.Value
    end
    return 0
end

local function getBestAffordable(list, useWins)
    local currency = getWins()
    local best = nil
    for _, item in ipairs(list) do
        local req = item.Price or item.Wins
        if currency >= req then
            best = item
        else
            break
        end
    end
    return best
end

local function getOwnedNames(folder)
    local owned = {}
    if not folder then return owned end

    for _, v in ipairs(folder:GetChildren()) do
        if v:IsA("BoolValue") and v.Value == true then
            table.insert(owned, v.Name)
        elseif v:IsA("StringValue") then
            table.insert(owned, v.Value)
        else
            table.insert(owned, v.Name)
        end
    end
    return owned
end

local function getBestOwned(list, ownedNames)
    local best = nil
    for _, item in ipairs(list) do
        for _, name in ipairs(ownedNames) do
            if item.Name == name then
                best = item
                break
            end
        end
    end
    return best
end

-- ===================== UPGRADES TAB =====================
local AuraBox = Tabs.Upgrades:AddLeftGroupbox("Auras")
AuraBox:AddDropdown("SelectedAura", {
    Values = getAuraNames(),
    Default = 1,
    Multi = false,
    Text = "Aura",
})
AuraBox:AddButton({
    Text = "Buy Selected Aura",
    Func = function()
        local name = Options.SelectedAura and Options.SelectedAura.Value
        if name then
            pcall(function() Remotes.BuyAura:FireServer(name) end)
        end
    end,
})
AuraBox:AddToggle("AutoBuyBestAura", {
    Text = "Auto Buy Best Aura",
    Default = false,
})
AuraBox:AddButton({
    Text = "Equip Best Aura",
    Func = function()
        local data = LP:FindFirstChild("Data")
        local unlocked = data and data:FindFirstChild("UnlockedAuras")
        local owned = getOwnedNames(unlocked)
        local best = getBestOwned(Auras, owned)
        if best then
            pcall(function()
                Remotes.EquipAura:FireServer(best.Name)
            end)
        end
    end,
})

local TrailBox = Tabs.Upgrades:AddRightGroupbox("Trails")
TrailBox:AddDropdown("SelectedTrail", {
    Values = getTrailNames(),
    Default = 1,
    Multi = false,
    Text = "Trail",
})
TrailBox:AddButton({
    Text = "Buy Selected Trail",
    Func = function()
        local name = Options.SelectedTrail and Options.SelectedTrail.Value
        if name then
            pcall(function() Remotes.BuyTrail:FireServer(name) end)
        end
    end,
})
TrailBox:AddToggle("AutoBuyBestTrail", {
    Text = "Auto Buy Best Trail",
    Default = false,
})
TrailBox:AddButton({
    Text = "Equip Best Trail",
    Func = function()
        local data = LP:FindFirstChild("Data")
        local unlocked = data and data:FindFirstChild("UnlockedTrails")
        local owned = getOwnedNames(unlocked)
        local best = getBestOwned(Trails, owned)
        if best then
            pcall(function()
                Remotes.EquipTrail:FireServer(best.Name)
            end)
        end
    end,
})

local AutoBox = Tabs.Upgrades:AddRightGroupbox("Rebirth")
local autoRebirthEnabled = false
AutoBox:AddToggle("AutoRebirthToggle", {
    Text = "Auto Rebirth",
    Default = false,
    Callback = function(Value)
        autoRebirthEnabled = Value
        if autoRebirthEnabled then
            task.spawn(function()
                while autoRebirthEnabled do
                    pcall(function() Remotes.Rebirth:FireServer() end)
                    task.wait()
                end
            end)
        end
    end,
})

-- ===================== CHARMS =====================
local CharmBox = Tabs.Upgrades:AddLeftGroupbox("Charms")

CharmBox:AddDropdown("SelectedCharmSlots", {
    Values = {"Slot 1", "Slot 2", "Slot 3"},
    Default = {},
    Multi = true,
    Text = "Charm Slots",
})

local autoBuyCharmEnabled = false
CharmBox:AddToggle("AutoBuyCharm", {
    Text = "Auto Buy SelectedSlots",
    Default = false,
    Callback = function(Value)
        autoBuyCharmEnabled = Value
        if autoBuyCharmEnabled then
            task.spawn(function()
                while autoBuyCharmEnabled do
                    local selected = Options.SelectedCharmSlots and Options.SelectedCharmSlots.Value
                    if selected then
                        for slotName, isSelected in pairs(selected) do
                            if isSelected then
                                local slotNumber = tonumber(slotName:match("%d+"))
                                if slotNumber then
                                    pcall(function()
                                        Remotes.BuyCharm:FireServer(slotNumber)
                                    end)
                                end
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end,
})

-- ===================== QUANTUM TREADMILL =====================
local QuantumBox = Tabs.Upgrades:AddRightGroupbox("Quantum Treadmill")

local QuantumPositions = {
    World1 = {
        Vector3.new(-870.0133056640625, 53.540435791015625, -151.91766357421875),   -- 1st
        Vector3.new(-3578.01318359375, 171.2904052734375, -455.91766357421875),    -- 2nd
    },
    World2 = {
        Vector3.new(-926.0133056640625, 83.2904281616211, -2486.89892578125),
    },
    World3 = {
        Vector3.new(-1132.0133056640625, 22.790464401245117, 2775.10107421875),    -- 1st
        Vector3.new(-3387.01318359375, 279.04010009765625, 2756.10107421875),     -- 2nd
    },
}

local autoQuantumEnabled = false

local function getTreadmillPosition()
    local spawnFolder = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("QuantumTreadmillSpawns")
    if not spawnFolder then return nil end

    local treadmill = spawnFolder:FindFirstChild("TreadmillQuantum")
    if not treadmill then return nil end

    if treadmill:IsA("Model") then
        return treadmill:GetPivot().Position
    elseif treadmill:IsA("BasePart") then
        return treadmill.Position
    else
        local part = treadmill:FindFirstChildWhichIsA("BasePart", true)
        return part and part.Position
    end
end

local function TeleportToPos(pos)
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:PivotTo(CFrame.new(pos + Vector3.new(0, 3, 0)))
    end
end

local function goToQuantum(positions)
    if #positions == 1 then
        -- Only one possible spawn → just go there
        TeleportToPos(positions[1])
        return
    end

    -- Multiple possible spawns → keep trying both until treadmill is within 20 studs
    task.spawn(function()
        local attempts = 0
        while attempts < 30 do -- safety limit
            for _, pos in ipairs(positions) do
                TeleportToPos(pos)
                task.wait(0.25)

                local treadmillPos = getTreadmillPosition()
                if treadmillPos and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (LP.Character.HumanoidRootPart.Position - treadmillPos).Magnitude
                    if distance <= 20 then
                        -- Found the correct one
                        return
                    end
                end
            end
            attempts += 1
            task.wait(0.1)
        end
    end)
end

QuantumBox:AddToggle("AutoQuantum", {
    Text = "Auto 10x (Quantum Treadmill)",
    Default = false,
    Callback = function(Value)
        autoQuantumEnabled = Value
    end,
})

-- Listen for the announcement remote
pcall(function()
    Remotes.WorldEventAnnounced.OnClientEvent:Connect(function(message)
        if not autoQuantumEnabled then return end
        if typeof(message) ~= "string" then return end

        task.wait(0.2) -- small delay so treadmill has time to spawn

        if message:find("World 1") then
            goToQuantum(QuantumPositions.World1)
        elseif message:find("World 2") then
            goToQuantum(QuantumPositions.World2)
        elseif message:find("World 3") then
            goToQuantum(QuantumPositions.World3)
        end
    end)
end)

-- ===================== PLAYER TAB =====================
local MovementBox = Tabs.Player:AddLeftGroupbox('Movement')
local StealthBox = Tabs.Player:AddRightGroupbox('Stealth')

local walkSpeedEnabled = false
local targetWalkSpeed = 16

MovementBox:AddToggle('WS_Toggle', {
    Text = 'Enable Speed',
    Default = false,
    Callback = function(Value) walkSpeedEnabled = Value end
})

MovementBox:AddSlider('WS_Slider', {
    Text = 'WalkSpeed Value',
    Default = 16,
    Min = 16,
    Max = 250,
    Rounding = 0,
    Callback = function(Value) targetWalkSpeed = Value end
})

RunService.RenderStepped:Connect(function(delta)
    if walkSpeedEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        local root = LP.Character.HumanoidRootPart
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (targetWalkSpeed - 16) * delta)
        end
    end
end)

local flyEnabled = false
local flySpeed = 50
local flyConnection

MovementBox:AddToggle('Fly_Toggle', {
    Text = 'Enable Fly',
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        local char = LP.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        if Value then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "IY_Fly_BV"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.zero
            bv.Parent = char.HumanoidRootPart
            
            flyConnection = RunService.RenderStepped:Connect(function(delta)
                if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChild("Humanoid") then return end
                local hrp = LP.Character.HumanoidRootPart
                local hum = LP.Character.Humanoid
                local moveDir = hum.MoveDirection 
                local y = 0
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then y = 1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then y = -1 end
                local velocity = Vector3.new(moveDir.X * flySpeed, y * flySpeed, moveDir.Z * flySpeed)
                hrp.CFrame = hrp.CFrame + (velocity * delta)
                hrp.Velocity = Vector3.zero
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            if char:FindFirstChild("HumanoidRootPart") then
                local bv = char.HumanoidRootPart:FindFirstChild("IY_Fly_BV")
                if bv then bv:Destroy() end
            end
        end
    end
})

MovementBox:AddSlider('Fly_Slider', {
    Text = 'Fly Speed',
    Default = 50,
    Min = 16,
    Max = 300,
    Rounding = 0,
    Callback = function(Value) flySpeed = Value end
})

local noclipEnabled = false
StealthBox:AddToggle('Noclip_Toggle', {
    Text = 'Noclip',
    Default = false,
    Callback = function(Value) noclipEnabled = Value end
})

RunService.Stepped:Connect(function()
    if noclipEnabled and LP.Character then
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

StealthBox:AddToggle('Invis_Toggle', {
    Text = 'Invisible',
    Default = false,
    Callback = function(Value)
        local char = LP.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = Value and 1 or 0
            elseif part:IsA("Decal") then
                part.Transparency = Value and 1 or 0
            end
        end
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.DisplayDistanceType = Value and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
})

-- ===================== TELEPORTS TAB =====================
local StagePositions = {
    [1] = { -- World 1
        ["Stage 1"] = Vector3.new(-682.162353515625, 23.040430068969727, -255.04849243164062),
        ["Stage 2"] = Vector3.new(-935.662353515625, 23.040435791015625, -255.04849243164062),
        ["Stage 3"] = Vector3.new(-1214.1622314453125, 23.040435791015625, -255.04849243164062),
        ["Stage 4"] = Vector3.new(-1569.162353515625, 23.040435791015625, -255.04849243164062),
        ["Stage 5"] = Vector3.new(-2183.162109375, 118.04045104980469, -255.04849243164062),
        ["Stage 6"] = Vector3.new(-3046.412109375, 118.04045104980469, -255.04849243164062),
        ["Stage 7"] = Vector3.new(-4318.162109375, 277.0404052734375, -255.04849243164062),
        ["Stage 8"] = Vector3.new(-6158.662109375, 277.0404357910156, -254.66766357421875),
        ["Stage 9"] = Vector3.new(-9459.662109375, 386.04046630859375, -254.66766357421875),
    },
    [2] = { -- World 2
        ["Stage 1"] = Vector3.new(-735.162353515625, 23.040430068969727, -2565.04833984375),
        ["Stage 2"] = Vector3.new(-1095.0133056640625, 38.040435791015625, -2565.04833984375),
        ["Stage 3"] = Vector3.new(-1880.162353515625, -51.959564208984375, -2565.04833984375),
        ["Stage 4"] = Vector3.new(-2400.162353515625, 55.3404655456543, -2565.04833984375),
        ["Stage 5"] = Vector3.new(-3247.162353515625, 55.3404655456543, -2565.04833984375),
        ["Stage 6"] = Vector3.new(-3605.3828125, 55.340484619140625, -3697.48828125),
        ["Stage 7"] = Vector3.new(-3605.3828125, 55.340484619140625, -4607.48828125),
        ["Stage 8"] = Vector3.new(-3605.3828125, 55.340484619140625, -5827.48828125),
        ["Stage 9"] = Vector3.new(-3605.3828125, 151.34048461914062, -9378.48828125),
    },
    [3] = { -- World 3
        ["Stage 1"] = Vector3.new(-684.162353515625, 22.540428161621094, 2740.951416015625),
        ["Stage 2"] = Vector3.new(-953.6300659179688, 22.540428161621094, 2740.951416015625),
        ["Stage 3"] = Vector3.new(-1286.6302490234375, 22.540428161621094, 2740.951416015625),
        ["Stage 4"] = Vector3.new(-1684.6302490234375, 22.540428161621094, 2740.951416015625),
        ["Stage 5"] = Vector3.new(-2240.630615234375, 22.540428161621094, 2740.951416015625),
        ["Stage 6"] = Vector3.new(-2560.630615234375, 278.5404052734375, 2740.951416015625),
        ["Stage 7"] = Vector3.new(-4208.630859375, 278.5404052734375, 2740.951416015625),
        ["Stage 8"] = Vector3.new(-5420.630859375, 278.5404052734375, 2740.951416015625),
        ["Stage 9"] = Vector3.new(-8077.630859375, 278.5404052734375, 2740.951416015625),
    },
    [4] = { -- World 4
        ["Stage 1"] = Vector3.new(-684.162353515625, 22.540428161621094, 5740.951171875),
        ["Stage 2"] = Vector3.new(-892.1624755859375, 22.540428161621094, 5740.951171875),
        ["Stage 3"] = Vector3.new(-1206.6624755859375, 22.540428161621094, 5740.951171875),
        ["Stage 4"] = Vector3.new(-1592.6624755859375, 22.540428161621094, 5740.951171875),
        ["Stage 5"] = Vector3.new(-1852.0552978515625, 172.54042053222656, 5740.951171875),
        ["Stage 6"] = Vector3.new(-2718.05517578125, 172.54042053222656, 5740.951171875),
    },
}

local function TeleportToPosition(pos)
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if typeof(pos) == "Vector3" then
        char:PivotTo(CFrame.new(pos + Vector3.new(0, 3, 0)))
    end
end

local function findAndTeleport(worldNumber, stageName)
    local worldStages = StagePositions[worldNumber]
    if not worldStages then return end

    local pos = worldStages[stageName]
    if pos then
        TeleportToPosition(pos)
    end
end

local WorldsBox = Tabs.Teleports:AddRightGroupbox("Worlds")
for i = 1, 4 do
    WorldsBox:AddButton({
        Text = "Teleport World " .. i,
        Func = function()
            pcall(function() Remotes.TeleportWorld:FireServer(i) end)
        end,
    })
end

local World1Box = Tabs.Teleports:AddLeftGroupbox("World 1")
World1Box:AddDropdown("World1Stage", {
    Values = {"Stage 1", "Stage 2", "Stage 3", "Stage 4", "Stage 5", "Stage 6", "Stage 7", "Stage 8", "Stage 9"},
    Default = 1, Multi = false, Text = "Stage",
})
World1Box:AddToggle("World1Enabled", { Text = "Enable World 1 TP", Default = false })

local World2Box = Tabs.Teleports:AddLeftGroupbox("World 2")
World2Box:AddDropdown("World2Stage", {
    Values = {"Stage 1", "Stage 2", "Stage 3", "Stage 4", "Stage 5", "Stage 6", "Stage 7", "Stage 8", "Stage 9"},
    Default = 1, Multi = false, Text = "Stage",
})
World2Box:AddToggle("World2Enabled", { Text = "Enable World 2 TP", Default = false })

local World3Box = Tabs.Teleports:AddLeftGroupbox("World 3")
World3Box:AddDropdown("World3Stage", {
    Values = {"Stage 1", "Stage 2", "Stage 3", "Stage 4", "Stage 5", "Stage 6", "Stage 7", "Stage 8", "Stage 9"},
    Default = 1, Multi = false, Text = "Stage",
})
World3Box:AddToggle("World3Enabled", { Text = "Enable World 3 TP", Default = false })

local World4Box = Tabs.Teleports:AddLeftGroupbox("World 4")
World4Box:AddDropdown("World4Stage", {
    Values = {"Stage 1", "Stage 2", "Stage 3", "Stage 4", "Stage 5", "Stage 6"},
    Default = 1, Multi = false, Text = "Stage",
})
World4Box:AddToggle("World4Enabled", { Text = "Enable World 4 TP", Default = false })

local ClickTPBox = Tabs.Teleports:AddRightGroupbox('Click TP')
local clickTpEnabled = false
ClickTPBox:AddToggle('ClickTPToggle_PC', {
    Text = 'PC: Ctrl + Left Click TP',
    Default = false,
    Callback = function(Value) clickTpEnabled = Value end
})

local mouse = LP:GetMouse()
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        if clickTpEnabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local targetPos = mouse.Hit.Position
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character:PivotTo(CFrame.new(targetPos + Vector3.new(0, 3, 0)))
            end
        end
    end
end)

ClickTPBox:AddButton({
    Text = 'Mobile: Get Click TP Tool',
    Func = function()
        if LP.Backpack:FindFirstChild("Mobile Click TP") or (LP.Character and LP.Character:FindFirstChild("Mobile Click TP")) then
            return
        end
        local tool = Instance.new("Tool")
        tool.Name = "Mobile Click TP"
        tool.RequiresHandle = false
        tool.ToolTip = "Equip and tap to teleport"
        tool.Activated:Connect(function()
            local mouseHit = LP:GetMouse().Hit.Position
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character:PivotTo(CFrame.new(mouseHit + Vector3.new(0, 3, 0)))
            end
        end)
        tool.Parent = LP.Backpack
    end
})

-- ===================== ADMIN TAB =====================

-- Speed Multiplier
local SpeedBox = Tabs.Admin:AddLeftGroupbox("Speed Multiplier")
SpeedBox:AddInput("SpeedMultiValue", {
    Default = "100000",
    Numeric = true,
    Finished = false,
    Text = "Multiplier Value",
    Placeholder = "e.g. 100000",
})
SpeedBox:AddButton({
    Text = "Apply Speed Multiplier",
    Func = function()
        local val = tonumber(Options.SpeedMultiValue.Value) or 100000
        pcall(function()
            firesignal(Remotes.GlobalSpeedMulti.OnClientEvent, val)
        end)
    end,
})

-- Admin Spin
local SpinBox = Tabs.Admin:AddLeftGroupbox("Admin Spin")
SpinBox:AddInput("SpinReward1", {
    Default = "1 hour x2 Speed",
    Text = "Reward 1",
})
SpinBox:AddInput("SpinReward2", {
    Default = "+100M",
    Text = "Reward 2",
})
SpinBox:AddInput("SpinReward3", {
    Default = "+10M",
    Text = "Reward 3",
})
SpinBox:AddInput("SpinReward4", {
    Default = "+1",
    Text = "Reward 4",
})
SpinBox:AddInput("SpinReward5", {
    Default = "+1M",
    Text = "Reward 5",
})
SpinBox:AddInput("SpinReward6", {
    Default = "+71.4K",
    Text = "Reward 6",
})
SpinBox:AddButton({
    Text = "Fire Admin Spin",
    Func = function()
        local rewards = {
            Options.SpinReward1.Value,
            Options.SpinReward2.Value,
            Options.SpinReward3.Value,
            Options.SpinReward4.Value,
            Options.SpinReward5.Value,
            Options.SpinReward6.Value,
        }
        pcall(function()
            firesignal(Remotes.WheelResult.OnClientEvent, 1, {
                {Chance = 10, Type = "x2 Speed"},
                {Chance = 10, Type = "Speed 3"},
                {Chance = 10, Type = "Speed 2"},
                {Chance = 50, Type = "Rebirth"},
                {Chance = 10, Type = "Speed 1"},
                {Chance = 10, Type = "Wins"}
            }, rewards)
        end)
    end,
})

-- Announcement
local AnnounceBox = Tabs.Admin:AddRightGroupbox("Announcement")
AnnounceBox:AddInput("AnnounceUsername", {
    Default = "Albiza",
    Text = "Username",
    Placeholder = "Username",
})
AnnounceBox:AddInput("AnnounceMessage", {
    Default = "Hello everyone!",
    Text = "Message",
    Placeholder = "Message text",
})
AnnounceBox:AddInput("AnnounceImage", {
    Default = "11360536127",
    Numeric = true,
    Text = "Image ID (UserID)",
    Placeholder = "UserID / Image ID",
})
AnnounceBox:AddButton({
    Text = "Send Announcement",
    Func = function()
        local username = Options.AnnounceUsername.Value or "Someone"
        local message = Options.AnnounceMessage.Value or "Hello"
        local img = tonumber(Options.AnnounceImage.Value) or 11360536127

        local fullMessage = username .. "\xEE\x80\x80: " .. message

        pcall(function()
            firesignal(Remotes.GlobalMessage.OnClientEvent, fullMessage, img)
        end)
    end,
})

-- Banana Spawn
local BananaBox = Tabs.Admin:AddRightGroupbox("Banana Spawn")
BananaBox:AddInput("BananaName", {
    Default = "Albiza",
    Text = "Owner Name",
    Placeholder = "Name that appears",
})
BananaBox:AddInput("BananaAmount", {
    Default = "1000",
    Numeric = true,
    Text = "Amount",
    Placeholder = "How many bananas",
})
BananaBox:AddButton({
    Text = "Spawn Bananas",
    Func = function()
        local name = Options.BananaName.Value or "Someone"
        local amount = tonumber(Options.BananaAmount.Value) or 1000
        pcall(function()
            firesignal(Remotes.BananaSpawned.OnClientEvent, name, amount)
        end)
    end,
})

-- ===================== LOOPS =====================
local lastBuy = 0
RunService.Heartbeat:Connect(function()
    -- Stage TPs
    if Toggles.World1Enabled and Toggles.World1Enabled.Value then
        local stage = Options.World1Stage and Options.World1Stage.Value
        if stage then findAndTeleport(1, stage) end
    end
    if Toggles.World2Enabled and Toggles.World2Enabled.Value then
        local stage = Options.World2Stage and Options.World2Stage.Value
        if stage then findAndTeleport(2, stage) end
    end
    if Toggles.World3Enabled and Toggles.World3Enabled.Value then
        local stage = Options.World3Stage and Options.World3Stage.Value
        if stage then findAndTeleport(3, stage) end
    end
    if Toggles.World4Enabled and Toggles.World4Enabled.Value then
        local stage = Options.World4Stage and Options.World4Stage.Value
        if stage then findAndTeleport(4, stage) end
    end

    -- Auto Buy Best
    local now = tick()
    if now - lastBuy < 0.5 then return end

    if Toggles.AutoBuyBestAura and Toggles.AutoBuyBestAura.Value then
        local best = getBestAffordable(Auras)
        if best then
            pcall(function() Remotes.BuyAura:FireServer(best.Name) end)
            lastBuy = now
        end
    end
    if Toggles.AutoBuyBestTrail and Toggles.AutoBuyBestTrail.Value then
        local best = getBestAffordable(Trails)
        if best then
            pcall(function() Remotes.BuyTrail:FireServer(best.Name) end)
            lastBuy = now
        end
    end
end)

-- ===================== UI SETTINGS =====================
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
    Default = Library.CornerRadius or 8,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value) pcall(function() Window:SetCornerRadius(value) end) end
})
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton({ Text = "Unload", Func = function() Library:Unload() end })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("CryptSec")
SaveManager:SetFolder("CryptSec/SpeedMonkeyEscape")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

Library:AddDraggableButton("Open/Close", function()
    Library:Toggle()
end, false, 94651747085280, "Left")
