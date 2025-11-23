local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Advanced Auto Shot System",
    LoadingTitle = "Advanced Auto Shot",
    LoadingSubtitle = "by Your Name",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Advanced Auto Shot"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

local AutoShotSection = MainTab:CreateSection("Auto Shot Configuration")

local AutoShotToggle = MainTab:CreateToggle({
    Name = "Enable Auto Shot",
    CurrentValue = false,
    Flag = "AutoShotEnabled",
    Callback = function(Value)
        _G.AutoShotEnabled = Value
        if Value then
            StartAutoShot()
        else
            StopAutoShot()
        end
    end,
})

local FireRateSlider = MainTab:CreateSlider({
    Name = "Fire Rate (shots/sec)",
    Range = {1, 20},
    Increment = 1,
    Suffix = "shots",
    CurrentValue = 5,
    Flag = "FireRate",
    Callback = function(Value)
        _G.FireRate = Value
    end,
})

local TargetPartDropdown = MainTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart", "Random"},
    CurrentOption = "Head",
    MultipleOptions = false,
    Flag = "TargetPart",
    Callback = function(Value)
        _G.TargetPart = Value
    end,
})

local WallCheckToggle = MainTab:CreateToggle({
    Name = "Wall Check (射線確認)",
    CurrentValue = true,
    Flag = "WallCheck",
    Callback = function(Value)
        _G.WallCheck = Value
    end,
})

local UseGunToggle = MainTab:CreateToggle({
    Name = "Auto Use Gun (自動で銃使用)",
    CurrentValue = true,
    Flag = "UseGun",
    Callback = function(Value)
        _G.UseGun = Value
    end,
})

local FOVSection = MainTab:CreateSection("FOV Settings")

local FOVCircleToggle = MainTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "ShowFOV",
    Callback = function(Value)
        _G.ShowFOV = Value
        UpdateFOVCircle()
    end,
})

local FOVSlider = MainTab:CreateSlider({
    Name = "FOV Radius",
    Range = {10, 1000},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 100,
    Flag = "FOVRadius",
    Callback = function(Value)
        _G.FOVRadius = Value
        UpdateFOVCircle()
    end,
})

local TeamCheckToggle = SettingsTab:CreateToggle({
    Name = "Team Check (チーム判定)",
    CurrentValue = true,
    Flag = "TeamCheck",
    Callback = function(Value)
        _G.TeamCheck = Value
    end,
})

local VisibleCheckToggle = SettingsTab:CreateToggle({
    Name = "Visible Check (可視判定)",
    CurrentValue = true,
    Flag = "VisibleCheck",
    Callback = function(Value)
        _G.VisibleCheck = Value
    end,
})

local MaxDistanceSlider = SettingsTab:CreateSlider({
    Name = "Max Distance",
    Range = {10, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 200,
    Flag = "MaxDistance",
    Callback = function(Value)
        _G.MaxDistance = Value
    end,
})

-- 変数初期化
_G.FireRate = 5
_G.TargetPart = "Head"
_G.FOVRadius = 100
_G.WallCheck = true
_G.UseGun = true
_G.TeamCheck = true
_G.VisibleCheck = true
_G.MaxDistance = 200

-- Auto Shotメインループ
local AutoShotConnection
local FOVCircle
local LastShotTime = 0

function StartAutoShot()
    if AutoShotConnection then
        AutoShotConnection:Disconnect()
    end
    
    AutoShotConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if _G.AutoShotEnabled then
            local currentTime = tick()
            if currentTime - LastShotTime >= (1 / _G.FireRate) then
                local target = FindTarget()
                if target then
                    if _G.UseGun then
                        EquipGun()
                    end
                    ShootAtTarget(target)
                    LastShotTime = currentTime
                end
            end
        end
    end)
end

function StopAutoShot()
    if AutoShotConnection then
        AutoShotConnection:Disconnect()
        AutoShotConnection = nil
    end
end

function IsBehindWall(targetPart)
    if not _G.WallCheck then return false end
    
    local localPlayer = game.Players.LocalPlayer
    local character = localPlayer.Character
    if not character then return true end
    
    local head = character:FindFirstChild("Head")
    if not head then return true end
    
    local origin = head.Position
    local targetPos = targetPart.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character, targetPart.Parent}
    
    local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
    
    return raycastResult ~= nil
end

function IsSameTeam(player)
    if not _G.TeamCheck then return false end
    
    local localPlayer = game.Players.LocalPlayer
    local localTeam = localPlayer.Team
    local targetTeam = player.Team
    
    return localTeam == targetTeam
end

function FindTarget()
    local closestPlayer = nil
    local closestDistance = _G.MaxDistance
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                -- チームチェック
                if IsSameTeam(player) then
                    continue
                end
                
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                
                if distance <= closestDistance and distance <= _G.MaxDistance then
                    -- 壁チェック
                    local targetPartName = _G.TargetPart
                    if targetPartName == "Random" then
                        local parts = {"Head", "Torso", "HumanoidRootPart"}
                        targetPartName = parts[math.random(1, #parts)]
                    end
                    
                    local targetPart = player.Character:FindFirstChild(targetPartName)
                    if targetPart and not IsBehindWall(targetPart) then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

function EquipGun()
    local localPlayer = game.Players.LocalPlayer
    local character = localPlayer.Character
    if not character then return end
    
    local backpack = localPlayer.Backpack
    local tool = nil
    
    -- バックパックから銃を探す
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and isGun(item) then
            tool = item
            break
        end
    end
    
    -- キャラクターが既にツールを持っているか確認
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") and isGun(item) then
            return -- 既に装備済み
        end
    end
    
    -- 銃を装備
    if tool then
        character.Humanoid:EquipTool(tool)
    end
end

function isGun(tool)
    -- ツールが銃かどうかを判定（ゲームによって調整が必要）
    local gunNames = {"Gun", "Pistol", "Rifle", "Shotgun", "Revolver", "AK", "M4", "Weapon"}
    local toolName = tool.Name:lower()
    
    for _, gunName in ipairs(gunNames) do
        if string.find(toolName, gunName:lower()) then
            return true
        end
    end
    
    -- ツールに特定の属性があるかチェック
    if tool:FindFirstChild("Ammo") or tool:FindFirstChild("Damage") or tool:FindFirstChild("Fire") then
        return true
    end
    
    return false
end

function ShootAtTarget(player)
    local targetPartName = _G.TargetPart
    if targetPartName == "Random" then
        local parts = {"Head", "Torso", "HumanoidRootPart"}
        targetPartName = parts[math.random(1, #parts)]
    end
    
    local targetPart = player.Character:FindFirstChild(targetPartName)
    if targetPart then
        -- マウスターゲットを設定（一部ゲームで有効）
        setMouseTarget(targetPart)
        
        -- ツールを使用して射撃
        useTool()
        
        -- デバッグ用メッセージ
        print("Shooting at: " .. player.Name .. "'s " .. targetPartName)
    end
end

function setMouseTarget(targetPart)
    -- マウスターゲットを設定する方法（ゲームによって異なる）
    local localPlayer = game.Players.LocalPlayer
    local mouse = localPlayer:GetMouse()
    
    -- この部分はゲームによって大幅に変更が必要
    pcall(function()
        mouse.Target = targetPart
        mouse.Hit = CFrame.new(targetPart.Position)
    end)
end

function useTool()
    local localPlayer = game.Players.LocalPlayer
    local character = localPlayer.Character
    if not character then return end
    
    -- 装備中のツールを探す
    local tool = nil
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            tool = item
            break
        end
    end
    
    if tool then
        -- ツールのアクティベート（マウスクリックのエミュレート）
        tool:Activate()
        
        -- リモートイベントを使用する場合（ゲームによって異なる）
        activateRemoteEvents(tool)
    end
end

function activateRemoteEvents(tool)
    -- ツール内のリモートイベントを探して発火（ゲームによって異なる）
    for _, obj in ipairs(tool:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            if obj.Name == "Fire" or obj.Name == "Shoot" or obj.Name == "Activate" then
                pcall(function()
                    obj:FireServer()
                end)
            end
        elseif obj:IsA("RemoteFunction") then
            if obj.Name == "Fire" or obj.Name == "Shoot" or obj.Name == "Activate" then
                pcall(function()
                    obj:InvokeServer()
                end)
            end
        end
    end
end

function UpdateFOVCircle()
    -- FOV表示の更新（Drawingライブラリを使用）
    if _G.ShowFOV then
        if not FOVCircle then
            FOVCircle = Drawing.new("Circle")
            FOVCircle.Visible = true
            FOVCircle.Radius = _G.FOVRadius
            FOVCircle.Color = Color3.fromRGB(255, 255, 255)
            FOVCircle.Thickness = 2
            FOVCircle.Filled = false
        end
        
        local localPlayer = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera
        FOVCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        FOVCircle.Radius = _G.FOVRadius
    else
        if FOVCircle then
            FOVCircle:Remove()
            FOVCircle = nil
        end
    end
end

-- キーバインド設定
local Keybind = MainTab:CreateKeybind({
    Name = "Auto Shot Toggle",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "ToggleKeybind",
    Callback = function(Key)
        AutoShotToggle:Set(not _G.AutoShotEnabled)
    end,
})

-- カメラ変更時にFOV円を更新
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    if _G.ShowFOV and FOVCircle then
        UpdateFOVCircle()
    end
end)

-- 設定保存
Rayfield:LoadConfiguration()

-- 終了時処理
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    StopAutoShot()
end)

-- プレイヤーが変更されたときの処理
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
    if _G.AutoShotEnabled then
        wait(3) -- キャラクターのロード待機
        StartAutoShot()
    end
end)
