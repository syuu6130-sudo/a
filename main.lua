local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Auto Shot System",
    LoadingTitle = "Auto Shot",
    LoadingSubtitle = "by Your Name",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Auto Shot"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)

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
    Options = {"Head", "Torso", "Random"},
    CurrentOption = "Head",
    MultipleOptions = false,
    Flag = "TargetPart",
    Callback = function(Value)
        _G.TargetPart = Value
    end,
})

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

-- 変数初期化
_G.FireRate = 5
_G.TargetPart = "Head"
_G.FOVRadius = 100

-- Auto Shotメインループ
local AutoShotConnection
local FOVCircle

function StartAutoShot()
    if AutoShotConnection then
        AutoShotConnection:Disconnect()
    end
    
    AutoShotConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if _G.AutoShotEnabled then
            -- ここに射撃ロジックを実装
            local target = FindTarget()
            if target then
                ShootAtTarget(target)
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

function FindTarget()
    -- ターゲット検索ロジック
    local closestPlayer = nil
    local closestDistance = _G.FOVRadius
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                
                if distance <= closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer
end

function ShootAtTarget(player)
    -- 射撃ロジック
    local targetPartName = _G.TargetPart
    if targetPartName == "Random" then
        local parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
        targetPartName = parts[math.random(1, #parts)]
    end
    
    local targetPart = player.Character:FindFirstChild(targetPartName)
    if targetPart then
        -- ここに実際の射撃処理を実装
        -- 例: マウスターゲット設定やリモートイベント発火など
        print("Shooting at: " .. player.Name .. "'s " .. targetPartName)
    end
end

function UpdateFOVCircle()
    -- FOV表示の更新
    if _G.ShowFOV then
        if not FOVCircle then
            -- FOV円の作成ロジック
            -- 注: 実際の実装ではDrawingライブラリを使用するなど
        end
        -- FOV円の更新
    else
        -- FOV円の削除
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

-- 設定保存
Rayfield:LoadConfiguration()

-- 終了時処理
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    StopAutoShot()
end)
