-- パスワード認証システム
local function PasswordAuth()
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local GuiService = game:GetService("GuiService")
    
    -- メインGUI作成
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PasswordAuth"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- 背景フレーム
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.Size = UDim2.new(1, 14, 1, 14)
    DropShadow.Position = UDim2.new(0, -7, 0, -7)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Parent = MainFrame
    
    -- タイトル
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Title.BackgroundTransparency = 0
    Title.BorderSizePixel = 0
    Title.Text = "Auto Aim System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    local TitleUICorner = Instance.new("UICorner")
    TitleUICorner.CornerRadius = UDim.new(0, 12)
    TitleUICorner.Parent = Title
    
    -- パスワード入力画面
    local PasswordFrame = Instance.new("Frame")
    PasswordFrame.Size = UDim2.new(1, 0, 1, -60)
    PasswordFrame.Position = UDim2.new(0, 0, 0, 60)
    PasswordFrame.BackgroundTransparency = 1
    PasswordFrame.Parent = MainFrame
    
    local PasswordLabel = Instance.new("TextLabel")
    PasswordLabel.Size = UDim2.new(1, -40, 0, 30)
    PasswordLabel.Position = UDim2.new(0, 20, 0, 40)
    PasswordLabel.BackgroundTransparency = 1
    PasswordLabel.Text = "パスワードを入力してください:"
    PasswordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PasswordLabel.TextSize = 18
    PasswordLabel.Font = Enum.Font.Gotham
    PasswordLabel.TextXAlignment = Enum.TextXAlignment.Left
    PasswordLabel.Parent = PasswordFrame
    
    local PasswordBox = Instance.new("TextBox")
    PasswordBox.Size = UDim2.new(1, -40, 0, 40)
    PasswordBox.Position = UDim2.new(0, 20, 0, 80)
    PasswordBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    PasswordBox.BorderSizePixel = 0
    PasswordBox.Text = ""
    PasswordBox.PlaceholderText = "パスワードを入力..."
    PasswordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    PasswordBox.TextSize = 18
    PasswordBox.Font = Enum.Font.Gotham
    PasswordBox.Parent = PasswordFrame
    
    local PasswordBoxCorner = Instance.new("UICorner")
    PasswordBoxCorner.CornerRadius = UDim.new(0, 8)
    PasswordBoxCorner.Parent = PasswordBox
    
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(1, -40, 0, 45)
    SubmitButton.Position = UDim2.new(0, 20, 0, 150)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Text = "認証"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 18
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Parent = PasswordFrame
    
    local SubmitButtonCorner = Instance.new("UICorner")
    SubmitButtonCorner.CornerRadius = UDim.new(0, 8)
    SubmitButtonCorner.Parent = SubmitButton
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 20)
    StatusLabel.Position = UDim2.new(0, 20, 0, 210)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = PasswordFrame
    
    -- プラットフォーム選択画面
    local PlatformFrame = Instance.new("Frame")
    PlatformFrame.Size = UDim2.new(1, 0, 1, -60)
    PlatformFrame.Position = UDim2.new(0, 0, 0, 60)
    PlatformFrame.BackgroundTransparency = 1
    PlatformFrame.Visible = false
    PlatformFrame.Parent = MainFrame
    
    local PlatformLabel = Instance.new("TextLabel")
    PlatformLabel.Size = UDim2.new(1, -40, 0, 50)
    PlatformLabel.Position = UDim2.new(0, 20, 0, 20)
    PlatformLabel.BackgroundTransparency = 1
    PlatformLabel.Text = "プラットフォームを選択してください\nSelect your platform:"
    PlatformLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlatformLabel.TextSize = 18
    PlatformLabel.Font = Enum.Font.Gotham
    PlatformLabel.TextYAlignment = Enum.TextYAlignment.Top
    PlatformLabel.Parent = PlatformFrame
    
    local PCButton = Instance.new("TextButton")
    PCButton.Size = UDim2.new(1, -40, 0, 60)
    PCButton.Position = UDim2.new(0, 20, 0, 90)
    PCButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    PCButton.BorderSizePixel = 0
    PCButton.Text = "🖥️ PC Version"
    PCButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PCButton.TextSize = 20
    PCButton.Font = Enum.Font.GothamBold
    PCButton.Parent = PlatformFrame
    
    local PCButtonCorner = Instance.new("UICorner")
    PCButtonCorner.CornerRadius = UDim.new(0, 8)
    PCButtonCorner.Parent = PCButton
    
    local MobileButton = Instance.new("TextButton")
    MobileButton.Size = UDim2.new(1, -40, 0, 60)
    MobileButton.Position = UDim2.new(0, 20, 0, 165)
    MobileButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    MobileButton.BorderSizePixel = 0
    MobileButton.Text = "📱 Mobile Version"
    MobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MobileButton.TextSize = 20
    MobileButton.Font = Enum.Font.GothamBold
    MobileButton.Parent = PlatformFrame
    
    local MobileButtonCorner = Instance.new("UICorner")
    MobileButtonCorner.CornerRadius = UDim.new(0, 8)
    MobileButtonCorner.Parent = MobileButton
    
    -- ボタンのホバー効果
    local function setupButtonHover(button)
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
        end)
    end
    
    setupButtonHover(PCButton)
    setupButtonHover(MobileButton)
    setupButtonHover(SubmitButton)
    
    -- パスワード認証処理
    SubmitButton.MouseButton1Click:Connect(function()
        local password = PasswordBox.Text
        
        -- パスワードチェック（しゅーくりーむ）
        if password == "しゅーくりーむ" then
            PasswordFrame.Visible = false
            PlatformFrame.Visible = true
            StatusLabel.Text = ""
        else
            StatusLabel.Text = "パスワードが間違っています"
        end
    end)
    
    PasswordBox.Focused:Connect(function()
        PasswordBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end)
    
    PasswordBox.FocusLost:Connect(function()
        PasswordBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end)
    
    -- エラーメッセージ表示関数
    local function showError(message)
        local ErrorFrame = Instance.new("Frame")
        ErrorFrame.Size = UDim2.new(1, 0, 1, 0)
        ErrorFrame.Position = UDim2.new(0, 0, 0, 0)
        ErrorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        ErrorFrame.BackgroundTransparency = 0.1
        ErrorFrame.Parent = MainFrame
        
        local ErrorLabel = Instance.new("TextLabel")
        ErrorLabel.Size = UDim2.new(1, -40, 0, 100)
        ErrorLabel.Position = UDim2.new(0, 20, 0.5, -50)
        ErrorLabel.BackgroundTransparency = 1
        ErrorLabel.Text = message
        ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        ErrorLabel.TextSize = 18
        ErrorLabel.Font = Enum.Font.Gotham
        ErrorLabel.TextWrapped = true
        ErrorLabel.Parent = ErrorFrame
        
        wait(3)
        ScreenGui:Destroy()
        return false
    end
    
    -- プラットフォーム選択処理
    PCButton.MouseButton1Click:Connect(function()
        local isMobile = UserInputService.TouchEnabled
        local isPC = not isMobile
        
        if not isPC then
            showError("いいえ、あなたはmobileです。\nNo, you are using mobile.")
            return
        end
        
        -- PC版UIをロード
        ScreenGui:Destroy()
        loadPCVersion()
    end)
    
    MobileButton.MouseButton1Click:Connect(function()
        local isMobile = UserInputService.TouchEnabled
        
        if not isMobile then
            showError("いいえ、あなたはPCです。\nNo, you are using PC.")
            return
        end
        
        -- モバイル版UIをロード
        ScreenGui:Destroy()
        loadMobileVersion()
    end)
    
    -- Enterキーでパスワード送信
    PasswordBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SubmitButton.MouseButton1Click:Fire()
        end
    end)
end

-- PC版UI
local function loadPCVersion()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
        Name = "PC Auto Aim System",
        LoadingTitle = "PC Auto Aim System",
        LoadingSubtitle = "キーカスタマイズ可能",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil,
            FileName = "PC Auto Aim"
        },
        Discord = {
            Enabled = false,
            Invite = "noinvitelink",
            RememberJoins = true
        },
        KeySystem = false,
    })

    local MainTab = Window:CreateTab("Main", 4483362458)
    local KeybindTab = Window:CreateTab("Keybinds", 4483362458)
    local SettingsTab = Window:CreateTab("Settings", 4483362458)

    -- メイン設定
    local AutoAimSection = MainTab:CreateSection("Auto Aim")

    local AutoAimToggle = MainTab:CreateToggle({
        Name = "🔫 Auto Aim",
        CurrentValue = false,
        Flag = "AutoAimEnabled",
        Callback = function(Value)
            _G.AutoAimEnabled = Value
            if Value then
                StartAutoAim()
                Rayfield:Notify({
                    Title = "Auto Aim",
                    Content = "Auto Aim が有効になりました",
                    Duration = 2,
                    Image = 4483362458,
                })
            else
                StopAutoAim()
                Rayfield:Notify({
                    Title = "Auto Aim",
                    Content = "Auto Aim が無効になりました",
                    Duration = 2,
                    Image = 4483362458,
                })
            end
        end,
    })

    local PredictionToggle = MainTab:CreateToggle({
        Name = "🎯 Prediction (移動予測)",
        CurrentValue = true,
        Flag = "Prediction",
        Callback = function(Value)
            _G.Prediction = Value
        end,
    })

    local TargetPartDropdown = MainTab:CreateDropdown({
        Name = "🎯 Target Part",
        Options = {"Head", "Torso", "HumanoidRootPart", "Random"},
        CurrentOption = "Head",
        MultipleOptions = false,
        Flag = "TargetPart",
        Callback = function(Value)
            _G.TargetPart = Value
        end,
    })

    local WallCheckToggle = MainTab:CreateToggle({
        Name = "🧱 Wall Check (壁検知)",
        CurrentValue = true,
        Flag = "WallCheck",
        Callback = function(Value)
            _G.WallCheck = Value
        end,
    })

    -- キーバインド設定
    local KeybindSection = KeybindTab:CreateSection("Keybind Settings")

    local AimKeybind = KeybindTab:CreateKeybind({
        Name = "🎯 Aim Key",
        CurrentKeybind = "Q",
        HoldToInteract = false,
        Flag = "AimKey",
        Callback = function(Key)
            _G.AimKey = Key
        end,
    })

    local TriggerKeybind = KeybindTab:CreateKeybind({
        Name = "🔫 Trigger Key",
        CurrentKeybind = "E",
        HoldToInteract = false,
        Flag = "TriggerKey",
        Callback = function(Key)
            _G.TriggerKey = Key
        end,
    })

    local ToggleKeybind = KeybindTab:CreateKeybind({
        Name = "⚡ Toggle Key",
        CurrentKeybind = "T",
        HoldToInteract = false,
        Flag = "ToggleKey",
        Callback = function(Key)
            _G.ToggleKey = Key
        end,
    })

    -- 設定
    local SettingsSection = SettingsTab:CreateSection("Aim Settings")

    local AimSpeedSlider = SettingsTab:CreateSlider({
        Name = "⚡ Aim Speed",
        Range = {0.1, 5},
        Increment = 0.1,
        Suffix = "sec",
        CurrentValue = 1,
        Flag = "AimSpeed",
        Callback = function(Value)
            _G.AimSpeed = Value
        end,
    })

    local SmoothAimToggle = SettingsTab:CreateToggle({
        Name = "🌀 Smooth Aim (スムーズ照準)",
        CurrentValue = true,
        Flag = "SmoothAim",
        Callback = function(Value)
            _G.SmoothAim = Value
        end,
    })

    local TeamCheckToggle = SettingsTab:CreateToggle({
        Name = "👥 Team Check (チーム判定)",
        CurrentValue = true,
        Flag = "TeamCheck",
        Callback = function(Value)
            _G.TeamCheck = Value
        end,
    })

    local MaxDistanceSlider = SettingsTab:CreateSlider({
        Name = "📏 Max Distance",
        Range = {10, 500},
        Increment = 10,
        Suffix = "studs",
        CurrentValue = 200,
        Flag = "MaxDistance",
        Callback = function(Value)
            _G.MaxDistance = Value
        end,
    })

    -- FOV設定
    local FOVSection = SettingsTab:CreateSection("FOV Settings")

    local FOVCircleToggle = SettingsTab:CreateToggle({
        Name = "🔵 Show FOV Circle",
        CurrentValue = false,
        Flag = "ShowFOV",
        Callback = function(Value)
            _G.ShowFOV = Value
            UpdateFOVCircle()
        end,
    })

    local FOVSlider = SettingsTab:CreateSlider({
        Name = "🎯 FOV Radius",
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
    _G.AimSpeed = 1
    _G.TargetPart = "Head"
    _G.FOVRadius = 100
    _G.WallCheck = true
    _G.SmoothAim = true
    _G.TeamCheck = true
    _G.MaxDistance = 200
    _G.Prediction = true
    _G.AimKey = "Q"
    _G.TriggerKey = "E"
    _G.ToggleKey = "T"

    -- サービス
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer

    -- グローバル変数
    local AutoAimConnection
    local FOVCircle
    local LastTarget = nil

    -- 移動予測関数
    function PredictPosition(targetPart, bulletSpeed)
        if not _G.Prediction or not bulletSpeed then
            return targetPart.Position
        end
        
        local targetVelocity = Vector3.new(0, 0, 0)
        local rootPart = targetPart.Parent:FindFirstChild("HumanoidRootPart")
        if rootPart and rootPart.Velocity then
            targetVelocity = rootPart.Velocity
        end
        
        local localChar = LocalPlayer.Character
        if not localChar then return targetPart.Position end
        
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")
        if not localRoot then return targetPart.Position end
        
        local distance = (localRoot.Position - targetPart.Position).Magnitude
        local timeToTarget = distance / bulletSpeed
        
        local predictedPosition = targetPart.Position + (targetVelocity * timeToTarget)
        
        return predictedPosition
    end

    function StartAutoAim()
        if AutoAimConnection then
            AutoAimConnection:Disconnect()
        end
        
        AutoAimConnection = RunService.Heartbeat:Connect(function()
            if _G.AutoAimEnabled then
                local target, targetPart = FindTarget()
                if target and targetPart then
                    AimAtTarget(target, targetPart)
                    LastTarget = target
                else
                    LastTarget = nil
                end
            end
        end)
    end

    function StopAutoAim()
        if AutoAimConnection then
            AutoAimConnection:Disconnect()
            AutoAimConnection = nil
        end
        LastTarget = nil
    end

    function IsBehindWall(targetPart)
        if not _G.WallCheck then return false end
        
        local character = LocalPlayer.Character
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
        
        local localTeam = LocalPlayer.Team
        local targetTeam = player.Team
        
        return localTeam == targetTeam
    end

    function FindTarget()
        local closestPlayer = nil
        local closestDistance = _G.MaxDistance
        local closestPart = nil
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and humanoid.Health > 0 and rootPart then
                    if IsSameTeam(player) then
                        continue
                    end
                    
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    
                    if distance <= closestDistance and distance <= _G.MaxDistance then
                        local targetPartName = _G.TargetPart
                        if targetPartName == "Random" then
                            local parts = {"Head", "Torso", "HumanoidRootPart"}
                            targetPartName = parts[math.random(1, #parts)]
                        end
                        
                        local targetPart = player.Character:FindFirstChild(targetPartName) or rootPart
                        if targetPart and not IsBehindWall(targetPart) then
                            closestPlayer = player
                            closestDistance = distance
                            closestPart = targetPart
                        end
                    end
                end
            end
        end
        
        return closestPlayer, closestPart
    end

    function AimAtTarget(player, targetPart)
        if not player or not targetPart then return end
        
        local camera = workspace.CurrentCamera
        
        local bulletSpeed = 500
        local aimPosition = PredictPosition(targetPart, bulletSpeed)
        
        local screenPoint, onScreen = camera:WorldToScreenPoint(aimPosition)
        
        if onScreen then
            local mouse = LocalPlayer:GetMouse()
            
            if _G.SmoothAim then
                local currentPos = Vector2.new(mouse.X, mouse.Y)
                local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                local delta = (targetPos - currentPos) * (_G.AimSpeed * 0.1)
                
                mousemoverel(delta.X, delta.Y)
            else
                mousemoveabs(screenPoint.X, screenPoint.Y)
            end
        end
    end

    -- PC用マウス関数
    local VirtualInputManager = game:GetService("VirtualInputManager")
    function mousemoverel(dx, dy)
        pcall(function()
            VirtualInputManager:SendMouseMoveEvent(dx, dy, game)
        end)
    end

    function mousemoveabs(x, y)
        local mouse = LocalPlayer:GetMouse()
        pcall(function()
            mousemoverel(x - mouse.X, y - mouse.Y)
        end)
    end

    function mouse1click()
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            wait()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end)
    end

    function UpdateFOVCircle()
        if _G.ShowFOV then
            if not FOVCircle then
                FOVCircle = Drawing.new("Circle")
                FOVCircle.Visible = true
                FOVCircle.Radius = _G.FOVRadius
                FOVCircle.Color = Color3.fromRGB(0, 255, 0)
                FOVCircle.Thickness = 2
                FOVCircle.Filled = false
                FOVCircle.Transparency = 0.5
            end
            
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

    -- キー入力処理
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode[_G.ToggleKey] then
            AutoAimToggle:Set(not _G.AutoAimEnabled)
        elseif input.KeyCode == Enum.KeyCode[_G.AimKey] then
            -- 一時的な照準補助
        elseif input.KeyCode == Enum.KeyCode[_G.TriggerKey] then
            if _G.AutoAimEnabled and LastTarget then
                mouse1click()
            end
        end
    end)

    -- 設定保存
    Rayfield:LoadConfiguration()

    -- ステータス表示
    local StatusLabel = MainTab:CreateLabel("📊 ステータス: 待機中")

    RunService.Heartbeat:Connect(function()
        if _G.AutoAimEnabled and LastTarget then
            StatusLabel:Set("📊 ステータス: ターゲット追跡中: " .. LastTarget.Name)
        else
            StatusLabel:Set("📊 ステータス: 待機中")
        end
    end)

    Rayfield:Notify({
        Title = "PC Auto Aim System",
        Content = "PC版システムが読み込まれました\nキー設定: " .. _G.ToggleKey .. " - 切り替え, " .. _G.AimKey .. " - 照準, " .. _G.TriggerKey .. " - 射撃",
        Duration = 6.5,
        Image = 4483362458,
    })
end

-- モバイル版UI
local function loadMobileVersion()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
        Name = "Mobile Auto Aim System",
        LoadingTitle = "Mobile Auto Aim System",
        LoadingSubtitle = "タッチ操作最適化",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil,
            FileName = "Mobile Auto Aim"
        },
        Discord = {
            Enabled = false,
            Invite = "noinvitelink",
            RememberJoins = true
        },
        KeySystem = false,
    })

    local MainTab = Window:CreateTab("Main", 4483362458)
    local TouchTab = Window:CreateTab("Touch Settings", 4483362458)
    local SettingsTab = Window:CreateTab("Settings", 4483362458)

    -- メイン設定
    local AutoAimSection = MainTab:CreateSection("Auto Aim")

    local AutoAimToggle = MainTab:CreateToggle({
        Name = "🔫 Auto Aim",
        CurrentValue = false,
        Flag = "AutoAimEnabled",
        Callback = function(Value)
            _G.AutoAimEnabled = Value
            if Value then
                StartAutoAim()
                Rayfield:Notify({
                    Title = "Auto Aim",
                    Content = "Auto Aim が有効になりました",
                    Duration = 2,
                    Image = 4483362458,
                })
            else
                StopAutoAim()
                Rayfield:Notify({
                    Title = "Auto Aim",
                    Content = "Auto Aim が無効になりました",
                    Duration = 2,
                    Image = 4483362458,
                })
            end
        end,
    })

    local AutoShootToggle = MainTab:CreateToggle({
        Name = "🎯 Auto Shoot (自動射撃)",
        CurrentValue = false,
        Flag = "AutoShoot",
        Callback = function(Value)
            _G.AutoShoot = Value
        end,
    })

    local TargetPartDropdown = MainTab:CreateDropdown({
        Name = "🎯 Target Part",
        Options = {"Head", "Torso", "HumanoidRootPart", "Random"},
        CurrentOption = "Head",
        MultipleOptions = false,
        Flag = "TargetPart",
        Callback = function(Value)
            _G.TargetPart = Value
        end,
    })

    local WallCheckToggle = MainTab:CreateToggle({
        Name = "🧱 Wall Check (壁検知)",
        CurrentValue = true,
        Flag = "WallCheck",
        Callback = function(Value)
            _G.WallCheck = Value
        end,
    })

    -- タッチ設定
    local TouchSection = TouchTab:CreateSection("Touch Controls")

    local TouchSensitivity = TouchTab:CreateSlider({
        Name = "📱 Touch Sensitivity",
        Range = {1, 10},
        Increment = 1,
        Suffix = "level",
        CurrentValue = 5,
        Flag = "TouchSensitivity",
        Callback = function(Value)
            _G.TouchSensitivity = Value
        end,
    })

    local TouchAreaSize = TouchTab:CreateSlider({
        Name = "📱 Touch Area Size",
        Range = {50, 200},
        Increment = 10,
        Suffix = "pixels",
        CurrentValue = 100,
        Flag = "TouchAreaSize",
        Callback = function(Value)
            _G.TouchAreaSize = Value
            UpdateTouchControls()
        end,
    })

    local ShowTouchButtons = TouchTab:CreateToggle({
        Name = "👆 Show Touch Buttons",
        CurrentValue = true,
        Flag = "ShowTouchButtons",
        Callback = function(Value)
            _G.ShowTouchButtons = Value
            UpdateTouchControls()
        end,
    })

    -- 設定
    local SettingsSection = SettingsTab:CreateSection("Aim Settings")

    local AimSpeedSlider = SettingsTab:CreateSlider({
        Name = "⚡ Aim Speed",
        Range = {0.1, 5},
        Increment = 0.1,
        Suffix = "sec",
        CurrentValue = 1,
        Flag = "AimSpeed",
        Callback = function(Value)
            _G.AimSpeed = Value
        end,
    })

    local TeamCheckToggle = SettingsTab:CreateToggle({
        Name = "👥 Team Check (チーム判定)",
        CurrentValue = true,
        Flag = "TeamCheck",
        Callback = function(Value)
            _G.TeamCheck = Value
        end,
    })

    local MaxDistanceSlider = SettingsTab:CreateSlider({
        Name = "📏 Max Distance",
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
    _G.AimSpeed = 1
    _G.TargetPart = "Head"
    _G.WallCheck = true
    _G.TeamCheck = true
    _G.MaxDistance = 200
    _G.AutoShoot = false
    _G.TouchSensitivity = 5
    _G.TouchAreaSize = 100
    _G.ShowTouchButtons = true

    -- サービス
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer

    -- グローバル変数
    local AutoAimConnection
    local LastTarget = nil
    local TouchControls = {}

    -- タッチコントロール作成
    function CreateTouchControls()
        if not _G.ShowTouchButtons then return end
        
        local touchGui = Instance.new("ScreenGui")
        touchGui.Name = "MobileTouchControls"
        touchGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        touchGui.ResetOnSpawn = false
        
        -- 射撃ボタン
        local shootButton = Instance.new("TextButton")
        shootButton.Size = UDim2.new(0, _G.TouchAreaSize, 0, _G.TouchAreaSize)
        shootButton.Position = UDim2.new(1, -_G.TouchAreaSize - 20, 1, -_G.TouchAreaSize - 20)
        shootButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        shootButton.BackgroundTransparency = 0.3
        shootButton.Text = "🔫"
        shootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        shootButton.TextSize = _G.TouchAreaSize / 3
        shootButton.Parent = touchGui
        
        local shootCorner = Instance.new("UICorner")
        shootCorner.CornerRadius = UDim.new(1, 0)
        shootCorner.Parent = shootButton
        
        -- 照準ボタン
        local aimButton = Instance.new("TextButton")
        aimButton.Size = UDim2.new(0, _G.TouchAreaSize, 0, _G.TouchAreaSize)
        aimButton.Position = UDim2.new(1, -_G.TouchAreaSize - 20, 1, -_G.TouchAreaSize * 2 - 40)
        aimButton.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
        aimButton.BackgroundTransparency = 0.3
        aimButton.Text = "🎯"
        aimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        aimButton.TextSize = _G.TouchAreaSize / 3
        aimButton.Parent = touchGui
        
        local aimCorner = Instance.new("UICorner")
        aimCorner.CornerRadius = UDim.new(1, 0)
        aimCorner.Parent = aimButton
        
        -- ボタンアクション
        shootButton.MouseButton1Click:Connect(function()
            if _G.AutoAimEnabled and LastTarget then
                ShootAtTarget()
            end
        end)
        
        aimButton.MouseButton1Click:Connect(function()
            -- 一時的な照準補助
        end
        
        TouchControls = {touchGui, shootButton, aimButton}
    end

    function UpdateTouchControls()
        -- 既存のコントロールを削除
        for _, control in ipairs(TouchControls) do
            if control then
                control:Destroy()
            end
        end
        
        TouchControls = {}
        
        -- 新しいコントロールを作成
        if _G.ShowTouchButtons then
            CreateTouchControls()
        end
    end

    function StartAutoAim()
        if AutoAimConnection then
            AutoAimConnection:Disconnect()
        end
        
        AutoAimConnection = RunService.Heartbeat:Connect(function()
            if _G.AutoAimEnabled then
                local target, targetPart = FindTarget()
                if target and targetPart then
                    AimAtTarget(target, targetPart)
                    LastTarget = target
                    
                    -- 自動射撃
                    if _G.AutoShoot then
                        ShootAtTarget()
                    end
                else
                    LastTarget = nil
                end
            end
        end)
    end

    function StopAutoAim()
        if AutoAimConnection then
            AutoAimConnection:Disconnect()
            AutoAimConnection = nil
        end
        LastTarget = nil
    end

    function IsBehindWall(targetPart)
        if not _G.WallCheck then return false end
        
        local character = LocalPlayer.Character
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
        
        local localTeam = LocalPlayer.Team
        local targetTeam = player.Team
        
        return localTeam == targetTeam
    end

    function FindTarget()
        local closestPlayer = nil
        local closestDistance = _G.MaxDistance
        local closestPart = nil
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and humanoid.Health > 0 and rootPart then
                    if IsSameTeam(player) then
                        continue
                    end
                    
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    
                    if distance <= closestDistance and distance <= _G.MaxDistance then
                        local targetPartName = _G.TargetPart
                        if targetPartName == "Random" then
                            local parts = {"Head", "Torso", "HumanoidRootPart"}
                            targetPartName = parts[math.random(1, #parts)]
                        end
                        
                        local targetPart = player.Character:FindFirstChild(targetPartName) or rootPart
                        if targetPart and not IsBehindWall(targetPart) then
                            closestPlayer = player
                            closestDistance = distance
                            closestPart = targetPart
                        end
                    end
                end
            end
        end
        
        return closestPlayer, closestPart
    end

    function AimAtTarget(player, targetPart)
        if not player or not targetPart then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        -- キャラクターの向きを変更して照準
        local targetDirection = (targetPart.Position - character.HumanoidRootPart.Position).Unit
        local sensitivity = _G.TouchSensitivity * 0.1
        
        humanoid:Move(targetDirection * sensitivity)
    end

    function ShootAtTarget()
        -- モバイル用の射撃処理
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.ButtonA, false, game)
        wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.ButtonA, false, game)
    end

    -- 初期化
    CreateTouchControls()

    -- ステータス表示
    local StatusLabel = MainTab:CreateLabel("📱 ステータス: 待機中")

    RunService.Heartbeat:Connect(function()
        if _G.AutoAimEnabled and LastTarget then
            StatusLabel:Set("📱 ステータス: ターゲット追跡中: " .. LastTarget.Name)
        else
            StatusLabel:Set("📱 ステータス: 待機中")
        end
    end)

    Rayfield:Notify({
        Title = "Mobile Auto Aim System",
        Content = "モバイル版システムが読み込まれました\nタッチコントロールが有効です",
        Duration = 6.5,
        Image = 4483362458,
    })
end

-- パスワード認証開始
PasswordAuth()
