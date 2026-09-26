-- =============================================
-- IVORY HUB v14.1 - CENTUDOX + PREDICTION + TRACER
-- Made by Ivory
-- UI Refresh Edition
-- =============================================

print("🦷 Ivory Hub v14.1 loading...")
print("Made by Ivory")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VIM = VirtualInputManager

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local parent = gethui and gethui() or CoreGui
local old = parent:FindFirstChild("IvoryHub")
if old then old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = parent

local COLORS = {
    BLACK = Color3.fromRGB(7,7,7),
    DARK = Color3.fromRGB(13,13,13),
    DARKER = Color3.fromRGB(19,19,19),
    CARD = Color3.fromRGB(22,22,22),
    WHITE = Color3.fromRGB(245,245,245),
    GRAY = Color3.fromRGB(145,145,145),
    RED = Color3.fromRGB(255,50,50),
    GREEN = Color3.fromRGB(50,255,50),
    YELLOW = Color3.fromRGB(255,200,0),
    ACCENT = Color3.fromRGB(255,50,50),
    ACCENT_DIM = Color3.fromRGB(160,30,30),
    ACCENT_GLOW = Color3.fromRGB(255,80,80),
}

local function Corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = o
end

local function Stroke(o, c, t)
    local s = Instance.new("UIStroke")
    s.Color = c or Color3.fromRGB(40,40,40)
    s.Thickness = t or 1
    s.Parent = o
    return s
end

local function TweenIt(o, p, t)
    TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p):Play()
end

local function AttachClickAnim(btn)
    if not btn then return end
    btn.MouseButton1Down:Connect(function()
        pcall(function()
            TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5}):Play()
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
        end)
    end)
end

local function Text(parent, text, size, bold)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = COLORS.WHITE
    t.TextSize = size
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = parent
    return t
end

-- =============================================
-- FEATURES TABLE
-- =============================================
local Features = {
    SilentAim = false,
    SilentAimTarget = "Both",
    SilentAimMode = "360",
    SilentAimDistance = 500,
    SilentAimPrediction = 0.15,
    Tracer = false,
    TracerColor = "Red",
    TracerThickness = 1.5,
    SoruAim = false,
    SoruTarget = "Players",
    SoruMode = "360",
    SoruRange = 150,
    FastAttack = false,
    FastAttackRange = 60,
    FastAttackSpeed = 0.05,
    GunFastAttack = false,
    GunFastAttackRange = 60,
    GunFastAttackSpeed = 0.08,
    Hitbox = false,
    HitboxSize = 5,
    HideBox = false,
    FOVCircle = false,
    FOVRadius = 150,
    FOVMode = "V1",
    Macro = false,
    MaxRange = 1000,
}

local CONFIG_FOLDER = "IvoryHub"
local CONFIG_FILE = CONFIG_FOLDER .. "/config.txt"
local MACRO_FILE = CONFIG_FOLDER .. "/macro.txt"

pcall(function()
    if isfolder and makefolder and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end)

local function SaveConfig()
    local data = ""
    for k, v in pairs(Features) do
        local val = tostring(v)
        if type(v) == "boolean" then val = v and "true" or "false" end
        data = data .. k .. "=" .. val .. "\n"
    end
    pcall(function() if writefile then writefile(CONFIG_FILE, data) end end)
end

local function LoadConfig()
    local loaded = {}
    pcall(function()
        if readfile and isfile and isfile(CONFIG_FILE) then
            local content = readfile(CONFIG_FILE)
            for line in string.gmatch(content, "[^\r\n]+") do
                local k, v = string.match(line, "^([^=]+)=(.*)$")
                if k and v then
                    if v == "true" then loaded[k] = true
                    elseif v == "false" then loaded[k] = false
                    elseif tonumber(v) then loaded[k] = tonumber(v)
                    else loaded[k] = v end
                end
            end
        end
    end)
    for k, v in pairs(loaded) do
        if Features[k] ~= nil and type(v) ~= "boolean" then Features[k] = v end
    end
end

local function ResetConfig()
    for k in pairs(Features) do if type(Features[k]) == "boolean" then Features[k] = false end end
    Features.SilentAimTarget = "Both"
    Features.SilentAimMode = "360"
    Features.SilentAimDistance = 500
    Features.SilentAimPrediction = 0.15
    Features.TracerColor = "Red"
    Features.TracerThickness = 1.5
    Features.SoruTarget = "Players"
    Features.SoruMode = "360"
    Features.SoruRange = 150
    Features.FastAttackRange = 60
    Features.FastAttackSpeed = 0.05
    Features.GunFastAttackRange = 60
    Features.GunFastAttackSpeed = 0.08
    Features.HitboxSize = 5
    Features.FOVRadius = 150
    Features.FOVMode = "V1"
    Features.MaxRange = 1000
    SaveConfig()
end

LoadConfig()

-- =============================================
-- FPS BOOST
-- =============================================
local function ApplyFPSBoost()
    pcall(function()
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0

        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            pcall(function()
                terrain.Decoration = false
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
            end)
        end

        local function optimize(obj)
            if obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")
               or obj:IsA("Beam") or obj:IsA("Trail") then
                pcall(function() obj.Enabled = false end)
            elseif obj:IsA("PostEffect") then
                pcall(function() obj.Enabled = false end)
            elseif obj:IsA("ParticleEmitter") then
                pcall(function()
                    obj.Rate = math.min(obj.Rate, 12)
                    obj.LightInfluence = 1
                end)
            elseif obj:IsA("BasePart") then
                pcall(function() obj.CastShadow = false end)
            end
        end

        for _, obj in ipairs(game:GetDescendants()) do optimize(obj) end
        game.DescendantAdded:Connect(function(obj) task.defer(function() optimize(obj) end) end)

        task.spawn(function()
            while true do
                Lighting.Brightness = 3
                Lighting.GlobalShadows = false
                Lighting.EnvironmentDiffuseScale = 0
                Lighting.EnvironmentSpecularScale = 0
                Lighting.FogEnd = 100000
                task.wait(2)
            end
        end)
    end)
end

-- =============================================
-- SHADERS
-- =============================================
local function ApplyShaders()
    pcall(function()
        local Terrain = Workspace:FindFirstChildOfClass("Terrain")
        pcall(function() Lighting.Technology = Enum.Technology.Future end)
        Lighting.Brightness = 2
        Lighting.ClockTime = 16.2
        Lighting.GlobalShadows = true
        Lighting.ShadowSoftness = 0.38
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
        Lighting.ExposureCompensation = 0.05
        Lighting.FogColor = Color3.fromRGB(185, 201, 214)
        Lighting.FogStart = 55
        Lighting.FogEnd = 1250

        local Atmosphere = Lighting:FindFirstChild("AtmosphericRealism") or Instance.new("Atmosphere")
        Atmosphere.Name = "AtmosphericRealism"
        Atmosphere.Parent = Lighting
        Atmosphere.Density = 0.34
        Atmosphere.Offset = 0.08
        Atmosphere.Color = Color3.fromRGB(190, 210, 225)
        Atmosphere.Decay = Color3.fromRGB(120, 135, 150)
        Atmosphere.Glare = 0.25
        Atmosphere.Haze = 2.15

        local CC = Lighting:FindFirstChild("AtmosphericColor") or Instance.new("ColorCorrectionEffect")
        CC.Name = "AtmosphericColor"
        CC.Parent = Lighting
        CC.Brightness = 0.025
        CC.Contrast = 0.07
        CC.Saturation = -0.02
        CC.TintColor = Color3.fromRGB(255, 250, 242)

        local SR = Lighting:FindFirstChild("AtmosphericSun") or Instance.new("SunRaysEffect")
        SR.Name = "AtmosphericSun"
        SR.Parent = Lighting
        SR.Intensity = 0.16
        SR.Spread = 0.88

        local BL = Lighting:FindFirstChild("AtmosphericBloom") or Instance.new("BloomEffect")
        BL.Name = "AtmosphericBloom"
        BL.Parent = Lighting
        BL.Intensity = 0.16
        BL.Size = 32
        BL.Threshold = 1.35

        local DOF = Lighting:FindFirstChild("AtmosphericDOF") or Instance.new("DepthOfFieldEffect")
        DOF.Name = "AtmosphericDOF"
        DOF.Parent = Lighting
        DOF.FocusDistance = 120
        DOF.InFocusRadius = 75
        DOF.NearIntensity = 0.025
        DOF.FarIntensity = 0.075

        if Terrain then
            local C = Terrain:FindFirstChild("AtmosphericClouds") or Instance.new("Clouds")
            C.Name = "AtmosphericClouds"
            C.Parent = Terrain
            C.Cover = 0.46
            C.Density = 0.48
            C.Color = Color3.fromRGB(228, 232, 235)
            Terrain.WaterWaveSize = 0.4
            Terrain.WaterWaveSpeed = 9
            Terrain.WaterReflectance = 0.42
            Terrain.WaterTransparency = 0.2
            Terrain.WaterColor = Color3.fromRGB(55, 110, 135)
        end
    end)
end

-- =============================================
-- FOV
-- =============================================
local FOVGui, FOVRing = nil, nil

local function getFOVCenter()
    if Features.FOVMode == "V2" then return UserInputService:GetMouseLocation() end
    return Camera.ViewportSize / 2
end

local function isInFOV(hrp)
    if not hrp then return false end
    local sp, on = Camera:WorldToViewportPoint(hrp.Position)
    if not on then return false end
    local c = getFOVCenter()
    return (Vector2.new(sp.X, sp.Y) - c).Magnitude <= Features.FOVRadius
end

local function UpdateFOVCircle()
    if Features.FOVCircle then
        if not FOVGui or not FOVGui.Parent then
            FOVGui = Instance.new("ScreenGui")
            FOVGui.Name = "IvoryFOV"
            FOVGui.ResetOnSpawn = false
            FOVGui.IgnoreGuiInset = true
            FOVGui.DisplayOrder = 1
            FOVGui.Parent = parent
            FOVRing = Instance.new("Frame")
            FOVRing.AnchorPoint = Vector2.new(0.5, 0.5)
            FOVRing.BackgroundTransparency = 1
            FOVRing.BorderSizePixel = 0
            FOVRing.ZIndex = 100
            FOVRing.Parent = FOVGui
            Corner(FOVRing, 999)
            local s = Instance.new("UIStroke")
            s.Thickness = 2
            s.Color = COLORS.ACCENT
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Parent = FOVRing
        end
        local c = getFOVCenter()
        local d = math.floor(Features.FOVRadius * 2)
        FOVRing.Position = UDim2.new(0, c.X, 0, c.Y)
        FOVRing.Size = UDim2.fromOffset(d, d)
        FOVRing.Visible = true
    elseif FOVRing then
        FOVRing.Visible = false
    end
end

RunService.RenderStepped:Connect(function() pcall(UpdateFOVCircle) end)

-- =============================================
-- NPC DETECTION
-- =============================================
local function isCombatNPC(model, hum, root)
    if not model or not hum or not root then return false end
    if hum.Health <= 0 then return false end
    local n = string.lower(model.Name)
    local block = {"shop","seller","dealer","quest","trainer","teacher","merchant",
        "gacha","title","dialog","manager","vendor","guide","helper","boat","customer",
        "spawn","luxury","bartender","captain","toribro","indra","nami","ability",
        "sword dealer","weapon","blox fruit","crew","quest giver","town","citizen"}
    for _, w in ipairs(block) do
        if string.find(n, w, 1, true) then return false end
    end
    if model:FindFirstChildWhichIsA("ProximityPrompt", true) then return false end
    if model:FindFirstChildWhichIsA("ClickDetector", true) then return false end
    if hum.MaxHealth < 20 then return false end
    return true
end

local function getHitboxPart(model)
    local names = {"Head","UpperTorso","Torso","HumanoidRootPart","Root","Hitbox","Chest"}
    for _, n in ipairs(names) do
        local p = model:FindFirstChild(n, true)
        if p and p:IsA("BasePart") then return p end
    end
    for _, p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") then return p end
    end
    return nil
end

local NPC_FOLDERS = {"Enemies","Enemy","Monsters","Monster","Mobs","Mob","Bosses","Boss","NPCs","Npcs"}
local CENTUDOX_FOLDERS = {"Enemies","Characters"}

local function GetNearestTarget(targetType, mode, maxDist)
    local char = player.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end

    local best, bestPart, bestDist = nil, nil, math.huge
    local maxRange = maxDist or Features.MaxRange or 1000
    local origin = root.Position

    local function consider(hum, hrp, part)
        if not hum or not hrp then return end
        if hum.Health <= 0 then return end
        local dist = (hrp.Position - origin).Magnitude
        if dist > maxRange then return end
        local ok = (mode ~= "FOV") or isInFOV(hrp)
        if not ok then return end
        if dist < bestDist then
            bestDist = dist
            best = hrp
            bestPart = part or hrp
        end
    end

    if targetType == "Players" or targetType == "Both" then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local part = plr.Character:FindFirstChild("Head") or hrp
                consider(hum, hrp, part)
            end
        end
    end

    if targetType == "NPCs" or targetType == "Both" then
        for _, folderName in ipairs(CENTUDOX_FOLDERS) do
            local folder = workspace:FindFirstChild(folderName)
            if folder then
                for _, model in ipairs(folder:GetChildren()) do
                    if model ~= char and model:IsA("Model") then
                        local hum = model:FindFirstChildOfClass("Humanoid")
                        local hrp = model:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and isCombatNPC(model, hum, hrp) then
                            consider(hum, hrp, getHitboxPart(model))
                        end
                    end
                end
            end
        end

        for _, name in ipairs(NPC_FOLDERS) do
            local folder = workspace:FindFirstChild(name)
            if folder then
                for _, npc in pairs(folder:GetChildren()) do
                    if npc:IsA("Model") then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        local hrp = npc:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.Health > 0 and isCombatNPC(npc, hum, hrp) then
                            consider(hum, hrp, getHitboxPart(npc))
                        end
                    end
                end
            end
        end
    end

    return best, bestPart
end

-- =============================================
-- GUN DETECTION
-- =============================================
local GUN_WORDS = {
    "flintlock","musket","slingshot","cannon","bazooka","rifle","bow",
    "kabucha","serpent","dragonstorm","guitar","pistol","gun","acidum",
    "skull","dual","revolver","smoke","grenade","spike","bomb",
}

local function IsHoldingGun()
    local char = player.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    local n = string.lower(tool.Name)
    for _, w in ipairs(GUN_WORDS) do
        if string.find(n, w, 1, true) then return true end
    end
    if tool:FindFirstChild("Shoot") or tool:FindFirstChild("Fire") then return true end
    return false
end
-- =============================================
-- CENTUDOX SILENT AIM + PREDICTION
-- =============================================
local TargetPos = nil
local TargetRealPos = nil
local TargetPart = nil
local TargetHRP = nil
local TargetModel = nil

local function GetPing()
    local ok, p = pcall(function() return player:GetNetworkPing() end)
    if ok and type(p) == "number" and p > 0 then return p end
    return 0.05
end

RunService.RenderStepped:Connect(function()
    if not Features.SilentAim then
        TargetPos, TargetRealPos, TargetPart, TargetHRP, TargetModel = nil, nil, nil, nil, nil
        return
    end

    local hrp, part = GetNearestTarget(Features.SilentAimTarget, Features.SilentAimMode, Features.SilentAimDistance)
    if hrp and part then
        TargetPart = part
        TargetHRP = hrp
        TargetModel = hrp.Parent
        TargetRealPos = part.Position

        local pred = Features.SilentAimPrediction or 0
        if pred > 0 then
            local vel = part.AssemblyLinearVelocity
            if not vel or vel.Magnitude < 0.1 then
                vel = hrp.AssemblyLinearVelocity
            end
            if vel then
                local pingComp = GetPing() * 0.5
                local totalPred = pred + pingComp
                local pos = part.Position + (vel * totalPred)
                pos = pos + Vector3.new(0, 0.5 * (totalPred ^ 2) * workspace.Gravity * 0.1, 0)
                TargetPos = pos
            else
                TargetPos = part.Position
            end
        else
            TargetPos = part.Position
        end
    else
        TargetPos, TargetRealPos, TargetPart, TargetHRP, TargetModel = nil, nil, nil, nil, nil
    end
end)

pcall(function()
    local mt = getrawmetatable(game)
    if not mt then return end
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if not checkcaller() and Features.SilentAim and TargetPos then
            if method == "FireServer" or method == "InvokeServer" then
                local nm = string.lower(tostring(self.Name or ""))
                local skip = {"commf_","commu_","commt_","commr_","commun_"}
                local ok = true
                for _, s in ipairs(skip) do
                    if string.find(nm, s, 1, true) then ok = false break end
                end
                if ok then
                    local rewritten = table.pack(table.unpack(args))
                    local changed = false
                    for i, v in ipairs(rewritten) do
                        if typeof(v) == "Vector3" then
                            rewritten[i] = TargetPos
                            changed = true
                        elseif typeof(v) == "CFrame" then
                            rewritten[i] = CFrame.new(TargetPos)
                            changed = true
                        end
                    end
                    if changed then
                        return oldNamecall(self, table.unpack(rewritten, 1, rewritten.n))
                    end
                end
            end
        end

        return oldNamecall(self, ...)
    end
    setreadonly(mt, true)
end)

-- =============================================
-- TRACER
-- =============================================
local TRACER_MAP = {
    Red    = Color3.fromRGB(255, 50, 50),
    Green  = Color3.fromRGB(50, 255, 50),
    Yellow = Color3.fromRGB(255, 200, 0),
    White  = Color3.fromRGB(245, 245, 245),
    Blue   = Color3.fromRGB(80, 150, 255),
    Cyan   = Color3.fromRGB(0, 255, 255),
    Purple = Color3.fromRGB(180, 80, 255),
}
local TRACER_COLOR = TRACER_MAP[Features.TracerColor] or TRACER_MAP.Red

local TracerFolder = Instance.new("Folder")
TracerFolder.Name = "IvoryTracerFolder"
TracerFolder.Parent = workspace

local BeamTracer, BeamAtt0, BeamAtt1 = nil, nil, nil
local PartTracer = nil

local function getTracerOriginPart()
    local char = player.Character
    if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle")
        if handle and handle:IsA("BasePart") then return handle end
    end
    return char:FindFirstChild("RightHand")
        or char:FindFirstChild("LeftHand")
        or char:FindFirstChild("Head")
        or char:FindFirstChild("HumanoidRootPart")
end

local function destroyTracer()
    if BeamTracer then pcall(function() BeamTracer:Destroy() end) BeamTracer = nil end
    if BeamAtt0 then pcall(function() BeamAtt0:Destroy() end) BeamAtt0 = nil end
    if BeamAtt1 then pcall(function() BeamAtt1:Destroy() end) BeamAtt1 = nil end
    if PartTracer then pcall(function() PartTracer:Destroy() end) PartTracer = nil end
end

local function ensureBeamTracer()
    local origin = getTracerOriginPart()
    if not origin then return false end

    if BeamTracer and BeamTracer.Parent then
        if BeamAtt0.Parent ~= origin then BeamAtt0.Parent = origin end
        if BeamAtt1.Parent ~= origin then BeamAtt1.Parent = origin end
        return true
    end

    BeamAtt0 = Instance.new("Attachment")
    BeamAtt0.Name = "IvoryTracerA0"
    BeamAtt0.Parent = origin

    BeamAtt1 = Instance.new("Attachment")
    BeamAtt1.Name = "IvoryTracerA1"
    BeamAtt1.Parent = origin

    BeamTracer = Instance.new("Beam")
    BeamTracer.Name = "IvoryTracerBeam"
    BeamTracer.Attachment0 = BeamAtt0
    BeamTracer.Attachment1 = BeamAtt1
    BeamTracer.Color = ColorSequence.new(TRACER_COLOR)
    BeamTracer.Transparency = NumberSequence.new(0.25)
    BeamTracer.Width0 = Features.TracerThickness or 1.5
    BeamTracer.Width1 = Features.TracerThickness or 1.5
    BeamTracer.FaceCamera = true
    BeamTracer.LightEmission = 1
    BeamTracer.LightInfluence = 0
    BeamTracer.Segments = 1
    BeamTracer.Enabled = false
    BeamTracer.Parent = origin
    return true
end

local function hideTracer()
    if BeamTracer then BeamTracer.Enabled = false end
    if PartTracer then PartTracer.Transparency = 1 end
end

local function getOrCreatePartTracer()
    if PartTracer and PartTracer.Parent then return PartTracer end
    PartTracer = Instance.new("Part")
    PartTracer.Name = "IvoryTracerPart"
    PartTracer.Anchored = true
    PartTracer.CanCollide = false
    PartTracer.CanQuery = false
    PartTracer.CanTouch = false
    PartTracer.CastShadow = false
    PartTracer.Material = Enum.Material.Neon
    PartTracer.Color = TRACER_COLOR
    PartTracer.Transparency = 1
    PartTracer.Size = Vector3.new(0.05, 0.05, 1)
    PartTracer.Parent = TracerFolder
    return PartTracer
end

local function updatePartTracer(fromPos, toPos, thickness, color)
    local p = getOrCreatePartTracer()
    local diff = toPos - fromPos
    local length = diff.Magnitude
    if length < 0.1 then
        p.Transparency = 1
        return
    end
    local mid = fromPos + diff * 0.5
    p.CFrame = CFrame.lookAt(mid, toPos)
    p.Size = Vector3.new(thickness * 0.1, thickness * 0.1, length)
    p.Color = color
    p.Transparency = 0.25
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not Features.SilentAim or not Features.Tracer or not TargetPos then
            hideTracer()
            return
        end

        local originPart = getTracerOriginPart()
        if not originPart then hideTracer() return end

        local fromPos = originPart.Position
        local toPos = TargetPos
        local thickness = Features.TracerThickness or 1.5

        if ensureBeamTracer() and BeamTracer and BeamAtt0 and BeamAtt1 then
            BeamAtt0.WorldPosition = fromPos
            BeamAtt1.WorldPosition = toPos
            BeamTracer.Color = ColorSequence.new(TRACER_COLOR)
            BeamTracer.Width0 = thickness
            BeamTracer.Width1 = thickness
            BeamTracer.Enabled = true
            if PartTracer then PartTracer.Transparency = 1 end
        else
            if BeamTracer then BeamTracer.Enabled = false end
            updatePartTracer(fromPos, toPos, thickness, TRACER_COLOR)
        end
    end)
end)

player.CharacterAdded:Connect(function()
    destroyTracer()
    hideTracer()
end)

-- =============================================
-- HITBOX
-- =============================================
local HitboxOriginals = {}
local HitboxBoxes = {}

local function removeBox(model)
    if HitboxBoxes[model] then
        pcall(function() HitboxBoxes[model]:Destroy() end)
        HitboxBoxes[model] = nil
    end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if hrp then
        local stray = hrp:FindFirstChild("IvoryHitboxBox")
        if stray then pcall(function() stray:Destroy() end) end
    end
end

local function applyHitbox(model)
    if not model or model == player.Character then return end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then removeBox(model) return end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local dist = (hrp.Position - myRoot.Position).Magnitude
    if dist > 500 then removeBox(model) return end

    if not HitboxOriginals[hrp] then
        HitboxOriginals[hrp] = { size = hrp.Size }
    end

    local size = Features.HitboxSize
    pcall(function() hrp.Size = Vector3.new(size, size, size) end)

    if Features.HideBox then
        removeBox(model)
    else
        if not HitboxBoxes[model] or not HitboxBoxes[model].Parent then
            local box = Instance.new("SelectionBox")
            box.Name = "IvoryHitboxBox"
            box.Adornee = hrp
            box.LineThickness = 0.05
            box.Color3 = COLORS.ACCENT
            box.Transparency = 0.3
            box.SurfaceTransparency = 1
            box.Parent = hrp
            HitboxBoxes[model] = box
        end
    end
end

local function clearAllHitboxes()
    for hrp, data in pairs(HitboxOriginals) do
        pcall(function() hrp.Size = data.size end)
    end
    HitboxOriginals = {}
    for model, box in pairs(HitboxBoxes) do
        pcall(function() box:Destroy() end)
    end
    HitboxBoxes = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "IvoryHitboxBox" then
            pcall(function() obj:Destroy() end)
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not Features.Hitbox then
        if next(HitboxOriginals) ~= nil then clearAllHitboxes() end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            pcall(applyHitbox, plr.Character)
        end
    end
end)

player.CharacterAdded:Connect(function() clearAllHitboxes() end)

-- =============================================
-- ATTACK REMOTES
-- =============================================
local RegisterAttack, RegisterHit
task.spawn(function()
    local modules = ReplicatedStorage:WaitForChild("Modules", 10)
    if not modules then return end
    local net = modules:WaitForChild("Net", 10)
    if not net then return end
    RegisterAttack = net:WaitForChild("RE/RegisterAttack", 10)
    RegisterHit = net:WaitForChild("RE/RegisterHit", 10)
end)

local function fireHit(target)
    if not RegisterAttack or not RegisterHit then return end
    pcall(function()
        RegisterAttack:FireServer()
        if target then
            local hitParts = {}
            for _, part in ipairs(target.model:GetDescendants()) do
                if part:IsA("BasePart") then hitParts[part] = true end
            end
            RegisterHit:FireServer(target.root, hitParts)
        end
    end)
end

local function getTargetsInRange(range)
    local list = {}
    local myChar = player.Character
    if not myChar then return list end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return list end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                local dist = (hrp.Position - myRoot.Position).Magnitude
                if dist <= range then
                    table.insert(list, {model = plr.Character, root = hrp, dist = dist})
                end
            end
        end
    end

    for _, name in ipairs(NPC_FOLDERS) do
        local folder = workspace:FindFirstChild(name)
        if folder then
            for _, npc in pairs(folder:GetChildren()) do
                if npc:IsA("Model") then
                    local hum = npc:FindFirstChildOfClass("Humanoid")
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and hrp and isCombatNPC(npc, hum, hrp) then
                        local dist = (hrp.Position - myRoot.Position).Magnitude
                        if dist <= range then
                            table.insert(list, {model = npc, root = hrp, dist = dist})
                        end
                    end
                end
            end
        end
    end
    return list
end

-- =============================================
-- FAST ATTACK
-- =============================================
local FastAttack = (function()
    local module = {}
    local conn, last = nil, 0
    function module:SetEnabled(state)
        if state and not conn then
            conn = RunService.Heartbeat:Connect(function()
                if not Features.FastAttack then return end
                local speed = Features.FastAttackSpeed or 0.05
                if tick() - last < speed then return end
                last = tick()
                local targets = getTargetsInRange(Features.FastAttackRange or 60)
                if #targets == 0 then fireHit(nil) return end
                table.sort(targets, function(a, b) return a.dist < b.dist end)
                for _, t in ipairs(targets) do fireHit(t) end
            end)
        elseif not state and conn then
            conn:Disconnect() conn = nil
        end
    end
    return module
end)()

local GunFastAttack = (function()
    local module = {}
    local conn, last = nil, 0
    function module:SetEnabled(state)
        if state and not conn then
            conn = RunService.Heartbeat:Connect(function()
                if not Features.GunFastAttack then return end
                if not IsHoldingGun() then return end
                local speed = Features.GunFastAttackSpeed or 0.08
                if tick() - last < speed then return end
                last = tick()
                local targets = getTargetsInRange(Features.GunFastAttackRange or 60)
                if #targets == 0 then fireHit(nil) return end
                table.sort(targets, function(a, b) return a.dist < b.dist end)
                for _, t in ipairs(targets) do fireHit(t) end
            end)
        elseif not state and conn then
            conn:Disconnect() conn = nil
        end
    end
    return module
end)()

-- =============================================
-- SORU
-- =============================================
local SoruCooldown = 0
local FLASHSTEP_KEYWORDS = {"flashstep","soru","skywalk","geppo","flash step","flash_step"}
local FLASHSTEP_IDS = {"17555632156","616006778","1846164274","1846163351","11420797633"}
local DASH_EXCLUDE = {"dash","dodge","roll","sidestep"}

local function isFlashstepAnim(track)
    local n = string.lower(track.Name or "")
    local id = tostring(track.Animation and track.Animation.AnimationId or "")
    for _, w in ipairs(DASH_EXCLUDE) do
        if string.find(n, w, 1, true) then return false end
    end
    for _, w in ipairs(FLASHSTEP_KEYWORDS) do
        if string.find(n, w, 1, true) then return true end
    end
    for _, w in ipairs(FLASHSTEP_IDS) do
        if string.find(id, w, 1, true) then return true end
    end
    return false
end

local function DoSoruTeleport()
    if not Features.SoruAim then return end
    if tick() < SoruCooldown then return end
    local target = GetNearestTarget(Features.SoruTarget, Features.SoruMode, Features.SoruRange)
    if not target then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        local behind = target.CFrame.LookVector * -3
        hrp.CFrame = CFrame.new(target.Position + behind + Vector3.new(0, 3, 0))
    end)
    SoruCooldown = tick() + 0.8
end

local function MonitorFlashstep(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.AnimationPlayed:Connect(function(track)
        if not Features.SoruAim then return end
        if tick() < SoruCooldown then return end
        if isFlashstepAnim(track) then DoSoruTeleport() end
    end)
end

player.CharacterAdded:Connect(function(c) task.wait(0.5) MonitorFlashstep(c) end)
if player.Character then task.wait(0.5) MonitorFlashstep(player.Character) end

-- =============================================
-- MACRO (LEGACY — kept for compatibility, replaced by Smart Macro below)
-- =============================================
local MacroRunning = false
local function StopMacro()
    MacroRunning = false
end

-- =============================================
-- UI — REFRESHED LOOK
-- =============================================

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "IvoryToggle"
ToggleBtn.Size = UDim2.fromOffset(46, 46)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -23)
ToggleBtn.BackgroundColor3 = COLORS.BLACK
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "I"
ToggleBtn.TextColor3 = COLORS.WHITE
ToggleBtn.TextSize = 22
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = Gui
Corner(ToggleBtn, 12)
local toggleStroke = Stroke(ToggleBtn, COLORS.ACCENT, 2)

local toggleGrad = Instance.new("UIGradient")
toggleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
toggleGrad.Rotation = 45
toggleGrad.Parent = ToggleBtn

local toggleGlow = Instance.new("ImageLabel")
toggleGlow.Name = "ToggleGlow"
toggleGlow.Size = UDim2.new(1, 30, 1, 30)
toggleGlow.Position = UDim2.new(0, -15, 0, -15)
toggleGlow.BackgroundTransparency = 1
toggleGlow.Image = "rbxassetid://5028857084"
toggleGlow.ImageColor3 = COLORS.ACCENT
toggleGlow.ImageTransparency = 0.5
toggleGlow.ZIndex = ToggleBtn.ZIndex - 1
toggleGlow.Parent = ToggleBtn

task.spawn(function()
    while ToggleBtn and ToggleBtn.Parent do
        TweenService:Create(toggleGlow, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.15
        }):Play()
        task.wait(1.6)
        TweenService:Create(toggleGlow, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.6
        }):Play()
        task.wait(1.6)
    end
end)

local toggleDrag = {active=false, moved=false, startPos=nil, startMouse=nil, wasOpen=false}

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDrag.active = true
        toggleDrag.moved = false
        toggleDrag.startMouse = input.Position
        toggleDrag.startPos = ToggleBtn.Position
    end
end)

ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDrag.active = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not toggleDrag.active then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - toggleDrag.startMouse
    if delta.Magnitude > 6 then toggleDrag.moved = true end
    ToggleBtn.Position = UDim2.new(
        toggleDrag.startPos.X.Scale, toggleDrag.startPos.X.Offset + delta.X,
        toggleDrag.startPos.Y.Scale, toggleDrag.startPos.Y.Offset + delta.Y)
end)

local Main = Instance.new("Frame")
Main.Name = "IvoryMain"
Main.Size = UDim2.new(0, 500, 0, 340)
Main.Position = UDim2.new(0.5, -250, 0.5, -170)
Main.BackgroundColor3 = COLORS.BLACK
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = Gui
Corner(Main, 16)
local mainStroke = Stroke(Main, COLORS.ACCENT, 1.5)

local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(7, 7, 7)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 0)),
})
mainGrad.Rotation = 135
mainGrad.Parent = Main

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.Position = UDim2.new(0, -30, 0, -30)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = COLORS.ACCENT
shadow.ImageTransparency = 0.65
shadow.ZIndex = Main.ZIndex - 1
shadow.Parent = Main

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 48)
Top.BackgroundColor3 = COLORS.DARK
Top.BorderSizePixel = 0
Top.Parent = Main
Corner(Top, 16)

local topGrad = Instance.new("UIGradient")
topGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 5, 5)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(13, 13, 13)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 13, 13)),
})
topGrad.Rotation = 0
topGrad.Parent = Top

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, -24, 0, 1)
topLine.Position = UDim2.new(0, 12, 1, -1)
topLine.BackgroundColor3 = COLORS.ACCENT
topLine.BackgroundTransparency = 0.6
topLine.BorderSizePixel = 0
topLine.Parent = Top

local logoDot = Instance.new("Frame")
logoDot.Size = UDim2.fromOffset(8, 8)
logoDot.Position = UDim2.new(0, 15, 0.5, -4)
logoDot.BackgroundColor3 = COLORS.ACCENT
logoDot.BorderSizePixel = 0
logoDot.Parent = Top
Corner(logoDot, 20)

local logoDotGlow = Instance.new("ImageLabel")
logoDotGlow.Size = UDim2.new(1, 20, 1, 20)
logoDotGlow.Position = UDim2.new(0, -10, 0, -10)
logoDotGlow.BackgroundTransparency = 1
logoDotGlow.Image = "rbxassetid://5028857084"
logoDotGlow.ImageColor3 = COLORS.ACCENT
logoDotGlow.ImageTransparency = 0.3
logoDotGlow.ZIndex = logoDot.ZIndex - 1
logoDotGlow.Parent = logoDot

local Title = Text(Top, "IVORY", 18, true)
Title.Position = UDim2.new(0, 30, 0, 6)
Title.Size = UDim2.new(0, 100, 0, 22)

local SubTitle = Text(Top, "HUB", 9, false)
SubTitle.TextColor3 = COLORS.ACCENT
SubTitle.Position = UDim2.new(0, 31, 0, 28)
SubTitle.Size = UDim2.new(0, 60, 0, 12)

local versionBadge = Instance.new("Frame")
versionBadge.Size = UDim2.fromOffset(46, 16)
versionBadge.Position = UDim2.new(0, 108, 0, 16)
versionBadge.BackgroundColor3 = COLORS.DARKER
versionBadge.BorderSizePixel = 0
versionBadge.Parent = Top
Corner(versionBadge, 20)
Stroke(versionBadge, COLORS.ACCENT, 1)

local versionLbl = Instance.new("TextLabel")
versionLbl.BackgroundTransparency = 1
versionLbl.Size = UDim2.new(1, 0, 1, 0)
versionLbl.Text = "v14.1"
versionLbl.TextColor3 = COLORS.ACCENT
versionLbl.TextSize = 9
versionLbl.Font = Enum.Font.GothamBold
versionLbl.Parent = versionBadge

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -36, 0.5, -14)
Close.BackgroundColor3 = COLORS.DARKER
Close.Text = "×"
Close.TextColor3 = COLORS.WHITE
Close.TextSize = 18
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.AutoButtonColor = false
Close.Parent = Top
Corner(Close, 8)
Stroke(Close, Color3.fromRGB(50,50,50), 1)
AttachClickAnim(Close)
Close.MouseEnter:Connect(function() TweenIt(Close, {BackgroundColor3 = COLORS.ACCENT}) end)
Close.MouseLeave:Connect(function() TweenIt(Close, {BackgroundColor3 = COLORS.DARKER}) end)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 28, 0, 28)
Minimize.Position = UDim2.new(1, -70, 0.5, -14)
Minimize.BackgroundColor3 = COLORS.DARKER
Minimize.Text = "—"
Minimize.TextColor3 = COLORS.WHITE
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.BorderSizePixel = 0
Minimize.AutoButtonColor = false
Minimize.Parent = Top
Corner(Minimize, 8)
Stroke(Minimize, Color3.fromRGB(50,50,50), 1)
AttachClickAnim(Minimize)
Minimize.MouseEnter:Connect(function() TweenIt(Minimize, {BackgroundColor3 = COLORS.ACCENT}) end)
Minimize.MouseLeave:Connect(function() TweenIt(Minimize, {BackgroundColor3 = COLORS.DARKER}) end)

ToggleBtn.MouseButton1Click:Connect(function()
    if toggleDrag.moved then return end
    Main.Visible = not Main.Visible
    if Main.Visible then
        Main.Size = UDim2.new(0, 0, 0, 0)
        TweenIt(Main, {Size = UDim2.new(0, 500, 0, 340)}, 0.28)
        TweenIt(ToggleBtn, {BackgroundColor3 = COLORS.ACCENT, TextColor3 = COLORS.BLACK})
    else
        TweenIt(ToggleBtn, {BackgroundColor3 = COLORS.BLACK, TextColor3 = COLORS.WHITE})
    end
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 95, 1, -58)
Sidebar.Position = UDim2.new(0, 8, 0, 54)
Sidebar.BackgroundColor3 = COLORS.DARK
Sidebar.BackgroundTransparency = 0.15
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Corner(Sidebar, 12)
Stroke(Sidebar, Color3.fromRGB(35,35,35), 1)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 3)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = Sidebar

local Pad = Instance.new("UIPadding")
Pad.PaddingTop = UDim.new(0, 6)
Pad.PaddingLeft = UDim.new(0, 4)
Pad.PaddingRight = UDim.new(0, 4)
Pad.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -111, 1, -58)
Content.Position = UDim2.new(0, 103, 0, 54)
Content.BackgroundColor3 = COLORS.DARK
Content.BackgroundTransparency = 0.15
Content.BorderSizePixel = 0
Content.Parent = Main
Corner(Content, 12)
Stroke(Content, Color3.fromRGB(35,35,35), 1)

local Pages = {}
local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = COLORS.ACCENT
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 4)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = page
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, l.AbsoluteContentSize.Y + 10)
    end)
    Pages[name] = page
    return page
end

local function Section(parent, text)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 20)
    wrap.BackgroundTransparency = 1
    wrap.Parent = parent

    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = COLORS.ACCENT
    l.TextSize = 9
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Size = UDim2.new(1, 0, 0, 12)
    l.Position = UDim2.new(0, 0, 0, 0)
    l.Parent = wrap

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 16)
    line.BackgroundColor3 = COLORS.ACCENT
    line.BackgroundTransparency = 0.7
    line.BorderSizePixel = 0
    line.Parent = wrap

    return wrap
end

local function Button(parent, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = COLORS.CARD
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = COLORS.WHITE
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    b.Parent = parent
    Corner(b, 8)
    local st = Stroke(b, Color3.fromRGB(35,35,35), 1)
    AttachClickAnim(b)
    b.MouseEnter:Connect(function()
        TweenIt(b, {BackgroundColor3 = Color3.fromRGB(32,32,32)})
        TweenIt(st, {Color = COLORS.ACCENT_DIM})
    end)
    b.MouseLeave:Connect(function()
        TweenIt(b, {BackgroundColor3 = COLORS.CARD})
        TweenIt(st, {Color = Color3.fromRGB(35,35,35)})
    end)
    b.MouseButton1Click:Connect(cb)
    return b
end

local function CycleButton(parent, text, options, default, cb)
    local idx = 1
    for i, o in ipairs(options) do if o == default then idx = i break end end
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = COLORS.CARD
    b.BorderSizePixel = 0
    b.Text = text .. ": " .. options[idx]
    b.TextColor3 = COLORS.WHITE
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    b.Parent = parent
    Corner(b, 8)
    local st = Stroke(b, Color3.fromRGB(35,35,35), 1)
    AttachClickAnim(b)
    b.MouseEnter:Connect(function()
        TweenIt(b, {BackgroundColor3 = Color3.fromRGB(32,32,32)})
        TweenIt(st, {Color = COLORS.ACCENT_DIM})
    end)
    b.MouseLeave:Connect(function()
        TweenIt(b, {BackgroundColor3 = COLORS.CARD})
        TweenIt(st, {Color = Color3.fromRGB(35,35,35)})
    end)
    b.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        b.Text = text .. ": " .. options[idx]
        if cb then cb(options[idx]) end
    end)
    return b
end

local function Toggle(parent, text, default, cb)
    local state = default or false
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 28)
    h.BackgroundColor3 = COLORS.CARD
    h.BorderSizePixel = 0
    h.Parent = parent
    Corner(h, 8)
    Stroke(h, Color3.fromRGB(35,35,35), 1)
    local lbl = Text(h, text .. ": OFF", 10, false)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -50, 1, 0)
    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 28, 0, 15)
    sw.Position = UDim2.new(1, -36, 0.5, -7.5)
    sw.BackgroundColor3 = Color3.fromRGB(35,35,35)
    sw.Text = ""
    sw.BorderSizePixel = 0
    sw.Parent = h
    Corner(sw, 20)
    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 11, 0, 11)
    ball.Position = UDim2.new(0, 2, 0.5, -5.5)
    ball.BackgroundColor3 = COLORS.GRAY
    ball.BorderSizePixel = 0
    ball.Parent = sw
    Corner(ball, 20)
    local function Update()
        if state then
            TweenIt(sw, {BackgroundColor3 = COLORS.ACCENT})
            TweenIt(ball, {Position = UDim2.new(1, -13, 0.5, -5.5), BackgroundColor3 = COLORS.WHITE})
            lbl.Text = text .. ": ON"
            lbl.TextColor3 = COLORS.WHITE
        else
            TweenIt(sw, {BackgroundColor3 = Color3.fromRGB(35,35,35)})
            TweenIt(ball, {Position = UDim2.new(0, 2, 0.5, -5.5), BackgroundColor3 = COLORS.GRAY})
            lbl.Text = text .. ": OFF"
            lbl.TextColor3 = COLORS.WHITE
        end
        if cb then cb(state) end
    end
    sw.MouseButton1Click:Connect(function() state = not state Update() end)
    Update()
    return h
end

local ActiveSlider = nil

UserInputService.InputChanged:Connect(function(input)
    if ActiveSlider and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        ActiveSlider(input.Position)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ActiveSlider = nil
    end
end)

local function Slider(parent, text, default, minVal, maxVal, cb, suffix)
    local Value = default or 50
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 40)
    h.BackgroundColor3 = COLORS.CARD
    h.BorderSizePixel = 0
    h.Parent = parent
    Corner(h, 8)
    Stroke(h, Color3.fromRGB(35,35,35), 1)
    local lbl = Text(h, text .. ": " .. tostring(Value) .. (suffix or ""), 10, false)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -50, 1, 0)
    local barHolder = Instance.new("Frame")
    barHolder.Size = UDim2.new(1, -20, 0, 20)
    barHolder.Position = UDim2.new(0, 10, 0, 22)
    barHolder.BackgroundTransparency = 1
    barHolder.Parent = h
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 0, 5)
    bg.Position = UDim2.new(0, 0, 0.5, -2.5)
    bg.BackgroundColor3 = Color3.fromRGB(45,45,45)
    bg.BorderSizePixel = 0
    bg.Parent = barHolder
    Corner(bg, 4)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((Value - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = COLORS.ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = bg
    Corner(fill, 4)
    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.ACCENT_DIM),
        ColorSequenceKeypoint.new(1, COLORS.ACCENT_GLOW),
    })
    fillGrad.Parent = fill
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((Value - minVal) / (maxVal - minVal), -8, 0.5, -8)
    knob.BackgroundColor3 = COLORS.WHITE
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.Parent = bg
    Corner(knob, 20)
    Stroke(knob, COLORS.ACCENT, 2)
    local knobGlow = Instance.new("ImageLabel")
    knobGlow.Size = UDim2.new(1, 16, 1, 16)
    knobGlow.Position = UDim2.new(0, -8, 0, -8)
    knobGlow.BackgroundTransparency = 1
    knobGlow.Image = "rbxassetid://5028857084"
    knobGlow.ImageColor3 = COLORS.ACCENT
    knobGlow.ImageTransparency = 0.5
    knobGlow.ZIndex = knob.ZIndex - 1
    knobGlow.Parent = knob
    local function UpdateSlider(v)
        local cv = math.clamp(v, minVal, maxVal)
        Value = cv
        local r = (cv - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(r, 0, 1, 0)
        knob.Position = UDim2.new(r, -8, 0.5, -8)
        lbl.Text = text .. ": " .. tostring(math.floor(cv * 100) / 100) .. (suffix or "")
        if cb then cb(cv) end
    end
    local function fromPos(pos)
        local ap = bg.AbsolutePosition
        local sz = bg.AbsoluteSize.X
        local rx = math.clamp(pos.X - ap.X, 0, sz)
        UpdateSlider(minVal + (rx / sz) * (maxVal - minVal))
    end
    local fullBar = Instance.new("TextButton")
    fullBar.Size = UDim2.new(1, 0, 0, 20)
    fullBar.Position = UDim2.new(0, 0, 0.5, -10)
    fullBar.BackgroundTransparency = 1
    fullBar.Text = ""
    fullBar.Parent = barHolder
    fullBar.MouseButton1Down:Connect(function()
        ActiveSlider = fromPos
        fromPos(UserInputService:GetMouseLocation())
    end)
    knob.MouseButton1Down:Connect(function() ActiveSlider = fromPos end)
    return h
end

local MainPage = CreatePage("Main")
local CombatPage = CreatePage("Combat")
local FastPage = CreatePage("Fast")
local VisualsPage = CreatePage("Visuals")
local HitboxPage = CreatePage("Hitbox")
local ConfigPage = CreatePage("Config")
local SocialsPage = CreatePage("Socials")
local AboutPage = CreatePage("About")

Section(MainPage, "IVORY HUB")
local mtL = Text(MainPage, "IVORY HUB v14.1", 17, true)
mtL.Size = UDim2.new(1, 0, 0, 24)
mtL.TextXAlignment = Enum.TextXAlignment.Center
mtL.TextColor3 = COLORS.WHITE

local msub = Text(MainPage, "Blox Fruits Mobile PVP", 10, false)
msub.Size = UDim2.new(1, 0, 0, 16)
msub.Position = UDim2.new(0, 0, 0, 26)
msub.TextXAlignment = Enum.TextXAlignment.Center
msub.TextColor3 = COLORS.GRAY

local sigFrame = Instance.new("Frame")
sigFrame.Size = UDim2.new(1, 0, 0, 20)
sigFrame.BackgroundTransparency = 1
sigFrame.Parent = MainPage

local mby = Text(sigFrame, "✦ Made by Ivory ✦", 11, true)
mby.Size = UDim2.new(1, 0, 1, 0)
mby.TextXAlignment = Enum.TextXAlignment.Center
mby.TextColor3 = COLORS.ACCENT

Section(MainPage, "STATUS")
local statusLbl = Text(MainPage, "Active: None", 10, false)
statusLbl.Size = UDim2.new(1, -10, 0, 16)
statusLbl.Position = UDim2.new(0, 5, 0, 0)
statusLbl.TextColor3 = COLORS.GREEN

task.spawn(function()
    while Gui and Gui.Parent do
        local active = {}
        if Features.SilentAim then table.insert(active, "Silent Aim") end
        if Features.Tracer then table.insert(active, "Tracer") end
        if Features.SoruAim then table.insert(active, "Soru") end
        if Features.FastAttack then table.insert(active, "Fast") end
        if Features.GunFastAttack then table.insert(active, "Gun Fast") end
        if Features.Hitbox then table.insert(active, "Hitbox") end
        if MacroRunning then table.insert(active, "Macro") end
        if statusLbl and statusLbl.Parent then
            if #active == 0 then
                statusLbl.Text = "Active: None"
                statusLbl.TextColor3 = COLORS.GRAY
            else
                statusLbl.Text = "Active: " .. table.concat(active, ", ")
                statusLbl.TextColor3 = COLORS.GREEN
            end
        end
        task.wait(0.5)
    end
end)

Section(CombatPage, "SILENT AIM")
Toggle(CombatPage, "Enable Silent Aim", Features.SilentAim, function(s) Features.SilentAim = s SaveConfig() end)
CycleButton(CombatPage, "Target", {"Both","Players","NPCs"}, Features.SilentAimTarget, function(v) Features.SilentAimTarget = v SaveConfig() end)
CycleButton(CombatPage, "Mode", {"360","FOV"}, Features.SilentAimMode, function(v) Features.SilentAimMode = v SaveConfig() end)
Slider(CombatPage, "Aim Distance", Features.SilentAimDistance, 0, 2000, function(v) Features.SilentAimDistance = v SaveConfig() end, "m")
Slider(CombatPage, "Prediction", Features.SilentAimPrediction, 0, 0.5, function(v) Features.SilentAimPrediction = v SaveConfig() end, "s")

Section(CombatPage, "TRACER")
Toggle(CombatPage, "Show Tracer", Features.Tracer, function(s)
    Features.Tracer = s
    SaveConfig()
end)
CycleButton(CombatPage, "Tracer Color", {"Red","Green","Yellow","White","Blue","Cyan","Purple"}, Features.TracerColor, function(v)
    Features.TracerColor = v
    TRACER_COLOR = TRACER_MAP[v] or TRACER_MAP.Red
    if BeamTracer then BeamTracer.Color = ColorSequence.new(TRACER_COLOR) end
    if PartTracer then PartTracer.Color = TRACER_COLOR end
    SaveConfig()
end)
Slider(CombatPage, "Tracer Thickness", Features.TracerThickness, 0.5, 5, function(v)
    Features.TracerThickness = v
    if BeamTracer then BeamTracer.Width0 = v BeamTracer.Width1 = v end
    SaveConfig()
end, "px")

Section(CombatPage, "BUDDY SWORD")
Toggle(CombatPage, "Buddy Sword Accuracy", Features.BuddySwordAccuracy, function(s)
    Features.BuddySwordAccuracy = s
    SaveConfig()
end)

Section(CombatPage, "SORU")
Toggle(CombatPage, "Enable Soru", Features.SoruAim, function(s) Features.SoruAim = s SaveConfig() end)
CycleButton(CombatPage, "Soru Target", {"Players","NPCs","Both"}, Features.SoruTarget, function(v) Features.SoruTarget = v SaveConfig() end)
Slider(CombatPage, "Soru Range", Features.SoruRange, 30, 300, function(v) Features.SoruRange = v SaveConfig() end, "m")
CycleButton(CombatPage, "Soru Mode", {"360","FOV"}, Features.SoruMode, function(v) Features.SoruMode = v SaveConfig() end)

Section(CombatPage, "FOV")
Toggle(CombatPage, "Show FOV Circle", Features.FOVCircle, function(s) Features.FOVCircle = s SaveConfig() end)
Slider(CombatPage, "FOV Radius", Features.FOVRadius, 10, 500, function(v) Features.FOVRadius = v SaveConfig() end)
CycleButton(CombatPage, "FOV Mode", {"V1","V2"}, Features.FOVMode, function(v) Features.FOVMode = v SaveConfig() end)

Section(FastPage, "FAST ATTACK")
Toggle(FastPage, "Enable Fast Attack", Features.FastAttack, function(s)
    Features.FastAttack = s
    FastAttack:SetEnabled(s)
    SaveConfig()
end)
Slider(FastPage, "Range", Features.FastAttackRange, 10, 150, function(v) Features.FastAttackRange = v SaveConfig() end, " studs")
Slider(FastPage, "Speed", Features.FastAttackSpeed, 0.02, 0.30, function(v) Features.FastAttackSpeed = v SaveConfig() end, "s")

Section(FastPage, "GUN FAST ATTACK")
Toggle(FastPage, "Enable Gun Fast Attack", Features.GunFastAttack, function(s)
    Features.GunFastAttack = s
    GunFastAttack:SetEnabled(s)
    SaveConfig()
end)
Slider(FastPage, "Gun Range", Features.GunFastAttackRange, 10, 150, function(v) Features.GunFastAttackRange = v SaveConfig() end, " studs")
Slider(FastPage, "Gun Speed", Features.GunFastAttackSpeed, 0.02, 0.30, function(v) Features.GunFastAttackSpeed = v SaveConfig() end, "s")

Section(HitboxPage, "HITBOX")
Toggle(HitboxPage, "Player Hitbox", Features.Hitbox, function(s)
    Features.Hitbox = s
    if not s then clearAllHitboxes() end
    SaveConfig()
end)
Slider(HitboxPage, "Hitbox Bigness", Features.HitboxSize, 3, 40, function(v) Features.HitboxSize = v SaveConfig() end, "x")
Toggle(HitboxPage, "Hide Box", Features.HideBox, function(s)
    Features.HideBox = s
    for _, box in pairs(HitboxBoxes) do
        pcall(function() box.Transparency = s and 1 or 0.3 end)
    end
    SaveConfig()
end)

Section(VisualsPage, "FPS BOOST")
Button(VisualsPage, "FPS Boost", function() ApplyFPSBoost() end)

Section(VisualsPage, "SHADERS")
Button(VisualsPage, "Shaders", function() ApplyShaders() end)

Section(ConfigPage, "CONFIG")
Button(ConfigPage, "Save Config", function() SaveConfig() end)
Button(ConfigPage, "Load Config", function() LoadConfig() end)
Button(ConfigPage, "Reset Config", function()
    ResetConfig()
end)
Button(ConfigPage, "Unload UI", function()
    SaveConfig()
    StopMacro()
    clearAllHitboxes()
    destroyTracer()
    hideTracer()
    Gui:Destroy()
end)

Section(SocialsPage, "⭐ JOIN US ⭐")
local socialTitle = Text(SocialsPage, "Ivory Hub Discord", 13, true)
socialTitle.Size = UDim2.new(1, 0, 0, 20)
socialTitle.Position = UDim2.new(0, 0, 0, 26)
socialTitle.TextXAlignment = Enum.TextXAlignment.Center
socialTitle.TextColor3 = COLORS.ACCENT

local function socialCard(name, discord, y)
    local crd = Instance.new("Frame")
    crd.Size = UDim2.new(1, -10, 0, 60)
    crd.Position = UDim2.new(0, 5, 0, y)
    crd.BackgroundColor3 = COLORS.CARD
    crd.BorderSizePixel = 0
    crd.Parent = SocialsPage
    Corner(crd, 10)
    Stroke(crd, COLORS.ACCENT, 1)
    local n = Text(crd, name, 13, true)
    n.Position = UDim2.new(0, 12, 0, 8)
    n.Size = UDim2.new(1, -20, 0, 18)
    n.TextColor3 = COLORS.WHITE
    local d = Text(crd, "Discord: " .. discord, 10, false)
    d.Position = UDim2.new(0, 12, 0, 30)
    d.Size = UDim2.new(1, -20, 0, 16)
    d.TextColor3 = COLORS.GRAY
end

socialCard("IVORY", "Ivory999", 55)

Section(AboutPage, "📖 ABOUT IVORY HUB")
local aboutLines = {
    "Ivory Hub v14.1",
    "Made by Ivory",
    "",
    "• CentuDox Silent Aim + Prediction",
    "• Tracer that leads with prediction",
    "• Soru, Fast Attack, Gun Fast Attack",
    "• Player Hitbox, Macro",
    "• FPS Boost + Atmospheric Shaders",
    "",
    "Thanks for using Ivory Hub 🦷"
}
for i, line in ipairs(aboutLines) do
    local lbl = Text(AboutPage, line, 9, false)
    lbl.Size = UDim2.new(1, -10, 0, 14)
    lbl.Position = UDim2.new(0, 5, 0, 26 + (i-1)*15)
    lbl.TextColor3 = (i == 2) and COLORS.ACCENT or COLORS.WHITE
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local Tabs = {
    {name="MAIN", icon="🏠", page=MainPage},
    {name="COMBAT", icon="⚔️", page=CombatPage},
    {name="FAST", icon="⚡", page=FastPage},
    {name="HITBOX", icon="📦", page=HitboxPage},
    {name="VISUALS", icon="✨", page=VisualsPage},
    {name="CONFIG", icon="⚙️", page=ConfigPage},
    {name="SOCIALS", icon="💬", page=SocialsPage},
    {name="ABOUT", icon="📖", page=AboutPage},
}

local indicator = Instance.new("Frame")
indicator.Size = UDim2.new(0, 3, 0, 20)
indicator.Position = UDim2.new(0, 1, 0, 0)
indicator.BackgroundColor3 = COLORS.ACCENT
indicator.BorderSizePixel = 0
indicator.ZIndex = 5
indicator.Parent = Sidebar
Corner(indicator, 4)

local function SelectTab(button, page)
    for _, d in ipairs(Tabs) do
        if d.button then
            TweenIt(d.button, {BackgroundColor3 = COLORS.DARKER}, 0.2)
            d.button.TextColor3 = COLORS.GRAY
        end
        d.page.Visible = false
    end
    TweenIt(button, {BackgroundColor3 = COLORS.ACCENT}, 0.2)
    button.TextColor3 = COLORS.WHITE
    page.Visible = true
    TweenIt(indicator, {Position = UDim2.new(0, 1, 0, button.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y)}, 0.18)
end

for _, d in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = COLORS.DARKER
    btn.BorderSizePixel = 0
    btn.Text = "  " .. d.icon .. "  " .. d.name
    btn.TextColor3 = COLORS.GRAY
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Corner(btn, 8)
    Stroke(btn, Color3.fromRGB(35,35,35), 1)
    AttachClickAnim(btn)
    d.button = btn
    btn.MouseEnter:Connect(function()
        if d.page.Visible then return end
        TweenIt(btn, {BackgroundColor3 = Color3.fromRGB(30,30,30)})
    end)
    btn.MouseLeave:Connect(function()
        if d.page.Visible then return end
        TweenIt(btn, {BackgroundColor3 = COLORS.DARKER})
    end)
    btn.MouseButton1Click:Connect(function() SelectTab(btn, d.page) end)
end
SelectTab(Tabs[1].button, Tabs[1].page)

local Drag, DStart, SPos = false, nil, nil
Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Drag = true DStart = input.Position SPos = Main.Position
    end
end)
Top.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Drag = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if Drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - DStart
        Main.Position = UDim2.new(SPos.X.Scale, SPos.X.Offset + d.X, SPos.Y.Scale, SPos.Y.Offset + d.Y)
    end
end)

local Min = false
Minimize.MouseButton1Click:Connect(function()
    Min = not Min
    if Min then
        Sidebar.Visible = false
        Content.Visible = false
        shadow.Visible = false
        TweenIt(Main, {Size = UDim2.new(0, 500, 0, 48)})
        Minimize.Text = "+"
    else
        TweenIt(Main, {Size = UDim2.new(0, 500, 0, 340)})
        task.wait(.15)
        Sidebar.Visible = true
        Content.Visible = true
        shadow.Visible = true
        Minimize.Text = "—"
    end
end)

Close.MouseButton1Click:Connect(function()
    SaveConfig()
    StopMacro()
    clearAllHitboxes()
    destroyTracer()
    hideTracer()
    TweenIt(Main, {Size = UDim2.new(0, 0, 0, 0)})
    task.wait(.3)
    Gui:Destroy()
end)

print("========================================")
print("     IVORY HUB v14.1 LOADED")
print("     Made by Ivory")
print("========================================")
print("Draggable Toggle: grab & move 'I'")
print("UI Refresh Edition")
print("========================================")
-- =============================================
-- IVORY SMART MACRO — ENGINE
-- =============================================
local IVORY_MACRO = {}
_G.IvoryMacro = IVORY_MACRO

IVORY_MACRO.BLOCK_COUNT = 8
IVORY_MACRO.SLOT_COUNT  = 5
IVORY_MACRO.WEAPONS     = {"Melee", "Fruit", "Sword", "Gun"}
IVORY_MACRO.SKILLS      = {"Z", "X", "C", "V", "F"}
IVORY_MACRO.CAST_MODES  = {"Tap", "Hold", "Transform"}

IVORY_MACRO.slots           = {}
IVORY_MACRO.activeSlot      = 1
IVORY_MACRO.running         = false
IVORY_MACRO.runContext      = nil
IVORY_MACRO.runToken        = 0
IVORY_MACRO.pendingRun      = nil
IVORY_MACRO.intentVersion   = 0
IVORY_MACRO.currentBlockIndex = nil
IVORY_MACRO.activeKey       = nil
IVORY_MACRO.activeSkill     = nil
IVORY_MACRO.activeKeyToken  = nil
IVORY_MACRO.activeInputMode = nil

IVORY_MACRO.smartCooldownCache = {}
IVORY_MACRO.smartReadyCache    = {}

IVORY_MACRO.contextByThread = setmetatable({}, {__mode = "k"})

local MACRO_FILE = CONFIG_FOLDER .. "/smart_macro.txt"

local function newEmptyStep()
    return {
        enabled          = false,
        weapon           = "Melee",
        skill            = "Z",
        mode             = "Tap",
        hold             = "0",
        delay            = "0.2",
        fallbackEnabled  = false,
        fallbackWeapon   = "Melee",
        fallbackSkill    = "X",
        fallbackMode     = "Tap",
        fallbackHold     = "0",
        jumpsAfter       = 0,
    }
end

local function newEmptySlot(index)
    local slot = {
        name         = "Slot " .. index,
        soruEnabled  = false,
        soruAfter    = 1,
        m1Enabled    = false,
        m1Weapon     = "Melee",
        m1Count      = 1,
        m1After      = 1,
        v3Enabled    = false,
        v3After      = 1,
        steps        = {},
    }
    for i = 1, IVORY_MACRO.BLOCK_COUNT do
        slot.steps[i] = newEmptyStep()
    end
    return slot
end
IVORY_MACRO.newEmptySlot = newEmptySlot
IVORY_MACRO.newEmptyStep = newEmptyStep

function IVORY_MACRO.normalizeWeapon(w)
    if type(w) ~= "string" then return "Melee" end
    local lower = w:lower():gsub("%s+", "")
    if lower == "none"     then return "None"  end
    if lower == "melee"    then return "Melee" end
    if lower == "fruit"    or lower == "bloxfruit" then return "Fruit" end
    if lower == "sword"    then return "Sword" end
    if lower == "gun"      then return "Gun"   end
    return "Melee"
end

function IVORY_MACRO.normalizeSkill(s)
    s = tostring(s or "Z"):upper():match("%S+") or "Z"
    if not s:match("^[ZXCVF]$") then return "Z" end
    return s
end

function IVORY_MACRO.normalizeCastMode(mode, hold)
    local m = tostring(mode or ""):lower()
    if m == "transform" then return "Transform" end
    if m == "hold" or (m == "" and (tonumber(hold) or 0) > 0) then return "Hold" end
    return "Tap"
end

function IVORY_MACRO.clampInt(n, min, max, default)
    n = tonumber(n) or default
    n = math.floor(n)
    if n < min then n = min end
    if n > max then n = max end
    return n
end

function IVORY_MACRO.normalizeSlot(slot)
    if type(slot) ~= "table" then return newEmptySlot(1) end
    slot.name        = tostring(slot.name or "Slot"):sub(1, 28)
    slot.soruEnabled = slot.soruEnabled == true
    slot.soruAfter   = IVORY_MACRO.clampInt(slot.soruAfter, 0, IVORY_MACRO.BLOCK_COUNT, 1)
    slot.m1Enabled   = slot.m1Enabled == true
    slot.m1Weapon    = IVORY_MACRO.normalizeWeapon(slot.m1Weapon)
    if slot.m1Weapon == "None" then slot.m1Weapon = "Melee" end
    slot.m1Count     = IVORY_MACRO.clampInt(slot.m1Count, 1, 6, 1)
    slot.m1After     = IVORY_MACRO.clampInt(slot.m1After, 0, IVORY_MACRO.BLOCK_COUNT, 1)
    slot.v3Enabled   = slot.v3Enabled == true
    slot.v3After     = IVORY_MACRO.clampInt(slot.v3After, 0, IVORY_MACRO.BLOCK_COUNT, 1)

    if type(slot.steps) ~= "table" then slot.steps = {} end
    for i = 1, IVORY_MACRO.BLOCK_COUNT do
        local s = slot.steps[i] or slot.steps[tostring(i)]
        if type(s) ~= "table" then
            slot.steps[i] = newEmptyStep()
        else
            s.enabled         = s.enabled == true
            s.weapon          = IVORY_MACRO.normalizeWeapon(s.weapon)
            s.skill           = IVORY_MACRO.normalizeSkill(s.skill)
            s.mode            = IVORY_MACRO.normalizeCastMode(s.mode, s.hold)
            s.hold            = tostring(math.clamp(tonumber(s.hold) or 0, 0, 10))
            s.delay           = tostring(math.clamp(tonumber(s.delay) or 0.2, 0, 10))
            s.fallbackEnabled = s.fallbackEnabled == true
            s.fallbackWeapon  = IVORY_MACRO.normalizeWeapon(s.fallbackWeapon or s.weapon)
            s.fallbackSkill   = IVORY_MACRO.normalizeSkill(s.fallbackSkill or (s.skill == "X" and "C" or "X"))
            s.fallbackMode    = IVORY_MACRO.normalizeCastMode(s.fallbackMode, s.fallbackHold)
            s.fallbackHold    = tostring(math.clamp(tonumber(s.fallbackHold) or 0, 0, 10))
            s.jumpsAfter      = IVORY_MACRO.clampInt(s.jumpsAfter, 0, 8, 0)
            slot.steps[i] = s
        end
    end
end

function IVORY_MACRO.resetAllSlots()
    IVORY_MACRO.slots = {}
    for i = 1, IVORY_MACRO.SLOT_COUNT do
        IVORY_MACRO.slots[i] = newEmptySlot(i)
    end
    IVORY_MACRO.activeSlot = 1
end
IVORY_MACRO.resetAllSlots()

local function serializeSlot(slot)
    local parts = {}
    parts[#parts + 1] = "name=" .. slot.name
    parts[#parts + 1] = "soruEnabled=" .. tostring(slot.soruEnabled)
    parts[#parts + 1] = "soruAfter=" .. tostring(slot.soruAfter)
    parts[#parts + 1] = "m1Enabled=" .. tostring(slot.m1Enabled)
    parts[#parts + 1] = "m1Weapon=" .. slot.m1Weapon
    parts[#parts + 1] = "m1Count=" .. tostring(slot.m1Count)
    parts[#parts + 1] = "m1After=" .. tostring(slot.m1After)
    parts[#parts + 1] = "v3Enabled=" .. tostring(slot.v3Enabled)
    parts[#parts + 1] = "v3After=" .. tostring(slot.v3After)
    for i = 1, IVORY_MACRO.BLOCK_COUNT do
        local s = slot.steps[i]
        local prefix = "step" .. i .. "."
        parts[#parts + 1] = prefix .. "enabled=" .. tostring(s.enabled)
        parts[#parts + 1] = prefix .. "weapon=" .. s.weapon
        parts[#parts + 1] = prefix .. "skill=" .. s.skill
        parts[#parts + 1] = prefix .. "mode=" .. s.mode
        parts[#parts + 1] = prefix .. "hold=" .. s.hold
        parts[#parts + 1] = prefix .. "delay=" .. s.delay
        parts[#parts + 1] = prefix .. "fbEnabled=" .. tostring(s.fallbackEnabled)
        parts[#parts + 1] = prefix .. "fbWeapon=" .. s.fallbackWeapon
        parts[#parts + 1] = prefix .. "fbSkill=" .. s.fallbackSkill
        parts[#parts + 1] = prefix .. "fbMode=" .. s.fallbackMode
        parts[#parts + 1] = prefix .. "fbHold=" .. s.fallbackHold
        parts[#parts + 1] = prefix .. "jumps=" .. tostring(s.jumpsAfter)
    end
    return table.concat(parts, "\n")
end

local function deserializeSlot(text)
    local slot = newEmptySlot(1)
    for line in text:gmatch("[^\r\n]+") do
        local key, val = line:match("^([^=]+)=(.*)$")
        if key and val then
            if key == "name" then slot.name = val
            elseif key == "soruEnabled" then slot.soruEnabled = (val == "true")
            elseif key == "soruAfter" then slot.soruAfter = tonumber(val) or 1
            elseif key == "m1Enabled" then slot.m1Enabled = (val == "true")
            elseif key == "m1Weapon" then slot.m1Weapon = val
            elseif key == "m1Count" then slot.m1Count = tonumber(val) or 1
            elseif key == "m1After" then slot.m1After = tonumber(val) or 1
            elseif key == "v3Enabled" then slot.v3Enabled = (val == "true")
            elseif key == "v3After" then slot.v3After = tonumber(val) or 1
            else
                local stepIdx, field = key:match("^step(%d+)%.(.+)$")
                stepIdx = tonumber(stepIdx)
                if stepIdx and field and stepIdx >= 1 and stepIdx <= IVORY_MACRO.BLOCK_COUNT then
                    local s = slot.steps[stepIdx]
                    if field == "enabled" then s.enabled = (val == "true")
                    elseif field == "weapon" then s.weapon = val
                    elseif field == "skill" then s.skill = val
                    elseif field == "mode" then s.mode = val
                    elseif field == "hold" then s.hold = val
                    elseif field == "delay" then s.delay = val
                    elseif field == "fbEnabled" then s.fallbackEnabled = (val == "true")
                    elseif field == "fbWeapon" then s.fallbackWeapon = val
                    elseif field == "fbSkill" then s.fallbackSkill = val
                    elseif field == "fbMode" then s.fallbackMode = val
                    elseif field == "fbHold" then s.fallbackHold = val
                    elseif field == "jumps" then s.jumpsAfter = tonumber(val) or 0
                    end
                end
            end
        end
    end
    return slot
end

function IVORY_MACRO.Save()
    if not writefile then return false end
    pcall(function()
        local buf = {}
        buf[#buf + 1] = "activeSlot=" .. tostring(IVORY_MACRO.activeSlot)
        for i = 1, IVORY_MACRO.SLOT_COUNT do
            buf[#buf + 1] = "===SLOT " .. i .. "==="
            buf[#buf + 1] = serializeSlot(IVORY_MACRO.slots[i])
        end
        writefile(MACRO_FILE, table.concat(buf, "\n"))
    end)
    return true
end

function IVORY_MACRO.Load()
    if not readfile or not isfile then return false end
    if not isfile(MACRO_FILE) then return false end
    local ok, content = pcall(readfile, MACRO_FILE)
    if not ok or type(content) ~= "string" then return false end

    local slotBuf, currentSlot, activeSlot = {}, nil, 1
    local function flush()
        if currentSlot and slotBuf[currentSlot] then
            IVORY_MACRO.slots[currentSlot] = deserializeSlot(table.concat(slotBuf[currentSlot], "\n"))
            IVORY_MACRO.normalizeSlot(IVORY_MACRO.slots[currentSlot])
        end
    end

    for line in content:gmatch("[^\r\n]+") do
        local n = tonumber(line:match("^activeSlot=(%d+)$"))
        if n then
            activeSlot = n
        else
            local idx = tonumber(line:match("^===SLOT (%d+)===$"))
            if idx then
                if currentSlot then flush() end
                currentSlot = idx
                slotBuf[idx] = {}
            elseif currentSlot then
                table.insert(slotBuf[currentSlot], line)
            end
        end
    end
    flush()

    IVORY_MACRO.activeSlot = math.clamp(activeSlot, 1, IVORY_MACRO.SLOT_COUNT)
    return true
end

IVORY_MACRO.Load()

-- =============================================
-- EQUIP + COOLDOWN HELPERS
-- =============================================
function IVORY_MACRO.toolToWeaponType(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    if tool:GetAttribute("WeaponType") == "Gun" or tool:FindFirstChild("RemoteFunctionShoot") then
        return "Gun"
    end
    local tip = (tool.ToolTip or ""):lower():gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
    if tip == "melee" then return "Melee"
    elseif tip == "blox fruit" or tip == "fruit" then return "Fruit"
    elseif tip == "sword" then return "Sword"
    elseif tip == "gun" then return "Gun"
    end
    return nil
end

function IVORY_MACRO.getEquippedWeaponType()
    local char = player.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local t = IVORY_MACRO.toolToWeaponType(child)
            if t then return t end
        end
    end
    return nil
end

function IVORY_MACRO.findToolByType(weaponType)
    local char = player.Character
    local bp = player:FindFirstChildOfClass("Backpack")
    for _, c in ipairs({char, bp}) do
        if c then
            for _, child in ipairs(c:GetChildren()) do
                if child:IsA("Tool") and IVORY_MACRO.toolToWeaponType(child) == weaponType then
                    return child
                end
            end
        end
    end
    return nil
end

function IVORY_MACRO.hotbarKeyForTool(tool)
    if not tool then return nil end
    local pg = player:FindFirstChildOfClass("PlayerGui")
    local bp = pg and pg:FindFirstChild("Backpack")
    local hotbar = bp and bp:FindFirstChild("Hotbar")
    local container = hotbar and hotbar:FindFirstChild("Container")
    if not container then return nil end
    local slot = nil
    for _, d in ipairs(container:GetDescendants()) do
        if d:IsA("GuiObject") and d:GetAttribute("ItemName") == tool.Name then
            slot = math.floor(tonumber(d.LayoutOrder) or 0)
            if slot > 0 then break end
        end
    end
    local keys = {
        [1] = Enum.KeyCode.One,   [2] = Enum.KeyCode.Two,
        [3] = Enum.KeyCode.Three, [4] = Enum.KeyCode.Four,
        [5] = Enum.KeyCode.Five,  [6] = Enum.KeyCode.Six,
        [7] = Enum.KeyCode.Seven, [8] = Enum.KeyCode.Eight,
        [9] = Enum.KeyCode.Nine,  [10] = Enum.KeyCode.Zero,
    }
    return keys[slot]
end

function IVORY_MACRO.equipWeaponType(weaponType)
    if not weaponType then return false end
    local norm = tostring(weaponType):lower():gsub("%s+", "")
    if norm == "bloxfruit" or norm == "fruit" then norm = "Fruit"
    elseif norm == "melee" then norm = "Melee"
    elseif norm == "sword" then norm = "Sword"
    elseif norm == "gun" then norm = "Gun"
    else norm = weaponType end

    if IVORY_MACRO.getEquippedWeaponType() == norm then return true end

    local tool = IVORY_MACRO.findToolByType(norm)
    if not tool then return false end

    if not UserInputService.TouchEnabled then
        local key = IVORY_MACRO.hotbarKeyForTool(tool)
        if key then
            pcall(function()
                VIM:SendKeyEvent(true, key, false, game)
                task.wait(0.02)
                VIM:SendKeyEvent(false, key, false, game)
            end)
            local deadline = tick() + 0.2
            repeat
                if IVORY_MACRO.getEquippedWeaponType() == norm then return true end
                task.wait(0.015)
            until tick() >= deadline
        end
    end

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if tool.Parent ~= char then
        pcall(function() hum:EquipTool(tool) end)
        local deadline = tick() + 0.25
        while tick() < deadline do
            if IVORY_MACRO.getEquippedWeaponType() == norm then return true end
            task.wait(0.015)
        end
    end
    return IVORY_MACRO.getEquippedWeaponType() == norm
end

function IVORY_MACRO.smartCooldownWidth(guiObj)
    if not (guiObj and guiObj.Parent) then return 0 end
    local size = guiObj.Size.X
    if math.abs(size.Scale) > 0.002 then return math.abs(size.Scale) end
    if math.abs(size.Offset) > 1 then return math.abs(size.Offset) end
    return 0
end

function IVORY_MACRO.smartCooldownActive(guiObj)
    return IVORY_MACRO.smartCooldownWidth(guiObj) > 0
end

function IVORY_MACRO.findSmartCooldown(toolName, skillKey, forceRefresh)
    local cacheKey = tostring(toolName or "") .. "\0" .. tostring(skillKey or "")
    local cached = IVORY_MACRO.smartCooldownCache[cacheKey]
    if not forceRefresh and cached and cached.Parent then return cached end

    local pg = player:FindFirstChildOfClass("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local skills = main and main:FindFirstChild("Skills")
    if not skills then return nil end

    local toolFolder = skills:FindFirstChild(toolName or "")
    if not toolFolder then
        local norm = tostring(toolName or ""):lower():gsub("[^%w]", "")
        for _, child in ipairs(skills:GetChildren()) do
            local cNorm = child.Name:lower():gsub("[^%w]", "")
            if cNorm == norm or cNorm == norm .. norm or norm == cNorm .. cNorm then
                toolFolder = child
                break
            end
        end
    end
    if not toolFolder then return nil end
    local keyFrame = toolFolder:FindFirstChild(tostring(skillKey or ""))
    local cd = keyFrame and keyFrame:FindFirstChild("Cooldown")
    if not (cd and cd:IsA("GuiObject")) then return nil end
    IVORY_MACRO.smartCooldownCache[cacheKey] = cd
    return cd
end

function IVORY_MACRO.waitForSmartCooldownReady(toolName, skillKey, token, timeout)
    local deadline = tick() + math.max(0.3, tonumber(timeout) or 1.5)
    while IVORY_MACRO.running and IVORY_MACRO.runToken == token and tick() < deadline do
        local cd = IVORY_MACRO.findSmartCooldown(toolName, skillKey, true)
        if cd then return cd end
        task.wait(0.02)
    end
    return nil
end

function IVORY_MACRO.waitForSmartCooldown(cd, token, timeout, toolName, skillKey)
    local deadline = tick() + math.max(0.25, tonumber(timeout) or 1.5)
    local sawProgress, lastWidth = false, 0
    while IVORY_MACRO.running and IVORY_MACRO.runToken == token do
        local refreshed = IVORY_MACRO.findSmartCooldown(toolName, skillKey, true)
        if refreshed then cd = refreshed end
        local width = IVORY_MACRO.smartCooldownWidth(cd)
        if width > 0 then
            sawProgress = true
            if width < lastWidth - 0.003 then return true end
            if width > lastWidth then lastWidth = width end
        elseif sawProgress and lastWidth > 0 then
            return true
        end
        if not sawProgress and tick() >= deadline then return false end
        task.wait(0.015)
    end
    return false
end

function IVORY_MACRO.getFruitTransformationState(char)
    if not char then return nil end
    local util = ReplicatedStorage:FindFirstChild("Util")
    local isTransformed = util and util:FindFirstChild("IsTransformed")
    if isTransformed then
        local ok, fn = pcall(require, isTransformed)
        if ok and type(fn) == "function" then
            local ok2, result = pcall(fn, char, false, false)
            if ok2 then return result == true end
        end
    end
    for _, a in ipairs({"Transformed", "Transformation", "IsTransformed", "FruitTransformed"}) do
        if char:GetAttribute(a) == true then return true end
    end
    return nil
end

-- =============================================
-- MOBILE SKILL DISPATCH
-- =============================================
IVORY_MACRO.mobile = {active = {}, skillKeys = {Z=true, X=true, C=true, V=true, F=true}}

function IVORY_MACRO.mobile.isVisible(g)
    if not g or not g.Parent or not g:IsA("GuiObject") or not g.Visible then return false end
    if g.AbsoluteSize.X <= 0 or g.AbsoluteSize.Y <= 0 then return false end
    local p = g.Parent
    while p and p ~= player do
        if p:IsA("GuiObject") and not p.Visible then return false end
        if p:IsA("LayerCollector") and not p.Enabled then return false end
        p = p.Parent
    end
    return true
end

function IVORY_MACRO.mobile.findContextButton(skillKey)
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return nil, nil end
    local ctx = pg:FindFirstChild("MobileContextButtons", true)
    local frame = ctx and ctx:FindFirstChild("ContextButtonFrame", true)
    local wrapped = frame and frame:FindFirstChild("Skill_" .. skillKey)
    if not wrapped and ctx then wrapped = ctx:FindFirstChild("Skill_" .. skillKey, true) end
    local btn = wrapped and wrapped:FindFirstChild("Button", true)
    if not btn then return nil, nil end
    if not btn:IsA("GuiButton") or not IVORY_MACRO.mobile.isVisible(btn) then return nil, nil end
    return wrapped, btn
end

function IVORY_MACRO.mobile.findClassicSkillButton(tool, skillKey)
    local pg = player:FindFirstChildOfClass("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local skills = main and main:FindFirstChild("Skills")
    if not skills then return nil end
    local toolName = tool and tool.Name or ""
    local toolFolder = skills:FindFirstChild(toolName)
    local btn = toolFolder and toolFolder:FindFirstChild(skillKey)
    if btn and btn:IsA("GuiButton") and IVORY_MACRO.mobile.isVisible(btn) then
        return btn
    end
    return nil
end

function IVORY_MACRO.mobile.findButtonAnywhere(skillKey)
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local found = nil
    for _, d in ipairs(pg:GetDescendants()) do
        if d:IsA("GuiButton") and IVORY_MACRO.mobile.isVisible(d) then
            local name = d.Name:upper():gsub("%s+", "")
            if name == skillKey or name == "SKILL_" .. skillKey then
                found = d
                if name == skillKey then return d end
            end
        end
    end
    return found
end

function IVORY_MACRO.mobile.sendTouch(isBegin, touchId, pos)
    return pcall(function()
        VIM:SendTouchEvent(touchId,
            (isBegin and Enum.UserInputState.Begin or Enum.UserInputState.End).Value,
            math.floor(pos.X), math.floor(pos.Y))
    end)
end

function IVORY_MACRO.mobile.sendMobileSkill(skillKey, isBegin)
    skillKey = tostring(skillKey or ""):upper()
    if not IVORY_MACRO.mobile.skillKeys[skillKey] then return false end
    if isBegin then
        local wrapped, btn = IVORY_MACRO.mobile.findContextButton(skillKey)
        if wrapped and btn then
            local pos = btn.AbsolutePosition + btn.AbsoluteSize * 0.5
            local tid = 320 + string.byte(skillKey)
            IVORY_MACRO.mobile.active[skillKey] = {id = tid, position = pos}
            return IVORY_MACRO.mobile.sendTouch(true, tid, pos)
        end
        local char = player.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        local classic = IVORY_MACRO.mobile.findClassicSkillButton(tool, skillKey)
        if classic then
            local pos = classic.AbsolutePosition + classic.AbsoluteSize * 0.5
            local tid = 300 + string.byte(skillKey)
            IVORY_MACRO.mobile.active[skillKey] = {id = tid, position = pos}
            return IVORY_MACRO.mobile.sendTouch(true, tid, pos)
        end
        local any = IVORY_MACRO.mobile.findButtonAnywhere(skillKey)
        if any then
            local pos = any.AbsolutePosition + any.AbsoluteSize * 0.5
            local tid = 340 + string.byte(skillKey)
            IVORY_MACRO.mobile.active[skillKey] = {id = tid, position = pos}
            return IVORY_MACRO.mobile.sendTouch(true, tid, pos)
        end
        return false
    else
        local info = IVORY_MACRO.mobile.active[skillKey]
        if not info then return false end
        IVORY_MACRO.mobile.active[skillKey] = nil
        return IVORY_MACRO.mobile.sendTouch(false, info.id, info.position)
    end
end

function IVORY_MACRO.mobile.releaseAll()
    for key, info in pairs(IVORY_MACRO.mobile.active) do
        IVORY_MACRO.mobile.sendTouch(false, info.id, info.position)
    end
    IVORY_MACRO.mobile.active = {}
end

-- =============================================
-- CASTING CORE
-- =============================================
function IVORY_MACRO.waitWhileRunning(seconds, token)
    local deadline = tick() + math.max(0, tonumber(seconds) or 0)
    while IVORY_MACRO.running and IVORY_MACRO.runToken == token and tick() < deadline do
        task.wait(math.min(0.015, math.max(0, deadline - tick())))
    end
    return IVORY_MACRO.running and IVORY_MACRO.runToken == token
end

function IVORY_MACRO.pressSkillKey(keyCode, holdSeconds)
    holdSeconds = math.clamp(tonumber(holdSeconds) or 0.045, 0.01, 10)
    if not pcall(function() VIM:SendKeyEvent(true, keyCode, false, game) end) then return false end
    task.wait(holdSeconds)
    pcall(function() VIM:SendKeyEvent(false, keyCode, false, game) end)
    return true
end

function IVORY_MACRO.castSmartStep(step, skillKey, keyCode, token)
    if not IVORY_MACRO.running or IVORY_MACRO.runToken ~= token then
        return false, "playback stopped"
    end
    local mode = (step.mode == "Hold") and "Hold" or "Tap"
    local holdTime = (mode == "Hold") and (math.clamp(tonumber(step.hold) or 0, 0, 10)) or 0.045
    if mode == "Hold" and holdTime == 0 then holdTime = 0.045 end

    local delivered, path = false, "key"

    if UserInputService.TouchEnabled then
        local ok, result = pcall(IVORY_MACRO.mobile.sendMobileSkill, skillKey, true)
        delivered = ok and result == true
        if delivered then path = "mobile" end
    end
    if not delivered and keyCode then
        delivered = IVORY_MACRO.pressSkillKey(keyCode, holdTime)
        if delivered then path = "pc-key" end
    end

    if not delivered then return false, "ability input unavailable [" .. tostring(skillKey) .. "]" end

    IVORY_MACRO.activeKey = keyCode
    IVORY_MACRO.activeSkill = skillKey
    IVORY_MACRO.activeKeyToken = token
    IVORY_MACRO.activeInputMode = path
    return true, ""
end

function IVORY_MACRO.releaseActiveInput(token)
    if IVORY_MACRO.activeKey and (not token or IVORY_MACRO.activeKeyToken == token) then
        if IVORY_MACRO.activeInputMode == "mobile" then
            pcall(IVORY_MACRO.mobile.sendMobileSkill, IVORY_MACRO.activeSkill, false)
        elseif IVORY_MACRO.activeKey then
            pcall(function() VIM:SendKeyEvent(false, IVORY_MACRO.activeKey, false, game) end)
        end
        IVORY_MACRO.activeKey = nil
        IVORY_MACRO.activeSkill = nil
        IVORY_MACRO.activeKeyToken = nil
        IVORY_MACRO.activeInputMode = nil
    end
end

function IVORY_MACRO.runPostSkillJumps(count, token)
    count = math.clamp(math.floor(tonumber(count) or 0), 0, 8)
    for _ = 1, count do
        if not IVORY_MACRO.running or IVORY_MACRO.runToken ~= token then
            return false, "playback was stopped"
        end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then
            return false, "cannot jump in the current character state"
        end
        local jp = hum.UseJumpPower and hum.JumpPower or math.sqrt(2 * workspace.Gravity * hum.JumpHeight)
        local v = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(v.X, math.max(v.Y, jp), v.Z)
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        if not IVORY_MACRO.waitWhileRunning(0.12, token) then
            return false, "playback was stopped"
        end
    end
    return true, ""
end

function IVORY_MACRO.skillCooldownState(tool, key)
    if not tool or not key then return false, false end
    local pg = player:FindFirstChildOfClass("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local skills = main and main:FindFirstChild("Skills")
    if not skills then return false, false end
    local folder = skills:FindFirstChild(tool.Name)
    if not folder then
        local norm = tostring(tool.Name):lower():gsub("[%s%-_]", "")
        for _, c in ipairs(skills:GetChildren()) do
            local n = c.Name:lower():gsub("[%s%-_]", "")
            if n == norm or n == norm .. norm or norm == n .. n then
                folder = c
                break
            end
        end
    end
    local keyFrame = folder and folder:FindFirstChild(key)
    local cd = keyFrame and keyFrame:FindFirstChild("Cooldown")
    if not cd then return false, false end
    return true, (cd.Visible and cd.Size.X.Scale > 0.05)
end

function IVORY_MACRO.resolveSmartStep(step)
    local char = player.Character
    if not char then return nil, "character is temporarily unavailable" end
    local resolved = {
        weapon = IVORY_MACRO.normalizeWeapon(step.weapon),
        skill = IVORY_MACRO.normalizeSkill(step.skill),
        mode = IVORY_MACRO.normalizeCastMode(step.mode, step.hold),
        hold = step.hold,
        usedFallback = false,
    }
    if resolved.mode == "Transform" and IVORY_MACRO.getFruitTransformationState(char) == true then
        return resolved
    end
    if step.fallbackEnabled ~= true then return resolved end
    local tool = char:FindFirstChildOfClass("Tool")
    local exists, onCd = IVORY_MACRO.skillCooldownState(tool, resolved.skill)
    if not (exists and onCd) then return resolved end
    local fbWeapon = IVORY_MACRO.normalizeWeapon(step.fallbackWeapon or resolved.weapon)
    local fbSkill = IVORY_MACRO.normalizeSkill(step.fallbackSkill or "X")
    if fbWeapon ~= "None" then
        if not IVORY_MACRO.equipWeaponType(fbWeapon) then
            return nil, "could not equip fallback " .. tostring(fbWeapon)
        end
    end
    tool = char:FindFirstChildOfClass("Tool")
    exists, onCd = IVORY_MACRO.skillCooldownState(tool, fbSkill)
    if exists and onCd then return nil, "primary and fallback are cooling down" end
    return {
        weapon = fbWeapon,
        skill = fbSkill,
        mode = IVORY_MACRO.normalizeCastMode(step.fallbackMode, step.fallbackHold),
        hold = step.fallbackHold,
        usedFallback = true,
    }
end

-- =============================================
-- RUN LOOP
-- =============================================
function IVORY_MACRO.runSlot(context)
    if not context or type(context.snapshot) ~= "table" then return end
    local snap = context.snapshot
    local token = context.id

    IVORY_MACRO.running = true
    IVORY_MACRO.runContext = context
    context.state = "RUNNING"

    local skillKeyToCode = {
        Z = Enum.KeyCode.Z, X = Enum.KeyCode.X, C = Enum.KeyCode.C,
        V = Enum.KeyCode.V, F = Enum.KeyCode.F,
    }

    task.spawn(function()
        IVORY_MACRO.contextByThread[coroutine.running()] = context
        local ok, err = pcall(function()
            local soruEnabled = snap.soruEnabled == true
            local soruAfter   = IVORY_MACRO.clampInt(snap.soruAfter, 0, IVORY_MACRO.BLOCK_COUNT, 1)
            local m1Enabled   = snap.m1Enabled == true
            local m1After     = IVORY_MACRO.clampInt(snap.m1After, 0, IVORY_MACRO.BLOCK_COUNT, 1)
            local v3Enabled   = snap.v3Enabled == true
            local v3After     = IVORY_MACRO.clampInt(snap.v3After, 0, IVORY_MACRO.BLOCK_COUNT, 1)

            for i, step in ipairs(snap.steps) do
                if not IVORY_MACRO.running or IVORY_MACRO.runToken ~= token then break end
                IVORY_MACRO.currentBlockIndex = i

                if soruEnabled and soruAfter == i - 1 then
                    if DoSoruTeleport then pcall(DoSoruTeleport) end
                end
                if v3Enabled and v3After == i - 1 then
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local commE = remotes and remotes:FindFirstChild("CommE")
                    if commE then pcall(function() commE:FireServer("ActivateAbility") end) end
                end

                if step.enabled ~= false then
                    local resolved = IVORY_MACRO.resolveSmartStep(step)
                    if resolved then
                        local weapon = resolved.weapon
                        local skill = resolved.skill
                        if weapon ~= "None" then
                            if not IVORY_MACRO.equipWeaponType(weapon) then
                                error("Block " .. i .. " could not equip " .. weapon)
                            end
                        end
                        if not IVORY_MACRO.running or IVORY_MACRO.runToken ~= token then break end

                        if skill ~= "" then
                            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                            local toolName = tool and tool.Name or ""
                            local cd = IVORY_MACRO.waitForSmartCooldownReady(toolName, skill, token, 1.5)
                            if cd then
                                local delivered, derr = IVORY_MACRO.castSmartStep(resolved, skill, skillKeyToCode[skill], token)
                                if not delivered then
                                    error("Block " .. i .. " " .. tostring(derr))
                                end
                                IVORY_MACRO.waitForSmartCooldown(cd, token, 1.5, toolName, skill)
                                IVORY_MACRO.runPostSkillJumps(step.jumpsAfter, token)
                            end
                        end
                    end
                end
            end
        end)

        IVORY_MACRO.currentBlockIndex = nil
        context.done = true
        if IVORY_MACRO.runToken == token then
            IVORY_MACRO.stopRun(ok and "complete" or "error", true, context)
            if not ok then
                warn("[IvoryHub] Smart Macro stopped: " .. tostring(err))
            end
        end
        IVORY_MACRO.contextByThread[coroutine.running()] = nil
    end)
end

function IVORY_MACRO.stopRun(reason, alreadyCancelled, target)
    local ctx = IVORY_MACRO.runContext
    if target and ctx ~= target then return true end
    if not ctx then
        IVORY_MACRO.pendingRun = nil
        return true
    end
    if ctx.cleaning then return true end
    ctx.cleaning = true
    ctx.cancelled = true
    ctx.state = "STOPPING"
    IVORY_MACRO.runToken = (IVORY_MACRO.runToken or 0) + 1
    IVORY_MACRO.releaseActiveInput(ctx.id)
    if IVORY_MACRO.mobile and IVORY_MACRO.mobile.releaseAll then
        pcall(IVORY_MACRO.mobile.releaseAll)
    end
    for _, conn in ipairs(ctx.connections or {}) do
        pcall(function() conn:Disconnect() end)
    end
    ctx.cleaning = false
    IVORY_MACRO.runContext = nil
    IVORY_MACRO.running = false
    IVORY_MACRO.currentBlockIndex = nil
    return true
end

function IVORY_MACRO.requestRun(slotIndex, source)
    slotIndex = tonumber(slotIndex)
    if not slotIndex or slotIndex % 1 ~= 0 or slotIndex < 1 or slotIndex > IVORY_MACRO.SLOT_COUNT then
        return false
    end
    if IVORY_MACRO.runContext and IVORY_MACRO.runContext.slotIndex == slotIndex then
        IVORY_MACRO.stopRun("toggle off", false, IVORY_MACRO.runContext)
        return true
    end
    local snap = IVORY_MACRO.slots[slotIndex]
    if not snap then return false end

    IVORY_MACRO.pendingRun = {
        slotIndex = slotIndex,
        snapshot = snap,
        capturedName = tostring(snap.name or ("Slot " .. slotIndex)),
        triggerSource = source or "manual",
        startedAt = tick(),
        connections = {},
    }
    IVORY_MACRO.intentVersion = (IVORY_MACRO.intentVersion or 0) + 1

    if IVORY_MACRO.runContext then
        IVORY_MACRO.stopRun("replacement", false, IVORY_MACRO.runContext)
    end
    IVORY_MACRO.runToken = (IVORY_MACRO.runToken or 0) + 1
    local ctx = IVORY_MACRO.pendingRun
    ctx.id = IVORY_MACRO.runToken
    IVORY_MACRO.pendingRun = nil
    IVORY_MACRO.runSlot(ctx)
    return true
end

print("[IvoryHub] Smart Macro engine loaded (5 slots x 8 blocks)")
-- =============================================
-- IVORY SMART MACRO — UI
-- =============================================
local MacroPageUI = CreatePage("SmartMacro")

local slotButtons = {}
local slotStatusLabel = nil
local slotNameBox = nil
local blockRows = {}
local activeSlotPreview = 1

local function refreshSlotBar()
    for i, btn in ipairs(slotButtons) do
        local isActive = i == activeSlotPreview
        btn.BackgroundColor3 = isActive and COLORS.ACCENT or COLORS.CARD
        btn.TextColor3 = isActive and COLORS.BLACK or COLORS.WHITE
        btn.Text = IVORY_MACRO.slots[i].name
    end
    if slotNameBox and not slotNameBox:IsFocused() then
        slotNameBox.Text = IVORY_MACRO.slots[activeSlotPreview].name
    end
    if slotStatusLabel then
        slotStatusLabel.Text = "Editing: " .. IVORY_MACRO.slots[activeSlotPreview].name
    end
end

local function refreshBlockRow(index)
    local step = IVORY_MACRO.slots[activeSlotPreview].steps[index]
    local row = blockRows[index]
    if not row then return end
    row.header.Text = "Block " .. index .. (step.enabled and "  [ON]" or "  [OFF]")
    row.header.TextColor3 = step.enabled and COLORS.GREEN or COLORS.GRAY
    row.enableBtn.Text = step.enabled and "ON" or "OFF"
    row.enableBtn.BackgroundColor3 = step.enabled and COLORS.ACCENT or COLORS.DARKER
    row.weaponBtn.Text = step.weapon
    row.skillBtn.Text = step.skill
    row.modeBtn.Text = step.mode
    row.holdLbl.Text = step.mode == "Hold" and ("Hold: " .. step.hold .. "s") or ""
    row.jumpsBtn.Text = step.jumpsAfter > 0 and ("Jump x" .. step.jumpsAfter) or "Jump: None"
    row.fallbackBtn.Text = step.fallbackEnabled and
        ("Backup: " .. step.fallbackWeapon .. " " .. step.fallbackSkill) or "Backup: OFF"
    row.fallbackBtn.TextColor3 = step.fallbackEnabled and COLORS.ACCENT or COLORS.GRAY
end

local function cycleField(slot, key, options)
    local cur = slot[key]
    local idx = 1
    for i, o in ipairs(options) do if o == cur then idx = i break end end
    idx = idx % #options + 1
    slot[key] = options[idx]
end

Section(MacroPageUI, "SMART MACRO")

local slotBar = Instance.new("Frame")
slotBar.Size = UDim2.new(1, 0, 0, 32)
slotBar.BackgroundTransparency = 1
slotBar.Parent = MacroPageUI

local slotLayout = Instance.new("UIListLayout")
slotLayout.FillDirection = Enum.FillDirection.Horizontal
slotLayout.Padding = UDim.new(0, 4)
slotLayout.SortOrder = Enum.SortOrder.LayoutOrder
slotLayout.Parent = slotBar

for i = 1, IVORY_MACRO.SLOT_COUNT do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -4, 1, 0)
    btn.BackgroundColor3 = COLORS.CARD
    btn.TextColor3 = COLORS.WHITE
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = IVORY_MACRO.slots[i].name
    btn.LayoutOrder = i
    btn.Parent = slotBar
    Corner(btn, 8)
    Stroke(btn, Color3.fromRGB(35,35,35), 1)
    AttachClickAnim(btn)
    slotButtons[i] = btn
    btn.MouseButton1Click:Connect(function()
        activeSlotPreview = i
        IVORY_MACRO.activeSlot = i
        refreshSlotBar()
        for idx = 1, IVORY_MACRO.BLOCK_COUNT do
            refreshBlockRow(idx)
        end
        -- Refresh the extra-action rows
        local s = IVORY_MACRO.slots[activeSlotPreview]
        soruBtn.Text = s.soruEnabled and "ON" or "OFF"
        soruBtn.BackgroundColor3 = s.soruEnabled and COLORS.ACCENT or COLORS.DARKER
        v3Btn.Text = s.v3Enabled and "ON" or "OFF"
        v3Btn.BackgroundColor3 = s.v3Enabled and COLORS.ACCENT or COLORS.DARKER
        m1Btn.Text = s.m1Enabled and "ON" or "OFF"
        m1Btn.BackgroundColor3 = s.m1Enabled and COLORS.ACCENT or COLORS.DARKER
    end)
end

slotStatusLabel = Text(MacroPageUI, "Editing: Slot 1", 10, false)
slotStatusLabel.Size = UDim2.new(1, -10, 0, 16)
slotStatusLabel.Position = UDim2.new(0, 5, 0, 0)
slotStatusLabel.TextColor3 = COLORS.ACCENT

Section(MacroPageUI, "SLOT NAME")
slotNameBox = Instance.new("TextBox")
slotNameBox.Size = UDim2.new(1, -10, 0, 30)
slotNameBox.BackgroundColor3 = COLORS.CARD
slotNameBox.BorderSizePixel = 0
slotNameBox.Text = IVORY_MACRO.slots[1].name
slotNameBox.TextColor3 = COLORS.WHITE
slotNameBox.TextSize = 11
slotNameBox.Font = Enum.Font.GothamMedium
slotNameBox.ClearTextOnFocus = false
slotNameBox.Parent = MacroPageUI
Corner(slotNameBox, 8)
Stroke(slotNameBox, Color3.fromRGB(35,35,35), 1)
slotNameBox.FocusLost:Connect(function()
    local t = tostring(slotNameBox.Text):match("^%s*(.-)%s*$")
    if t == "" then t = "Slot " .. activeSlotPreview end
    IVORY_MACRO.slots[activeSlotPreview].name = t:sub(1, 28)
    slotNameBox.Text = IVORY_MACRO.slots[activeSlotPreview].name
    refreshSlotBar()
    IVORY_MACRO.Save()
end)

Section(MacroPageUI, "STATUS")
local macroStatusLbl = Text(MacroPageUI, "IDLE", 11, true)
macroStatusLbl.Size = UDim2.new(1, -10, 0, 18)
macroStatusLbl.Position = UDim2.new(0, 5, 0, 0)
macroStatusLbl.TextColor3 = COLORS.GRAY

task.spawn(function()
    while Gui and Gui.Parent do
        if IVORY_MACRO.running and IVORY_MACRO.runContext then
            local ctx = IVORY_MACRO.runContext
            macroStatusLbl.Text = "RUNNING \226\128\162 Slot " .. tostring(ctx.slotIndex) ..
                " \226\128\162 Block " .. tostring(IVORY_MACRO.currentBlockIndex or "-")
            macroStatusLbl.TextColor3 = COLORS.GREEN
            if MacroBtn then
                MacroBtn.Text = "STOP"
                MacroBtn.BackgroundColor3 = COLORS.RED
            end
        else
            macroStatusLbl.Text = "IDLE"
            macroStatusLbl.TextColor3 = COLORS.GRAY
            if MacroBtn then
                MacroBtn.Text = "MACRO"
                MacroBtn.BackgroundColor3 = COLORS.DARK
            end
        end
        task.wait(0.2)
    end
end)

Section(MacroPageUI, "EXTRA ACTIONS")

local soruRow = Instance.new("Frame")
soruRow.Size = UDim2.new(1, 0, 0, 28)
soruRow.BackgroundColor3 = COLORS.CARD
soruRow.BorderSizePixel = 0
soruRow.Parent = MacroPageUI
Corner(soruRow, 8)
Stroke(soruRow, Color3.fromRGB(35,35,35), 1)

local soruLbl = Text(soruRow, "Soru Aim (before block)", 10, false)
soruLbl.Position = UDim2.new(0, 10, 0, 0)
soruLbl.Size = UDim2.new(1, -80, 1, 0)

soruBtn = Instance.new("TextButton")
soruBtn.Size = UDim2.new(0, 60, 0, 22)
soruBtn.Position = UDim2.new(1, -66, 0.5, -11)
soruBtn.BackgroundColor3 = COLORS.DARKER
soruBtn.TextColor3 = COLORS.WHITE
soruBtn.TextSize = 10
soruBtn.Font = Enum.Font.GothamBold
soruBtn.BorderSizePixel = 0
soruBtn.Text = "OFF"
soruBtn.Parent = soruRow
Corner(soruBtn, 6)
Stroke(soruBtn, Color3.fromRGB(50,50,50), 1)
soruBtn.MouseButton1Click:Connect(function()
    local s = IVORY_MACRO.slots[activeSlotPreview]
    s.soruEnabled = not s.soruEnabled
    soruBtn.Text = s.soruEnabled and "ON" or "OFF"
    soruBtn.BackgroundColor3 = s.soruEnabled and COLORS.ACCENT or COLORS.DARKER
    IVORY_MACRO.Save()
end)

local v3Row = Instance.new("Frame")
v3Row.Size = UDim2.new(1, 0, 0, 28)
v3Row.BackgroundColor3 = COLORS.CARD
v3Row.BorderSizePixel = 0
v3Row.Parent = MacroPageUI
Corner(v3Row, 8)
Stroke(v3Row, Color3.fromRGB(35,35,35), 1)

local v3Lbl = Text(v3Row, "Race V3 (before block)", 10, false)
v3Lbl.Position = UDim2.new(0, 10, 0, 0)
v3Lbl.Size = UDim2.new(1, -80, 1, 0)

v3Btn = Instance.new("TextButton")
v3Btn.Size = UDim2.new(0, 60, 0, 22)
v3Btn.Position = UDim2.new(1, -66, 0.5, -11)
v3Btn.BackgroundColor3 = COLORS.DARKER
v3Btn.TextColor3 = COLORS.WHITE
v3Btn.TextSize = 10
v3Btn.Font = Enum.Font.GothamBold
v3Btn.BorderSizePixel = 0
v3Btn.Text = "OFF"
v3Btn.Parent = v3Row
Corner(v3Btn, 6)
Stroke(v3Btn, Color3.fromRGB(50,50,50), 1)
v3Btn.MouseButton1Click:Connect(function()
    local s = IVORY_MACRO.slots[activeSlotPreview]
    s.v3Enabled = not s.v3Enabled
    v3Btn.Text = s.v3Enabled and "ON" or "OFF"
    v3Btn.BackgroundColor3 = s.v3Enabled and COLORS.ACCENT or COLORS.DARKER
    IVORY_MACRO.Save()
end)

local m1Row = Instance.new("Frame")
m1Row.Size = UDim2.new(1, 0, 0, 28)
m1Row.BackgroundColor3 = COLORS.CARD
m1Row.BorderSizePixel = 0
m1Row.Parent = MacroPageUI
Corner(m1Row, 8)
Stroke(m1Row, Color3.fromRGB(35,35,35), 1)

local m1Lbl = Text(m1Row, "Weapon M1 (before block)", 10, false)
m1Lbl.Position = UDim2.new(0, 10, 0, 0)
m1Lbl.Size = UDim2.new(1, -80, 1, 0)

m1Btn = Instance.new("TextButton")
m1Btn.Size = UDim2.new(0, 60, 0, 22)
m1Btn.Position = UDim2.new(1, -66, 0.5, -11)
m1Btn.BackgroundColor3 = COLORS.DARKER
m1Btn.TextColor3 = COLORS.WHITE
m1Btn.TextSize = 10
m1Btn.Font = Enum.Font.GothamBold
m1Btn.BorderSizePixel = 0
m1Btn.Text = "OFF"
m1Btn.Parent = m1Row
Corner(m1Btn, 6)
Stroke(m1Btn, Color3.fromRGB(50,50,50), 1)
m1Btn.MouseButton1Click:Connect(function()
    local s = IVORY_MACRO.slots[activeSlotPreview]
    s.m1Enabled = not s.m1Enabled
    m1Btn.Text = s.m1Enabled and "ON" or "OFF"
    m1Btn.BackgroundColor3 = s.m1Enabled and COLORS.ACCENT or COLORS.DARKER
    IVORY_MACRO.Save()
end)

Section(MacroPageUI, "SKILL BLOCKS")
for i = 1, IVORY_MACRO.BLOCK_COUNT do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 96)
    row.BackgroundColor3 = COLORS.CARD
    row.BorderSizePixel = 0
    row.Parent = MacroPageUI
    Corner(row, 8)
    Stroke(row, Color3.fromRGB(35,35,35), 1)

    local header = Text(row, "Block " .. i, 11, true)
    header.Position = UDim2.new(0, 10, 0, 6)
    header.Size = UDim2.new(1, -80, 0, 14)
    header.TextColor3 = COLORS.GRAY

    local enableBtn = Instance.new("TextButton")
    enableBtn.Size = UDim2.new(0, 60, 0, 22)
    enableBtn.Position = UDim2.new(1, -70, 0, 6)
    enableBtn.BackgroundColor3 = COLORS.DARKER
    enableBtn.TextColor3 = COLORS.WHITE
    enableBtn.TextSize = 10
    enableBtn.Font = Enum.Font.GothamBold
    enableBtn.BorderSizePixel = 0
    enableBtn.Text = "OFF"
    enableBtn.Parent = row
    Corner(enableBtn, 6)
    Stroke(enableBtn, Color3.fromRGB(50,50,50), 1)
    enableBtn.MouseButton1Click:Connect(function()
        local s = IVORY_MACRO.slots[activeSlotPreview].steps[i]
        s.enabled = not s.enabled
        refreshBlockRow(i)
        IVORY_MACRO.Save()
    end)

    local weaponBtn = Instance.new("TextButton")
    weaponBtn.Size = UDim2.new(0, 80, 0, 22)
    weaponBtn.Position = UDim2.new(0, 10, 0, 26)
    weaponBtn.BackgroundColor3 = COLORS.DARKER
    weaponBtn.TextColor3 = COLORS.WHITE
    weaponBtn.TextSize = 10
    weaponBtn.Font = Enum.Font.GothamBold
    weaponBtn.BorderSizePixel = 0
    weaponBtn.Text = "Melee"
    weaponBtn.Parent = row
    Corner(weaponBtn, 6)
    Stroke(weaponBtn, Color3.fromRGB(50,50,50), 1)
    weaponBtn.MouseButton1Click:Connect(function()
        local s = IVORY_MACRO.slots[activeSlotPreview].steps[i]
        cycleField(s, "weapon", IVORY_MACRO.WEAPONS)
        weaponBtn.Text = s.weapon
        IVORY_MACRO.Save()
    end)

    local skillBtn = Instance.new("TextButton")
    skillBtn.Size = UDim2.new(0, 40, 0, 22)
    skillBtn.Position = UDim2.new(0, 96, 0, 26)
    skillBtn.BackgroundColor3 = COLORS.DARKER
    skillBtn.TextColor3 = COLORS.WHITE
    skillBtn.TextSize = 10
    skillBtn.Font = Enum.Font.GothamBold
    skillBtn.BorderSizePixel = 0
    skillBtn.Text = "Z"
    skillBtn.Parent = row
    Corner(skillBtn, 6)
    Stroke(skillBtn, Color3.fromRGB(50,50,50), 1)
    skillBtn.MouseButton1Click:Connect(function()
        local s = IVORY_MACRO.slots[activeSlotPreview].steps[i]
        cycleField(s, "skill", IVORY_MACRO.SKILLS)
        skillBtn.Text = s.skill
        IVORY_MACRO.Save()
    end)

    local modeBtn = Instance.new("TextButton")
    modeBtn.Size = UDim2.new(0, 76, 0, 22)
    modeBtn.Position = UDim2.new(0, 142, 0, 26)
    modeBtn.BackgroundColor3 = COLORS.DARKER
    modeBtn.TextColor3 = COLORS.WHITE
    modeBtn.TextSize = 10
    modeBtn.Font = Enum.Font.GothamBold
    modeBtn.BorderSizePixel = 0
    modeBtn.Text = "Tap"
    modeBtn.Parent = row
    Corner(modeBtn, 6)
    Stroke(modeBtn, Color3.fromRGB(50,50,50), 1)
    modeBtn.MouseButton1Click:Connect(function()
        local s = IVORY_MACRO.slots[activeSlotPreview].steps[i]
        cycleField(s, "mode", IVORY_MACRO.CAST_MODES)
        modeBtn.Text = s.mode
        refreshBlockRow(i)
        IVORY_MACRO.Save()
    end)

    local holdLbl = Text(row, "", 9, false)
    holdLbl.Position = UDim2.new(0, 10, 0, 52)
    holdLbl.Size = UDim2.new(0, 100, 0, 12)
    holdLbl.TextColor3 = COLORS.GRAY

    local jumpsBtn = Instance.new("TextButton")
    jumpsBtn.Size = UDim2.new(0, 90, 0, 22)
    jumpsBtn.Position = UDim2.new(0, 10, 0, 66)
    jumpsBtn.BackgroundColor3 = COLORS.DARKER
    jumpsBtn.TextColor3 = COLORS.WHITE
    jumpsBtn.TextSize = 9
    jumpsBtn.Font = Enum.Font.GothamBold
    jumpsBtn.BorderSizePixel = 0
    jumpsBtn.Text = "Jump: None"
    jumpsBtn.Parent = row
    Corner(jumpsBtn, 6)
    Stroke(jumpsBtn, Color3.fromRGB(50,50,50), 1)
    jumpsBtn.MouseButton1Click:Connect(function()
        local s = IVORY_MACRO.slots[activeSlotPreview].steps[i]
        s.jumpsAfter = (s.jumpsAfter + 1) % 9
        refreshBlockRow(i)
        IVORY_MACRO.Save()
    end)

    local fallbackBtn = Instance.new("TextButton")
    fallbackBtn.Size = UDim2.new(0, 160, 0, 22)
    fallbackBtn.Position = UDim2.new(0, 108, 0, 66)
    fallbackBtn.BackgroundColor3 = COLORS.DARKER
    fallbackBtn.TextColor3 = COLORS.GRAY
    fallbackBtn.TextSize = 9
    fallbackBtn.Font = Enum.Font.GothamBold
    fallbackBtn.BorderSizePixel = 0
    fallbackBtn.Text = "Backup: OFF"
    fallbackBtn.Parent = row
    Corner(fallbackBtn, 6)
    Stroke(fallbackBtn, Color3.fromRGB(50,50,50), 1)
    fallbackBtn.MouseButton1Click:Connect(function()
        local s = IVORY_MACRO.slots[activeSlotPreview].steps[i]
        s.fallbackEnabled = not s.fallbackEnabled
        refreshBlockRow(i)
        IVORY_MACRO.Save()
    end)

    blockRows[i] = {
        header = header,
        enableBtn = enableBtn,
        weaponBtn = weaponBtn,
        skillBtn = skillBtn,
        modeBtn = modeBtn,
        holdLbl = holdLbl,
        jumpsBtn = jumpsBtn,
        fallbackBtn = fallbackBtn,
    }
end

Section(MacroPageUI, "CONTROLS")
Button(MacroPageUI, "START ACTIVE SLOT", function()
    IVORY_MACRO.requestRun(activeSlotPreview, "gui")
end)
Button(MacroPageUI, "STOP MACRO", function()
    IVORY_MACRO.stopRun("gui stop", false, IVORY_MACRO.runContext)
end)
Button(MacroPageUI, "RESET ACTIVE SLOT", function()
    local idx = activeSlotPreview
    IVORY_MACRO.slots[idx] = IVORY_MACRO.newEmptySlot(idx)
    refreshSlotBar()
    for i = 1, IVORY_MACRO.BLOCK_COUNT do refreshBlockRow(i) end
    IVORY_MACRO.Save()
end)

refreshSlotBar()
for i = 1, IVORY_MACRO.BLOCK_COUNT do refreshBlockRow(i) end

-- =============================================
-- MACRO DRAGGABLE BUTTON
-- =============================================
MacroBtn = Instance.new("TextButton")
MacroBtn.Name = "IvoryMacroBtn"
MacroBtn.Size = UDim2.fromOffset(70, 70)
MacroBtn.Position = UDim2.new(0.85, -35, 0.7, -35)
MacroBtn.BackgroundColor3 = COLORS.DARK
MacroBtn.BackgroundTransparency = 0.15
MacroBtn.Text = "MACRO"
MacroBtn.TextColor3 = COLORS.WHITE
MacroBtn.TextSize = 11
MacroBtn.Font = Enum.Font.GothamBold
MacroBtn.BorderSizePixel = 0
MacroBtn.Visible = false
MacroBtn.Parent = Gui
Corner(MacroBtn, 999)
Stroke(MacroBtn, COLORS.ACCENT_DIM, 1.5)

local macroDrag = {active=false, moved=false, startPos=nil, startMouse=nil}
MacroBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        macroDrag.active = true
        macroDrag.moved = false
        macroDrag.startMouse = input.Position
        macroDrag.startPos = MacroBtn.Position
    end
end)
MacroBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        macroDrag.active = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not macroDrag.active then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - macroDrag.startMouse
    if delta.Magnitude > 6 then macroDrag.moved = true end
    MacroBtn.Position = UDim2.new(
        macroDrag.startPos.X.Scale, macroDrag.startPos.X.Offset + delta.X,
        macroDrag.startPos.Y.Scale, macroDrag.startPos.Y.Offset + delta.Y)
end)
MacroBtn.MouseButton1Click:Connect(function()
    if macroDrag.moved then return end
    if IVORY_MACRO.running then
        IVORY_MACRO.stopRun("button", false, IVORY_MACRO.runContext)
    else
        IVORY_MACRO.requestRun(IVORY_MACRO.activeSlot, "button")
    end
end)

Toggle(MacroPageUI, "Enable Macro Button", false, function(s)
    MacroBtn.Visible = s
    Features.Macro = s
    SaveConfig()
end)

-- =============================================
-- ADD "SMART MACRO" TAB
-- =============================================
local function addSmartMacroTab()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = COLORS.DARKER
    btn.BorderSizePixel = 0
    btn.Text = "  \240\159\142\174  SMART"
    btn.TextColor3 = COLORS.GRAY
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Corner(btn, 8)
    Stroke(btn, Color3.fromRGB(35,35,35), 1)
    AttachClickAnim(btn)

    table.insert(Tabs, {name="SMARTMACRO", icon="\240\159\142\174", page=MacroPageUI, button=btn})

    btn.MouseEnter:Connect(function()
        if MacroPageUI.Visible then return end
        TweenIt(btn, {BackgroundColor3 = Color3.fromRGB(30,30,30)})
    end)
    btn.MouseLeave:Connect(function()
        if MacroPageUI.Visible then return end
        TweenIt(btn, {BackgroundColor3 = COLORS.DARKER})
    end)

    btn.MouseButton1Click:Connect(function()
        for _, d in ipairs(Tabs) do
            if d.button then
                TweenIt(d.button, {BackgroundColor3 = COLORS.DARKER}, 0.2)
                d.button.TextColor3 = COLORS.GRAY
            end
            if d.page then d.page.Visible = false end
        end
        TweenIt(btn, {BackgroundColor3 = COLORS.ACCENT}, 0.2)
        btn.TextColor3 = COLORS.WHITE
        MacroPageUI.Visible = true
    end)
end

addSmartMacroTab()

print("[IvoryHub] Smart Macro UI loaded")
