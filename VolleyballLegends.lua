local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ==================== LIBRARY ====================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
	Title = "CryptSec",
	Footer = "VolleyBall Legends",
	Icon = 121626436575118,
	NotifySide = "Right",
	ShowCustomCursor = false
})

local Tabs = {
    Farm = Window:AddTab("Farm", "zap"),
    Movement = Window:AddTab("Movement", "move"),
    Settings = Window:AddTab("Settings", "settings"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings")
}

-- ==================== GLOBALS ====================
_G.CurrentHitboxScale = 5.0
_G.HitboxEnabled = false
_G.DirectionalJump = false
_G.AirMoveEnabled = false
_G.AirMoveSpeed = 50
_G.FacingRaysEnabled = false
_G.L = false -- Lucky Spins
_G.Y = false -- Yen
_G.H = false -- Ability Spins

-- ==================== FARM TAB ====================
local FarmLeft = Tabs.Farm:AddLeftGroupbox("Auto Farm", "zap")

local remote = nil
pcall(function()
    remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("SeasonService"):WaitForChild("RF"):WaitForChild("RequestRankedReward")
end)

FarmLeft:AddToggle("AutoLuckySpins", {
    Text = "Auto Lucky Spins",
    Default = false,
    Callback = function(v)
        _G.L = v
        if v then
            task.spawn(function()
                while _G.L do
                    pcall(function()
                        if remote then remote:InvokeServer(1) end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

FarmLeft:AddToggle("AutoYenFarm", {
    Text = "Auto Yen Farm",
    Default = false,
    Callback = function(v)
        _G.Y = v
        if v then
            task.spawn(function()
                while _G.Y do
                    pcall(function()
                        if remote then remote:InvokeServer(2) end
                    end)
                    task.wait(0.6)
                end
            end)
        end
    end
})

FarmLeft:AddToggle("AutoAbilitySpins", {
    Text = "Auto Ability Spins",
    Default = false,
    Callback = function(v)
        _G.H = v
        if v then
            task.spawn(function()
                while _G.H do
                    pcall(function()
                        if remote then remote:InvokeServer(4) end
                    end)
                    task.wait(1.5)
                end
            end)
        end
    end
})

-- ==================== MOVEMENT TAB ====================
local MovementLeft = Tabs.Movement:AddLeftGroupbox("Hitbox & Movement", "move")
local MovementRight = Tabs.Movement:AddRightGroupbox("Air & Jump", "wind")

local function createOrUpdateHitboxes(scale)
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model.Name:match("^CLIENT_BALL_%d+$") then
            local ball = model:FindFirstChild("Ball.001")
            if not ball then
                local ref = nil
                for _, p in ipairs(model:GetDescendants()) do
                    if p:IsA("BasePart") then
                        ref = p
                        break
                    end
                end
                if ref then
                    ball = Instance.new("Part")
                    ball.Name = "Ball.001"
                    ball.Shape = Enum.PartType.Ball
                    ball.Size = Vector3.new(2, 2, 2) * scale
                    ball.CFrame = ref.CFrame
                    ball.Anchored = true
                    ball.CanCollide = false
                    ball.Transparency = 0.7
                    ball.Material = Enum.Material.ForceField
                    ball.Color = Color3.fromRGB(45, 120, 75)
                    ball.Parent = model
                end
            else
                ball.Size = Vector3.new(2, 2, 2) * scale
            end
        end
    end
end

MovementLeft:AddToggle("HitboxExpander", {
    Text = "Enable Hitbox Expander",
    Default = false,
    Callback = function(v)
        _G.HitboxEnabled = v
    end
})

MovementLeft:AddSlider("HitboxScale", {
    Text = "Hitbox Scale",
    Default = 5,
    Min = 0,
    Max = 25,
    Rounding = 1,
    Callback = function(v)
        _G.CurrentHitboxScale = v
    end
})

MovementRight:AddToggle("DirectionalJump", {
    Text = "Directional Jump",
    Default = false,
    Callback = function(v)
        _G.DirectionalJump = v
    end
})

MovementRight:AddToggle("AirMovement", {
    Text = "Enable Air Movement",
    Default = false,
    Callback = function(v)
        _G.AirMoveEnabled = v
    end
})

MovementRight:AddSlider("AirMoveSpeed", {
    Text = "Air Movement Speed",
    Default = 50,
    Min = 15,
    Max = 150,
    Rounding = 0,
    Callback = function(v)
        _G.AirMoveSpeed = v
    end
})

-- Directional Jump Logic
UserInputService.JumpRequest:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if _G.DirectionalJump and humanoid and hrp then
        task.defer(function()
            task.wait(0.03)
            local cameraLook = Workspace.CurrentCamera.CFrame.LookVector
            local flattenedLook = Vector3.new(cameraLook.X, 0, cameraLook.Z).Unit
            if flattenedLook.Magnitude > 0 then
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flattenedLook)
                humanoid.AutoRotate = false
            end
        end)
    elseif humanoid then
        humanoid.AutoRotate = true
    end
end)

-- ==================== SETTINGS TAB ====================
local SettingsLeft = Tabs.Settings:AddLeftGroupbox("Performance", "gauge")
local SettingsRight = Tabs.Settings:AddRightGroupbox("Visuals", "eye")

SettingsLeft:AddToggle("FPSBooster", {
    Text = "FPS Booster (999 Target)",
    Default = false,
    Callback = function(v)
        if setfpscap then
            setfpscap(v and 999 or 60)
        end
    end
})

SettingsRight:AddToggle("FacingRays", {
    Text = "Opponent Facing Rays (80 Studs)",
    Default = false,
    Callback = function(v)
        _G.FacingRaysEnabled = v
        if not v then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("OpponentFacingRay") then
                    player.Character.OpponentFacingRay:Destroy()
                end
            end
        end
    end
})

-- Potato Optimizer
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local BALL_GUESSES = {"Volleyball", "Ball", "Football", "MainBall", "GameBall", "VBall"}

local function processObject(obj)
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local nameLower = string.lower(obj.Name)

    local isLookArrow = string.find(nameLower, "arrow") or string.find(nameLower, "ray") or string.find(nameLower, "look") or string.find(nameLower, "pointer")
    if isLookArrow then
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Neon
            obj.Color = Color3.fromRGB(40, 255, 0)
            obj.Transparency = 0
            obj.CastShadow = false
            obj.CFrame = CFrame.new(obj.CFrame.X, 0.5, obj.CFrame.Z)
            return
        elseif obj:IsA("Beam") or obj:IsA("Trail") then
            obj.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))
            obj.Enabled = true
            return
        end
    end

    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Sparkles") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
        obj:Destroy()
        return
    end

    if obj:IsA("Clouds") or obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("SunRaysEffect") then return end

    local isGuiObject = obj:IsDescendantOf(game:GetService("CoreGui")) or (playerGui and obj:IsDescendantOf(playerGui))
    if isGuiObject then return end

    local parent = obj.Parent
    local isPlayerPart = parent and (parent:IsA("Model") and Players:GetPlayerFromCharacter(parent)) or (parent and parent.Parent and parent.Parent:IsA("Model") and Players:GetPlayerFromCharacter(parent.Parent))

    if isPlayerPart and (obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("Clothing") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") or obj:IsA("Accessory")) then
        obj:Destroy()
        return
    end

    if obj:IsA("BasePart") then
        obj.CastShadow = false
        if obj.Transparency >= 0.9 or string.find(nameLower, "wall") or string.find(nameLower, "barrier") or string.find(nameLower, "clip") or string.find(nameLower, "invisible") then
            obj.Transparency = 1
            return
        end

        local isBall = false
        for _, ballName in ipairs(BALL_GUESSES) do
            if obj.Name == ballName or string.find(nameLower, "ball") then
                isBall = true
                break
            end
        end

        local isCritical = string.find(nameLower, "indicator") or string.find(nameLower, "net") or string.find(nameLower, "court") or string.find(nameLower, "line")

        if isPlayerPart then
            if not (string.find(nameLower, "arm") or string.find(nameLower, "hand")) then
                obj.Material = Enum.Material.Metal
                obj.Color = Color3.fromRGB(15, 15, 15)
                obj.Reflectance = 0.3
            end
        elseif isBall then
            return
        elseif isCritical then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = Color3.fromRGB(48, 50, 52)
            obj.Reflectance = 0
        else
            if string.find(nameLower, "tree") or string.find(nameLower, "palm") or string.find(nameLower, "leaf") or string.find(nameLower, "house") or string.find(nameLower, "building") or string.find(nameLower, "prop") or string.find(nameLower, "grass") then
                obj.Transparency = 1
                obj.CanCollide = false
            else
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.Color = Color3.fromRGB(100, 100, 100)
            end
        end
    end
end

local function applyLightingSettings()
    pcall(function()
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("Atmosphere") or effect:IsA("Clouds") or effect:IsA("SunRaysEffect") then
                effect:Destroy()
            end
        end

        if Lighting:FindFirstChildOfClass("Sky") then
            Lighting:FindFirstChildOfClass("Sky"):Destroy()
        end

        local darkAtmosphere = Instance.new("Atmosphere")
        darkAtmosphere.Density = 1
        darkAtmosphere.Color = Color3.fromRGB(25, 25, 25)
        darkAtmosphere.Decay = Color3.fromRGB(20, 20, 20)
        darkAtmosphere.Glare = 0
        darkAtmosphere.Haze = 0
        darkAtmosphere.Parent = Lighting

        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            Terrain.Decoration = false
        end

        Lighting.GlobalShadows = false
        Lighting.ShadowSoftness = 0
        Lighting.ClockTime = 0
        Lighting.Brightness = 0
        Lighting.Ambient = Color3.fromRGB(50, 50, 50)
        Lighting.OutdoorAmbient = Color3.fromRGB(25, 25, 25)
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogEnd = 99999999

        SoundService.AmbientReverb = Enum.ReverbType.NoReverb
        SoundService.DistanceFactor = 0
        SoundService.DopplerScale = 0
    end)
end

SettingsLeft:AddToggle("PotatoOptimizer", {
    Text = "Potato Optimizer (Extreme)",
    Default = false,
    Callback = function(v)
        if v then
            getgenv().PotatoOptimizerLoaded = true
            pcall(function()
                for i, obj in ipairs(Workspace:GetDescendants()) do
                    if i % 300 == 0 then task.wait() end
                    processObject(obj)
                end
            end)
            applyLightingSettings()
            if not getgenv().PotatoOptimizerConnection then
                getgenv().PotatoOptimizerConnection = Workspace.DescendantAdded:Connect(function(obj)
                    task.wait()
                    pcall(processObject, obj)
                end)
            end
            task.spawn(function()
                while getgenv().PotatoOptimizerLoaded do
                    task.wait(5)
                    applyLightingSettings()
                end
            end)
        else
            getgenv().PotatoOptimizerLoaded = false
            if getgenv().PotatoOptimizerConnection then
                getgenv().PotatoOptimizerConnection:Disconnect()
                getgenv().PotatoOptimizerConnection = nil
            end
        end
    end
})

-- ==================== RENDER LOOP ====================
RunService.RenderStepped:Connect(function()
    if _G.HitboxEnabled then
        createOrUpdateHitboxes(_G.CurrentHitboxScale)
    end

    -- Facing Rays
    if _G.FacingRaysEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local isOpponent = (LocalPlayer.Team == nil or player.Team ~= LocalPlayer.Team)
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if isOpponent and hrp then
                    local rayPart = player.Character:FindFirstChild("OpponentFacingRay")
                    if not rayPart then
                        rayPart = Instance.new("Part")
                        rayPart.Name = "OpponentFacingRay"
                        rayPart.Anchored = true
                        rayPart.CanCollide = false
                        rayPart.CastShadow = false
                        rayPart.Material = Enum.Material.Neon
                        rayPart.Color = Color3.fromRGB(253, 8, 8)
                        rayPart.Size = Vector3.new(0.15, 0.15, 80)
                        rayPart.Parent = player.Character
                    end
                    rayPart.CFrame = hrp.CFrame * CFrame.new(0, 0, -40)
                else
                    if player.Character:FindFirstChild("OpponentFacingRay") then
                        player.Character.OpponentFacingRay:Destroy()
                    end
                end
            end
        end
    end

    -- Air Movement
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if _G.AirMoveEnabled and humanoid and hrp then
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                local cameraLook = Workspace.CurrentCamera.CFrame.LookVector
                local flattenedLook = Vector3.new(cameraLook.X, 0, cameraLook.Z).Unit
                if flattenedLook.Magnitude > 0 then
                    hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flattenedLook)
                end

                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    hrp.Velocity = Vector3.new(moveDir.X * _G.AirMoveSpeed, hrp.Velocity.Y, moveDir.Z * _G.AirMoveSpeed)
                end
            end
        end
    end
end)

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
SaveManager:SetFolder("CryptSec/VolleyballLegends")
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
