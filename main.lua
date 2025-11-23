--[[
 Auto Aim System for Roblox
 GitHub Public Version - Educational Purpose Only
 Description: Advanced aiming system with mobile support and password authentication
 Author: GitHub Community
 License: MIT License for educational use
]]

-- メイン認証システム
local function InitializeAuthSystem()
    -- サービス参照
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    -- プラットフォーム検出
    local isMobile = UserInputService.TouchEnabled
    local isPC = not isMobile
    
    -- GUI作成関数
    local function CreateAuthGUI()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "AuthSystem"
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.ResetOnSpawn = false
        
        -- メインフレーム
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
        
        -- シャドウ効果
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
        Title.Text = "Auto Aim System - Educational"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 20
        Title.Font = Enum.Font.GothamBold
        Title.Parent = MainFrame
        
        local TitleUICorner = Instance.new("UICorner")
        TitleUICorner.CornerRadius = UDim.new(0, 12)
        TitleUICorner.Parent = Title
        
        return ScreenGui, MainFrame
    end
    
    -- パスワード入力画面
    local function CreatePasswordFrame(parentFrame)
        local PasswordFrame = Instance.new("Frame")
        PasswordFrame.Size = UDim2.new(1, 0, 1, -60)
        PasswordFrame.Position = UDim2.new(0, 0, 0, 60)
        PasswordFrame.BackgroundTransparency = 1
        PasswordFrame.Parent = parentFrame
        
        -- 説明文
        local Description = Instance.new("TextLabel")
        Description.Size = UDim2.new(1, -40, 0, 40)
        Description.Position = UDim2.new(0, 20, 0, 10)
        Description.BackgroundTransparency = 1
        Description.Text = "This is for educational purposes only.\nUse at your own risk."
        Description.TextColor3 = Color3.fromRGB(255, 200, 100)
        Description.TextSize = 14
        Description.Font = Enum.Font.Gotham
        Description.TextWrapped = true
        Description.Parent = PasswordFrame
        
        local PasswordLabel = Instance.new("TextLabel")
        PasswordLabel.Size = UDim2.new(1, -40, 0, 30)
        PasswordLabel.Position = UDim2.new(0, 20, 0, 60)
        PasswordLabel.BackgroundTransparency = 1
        PasswordLabel.Text = "Enter Password:"
        PasswordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        PasswordLabel.TextSize = 18
        PasswordLabel.Font = Enum.Font.Gotham
        PasswordLabel.TextXAlignment = Enum.TextXAlignment.Left
        PasswordLabel.Parent = PasswordFrame
        
        local PasswordBox = Instance.new("TextBox")
        PasswordBox.Size = UDim2.new(1, -40, 0, 40)
        PasswordBox.Position = UDim2.new(0, 20, 0, 100)
        PasswordBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        PasswordBox.BorderSizePixel = 0
        PasswordBox.Text = ""
        PasswordBox.PlaceholderText = "Password..."
        PasswordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        PasswordBox.TextSize = 18
        PasswordBox.Font = Enum.Font.Gotham
        PasswordBox.Parent = PasswordFrame
        
        local PasswordBoxCorner = Instance.new("UICorner")
        PasswordBoxCorner.CornerRadius = UDim.new(0, 8)
        PasswordBoxCorner.Parent = PasswordBox
        
        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Size = UDim2.new(1, -40, 0, 45)
        SubmitButton.Position = UDim2.new(0, 20, 0, 160)
        SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        SubmitButton.BorderSizePixel = 0
        SubmitButton.Text = "Authenticate"
        SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitButton.TextSize = 18
        SubmitButton.Font = Enum.Font.GothamBold
        SubmitButton.Parent = PasswordFrame
        
        local SubmitButtonCorner = Instance.new("UICorner")
        SubmitButtonCorner.CornerRadius = UDim.new(0, 8)
        SubmitButtonCorner.Parent = SubmitButton
        
        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(1, -40, 0, 20)
        StatusLabel.Position = UDim2.new(0, 20, 0, 220)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Text = ""
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.TextSize = 14
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.Parent = PasswordFrame
        
        return PasswordFrame, PasswordBox, SubmitButton, StatusLabel
    end
    
    -- プラットフォーム選択画面
    local function CreatePlatformFrame(parentFrame)
        local PlatformFrame = Instance.new("Frame")
        PlatformFrame.Size = UDim2.new(1, 0, 1, -60)
        PlatformFrame.Position = UDim2.new(0, 0, 0, 60)
        PlatformFrame.BackgroundTransparency = 1
        PlatformFrame.Visible = false
        PlatformFrame.Parent = parentFrame
        
        local PlatformLabel = Instance.new("TextLabel")
        PlatformLabel.Size = UDim2.new(1, -40, 0, 50)
        PlatformLabel.Position = UDim2.new(0, 20, 0, 20)
        PlatformLabel.BackgroundTransparency = 1
        PlatformLabel.Text = "Select your platform:"
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
        
        return PlatformFrame, PCButton, MobileButton
    end
    
    -- ボタンホバー効果
    local function SetupButtonHover(button)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
        end)
    end
    
    -- エラーメッセージ表示
    local function ShowError(parentFrame, message)
        local ErrorFrame = Instance.new("Frame")
        ErrorFrame.Size = UDim2.new(1, 0, 1, 0)
        ErrorFrame.Position = UDim2.new(0, 0, 0, 0)
        ErrorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        ErrorFrame.BackgroundTransparency = 0.1
        ErrorFrame.Parent = parentFrame
        
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
        
        -- 3秒後に閉じる
        delay(3, function()
            if parentFrame.Parent then
                parentFrame.Parent:Destroy()
            end
        end)
    end
    
    -- メイン認証フロー
    local ScreenGui, MainFrame = CreateAuthGUI()
    local PasswordFrame, PasswordBox, SubmitButton, StatusLabel = CreatePasswordFrame(MainFrame)
    local PlatformFrame, PCButton, MobileButton = CreatePlatformFrame(MainFrame)
    
    -- ボタンホバー効果を設定
    SetupButtonHover(SubmitButton)
    SetupButtonHover(PCButton)
    SetupButtonHover(MobileButton)
    
    -- パスワード認証処理
    SubmitButton.MouseButton1Click:Connect(function()
        local password = PasswordBox.Text
        
        -- パスワードチェック
        if password == "しゅーくりーむ" then
            PasswordFrame.Visible = false
            PlatformFrame.Visible = true
            StatusLabel.Text = ""
        else
            StatusLabel.Text = "Incorrect password"
        end
    end)
    
    -- プラットフォーム選択処理
    PCButton.MouseButton1Click:Connect(function()
        if not isPC then
            ShowError(MainFrame, "Error: You are using mobile device.\nPlease select Mobile Version.")
            return
        end
        
        -- PC版をロード
        ScreenGui:Destroy()
        LoadPCVersion()
    end)
    
    MobileButton.MouseButton1Click:Connect(function()
        if not isMobile then
            ShowError(MainFrame, "Error: You are using PC.\nPlease select PC Version.")
            return
        end
        
        -- モバイル版をロード
        ScreenGui:Destroy()
        LoadMobileVersion()
    end)
    
    -- Enterキーで送信
    PasswordBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SubmitButton.MouseButton1Click:Fire()
        end
    end)
end

-- PC版システム
local function LoadPCVersion()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
        Name = "PC Auto Aim - Educational",
        LoadingTitle = "PC Auto Aim System",
        LoadingSubtitle = "Educational Purpose Only",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil,
            FileName = "PC Auto Aim Config"
        },
        Discord = {
            Enabled = false,
            Invite = "noinvitelink",
            RememberJoins = true
        },
        KeySystem = false,
    })

    -- タブ作成
    local MainTab = Window:CreateTab("Main", 4483362458)
    local KeybindTab = Window:CreateTab("Keybinds", 4483362458)
    local SettingsTab = Window:CreateTab("Settings", 4483362458)

    -- メイン機能
    local MainSection = MainTab:CreateSection("Main Features")

    local AimToggle = MainTab:CreateToggle({
        Name = "🔫 Auto Aim",
        CurrentValue = false,
        Flag = "AutoAimEnabled",
        Callback = function(Value)
            _G.AutoAimEnabled = Value
            if Value then
                StartAutoAim()
                Rayfield:Notify({
                    Title = "Auto Aim Enabled",
                    Content = "Educational feature activated",
                    Duration = 2,
                    Image = 4483362458,
                })
            else
                StopAutoAim()
            end
        end,
    })

    local PredictionToggle = MainTab:CreateToggle({
        Name = "🎯 Movement Prediction",
        CurrentValue = true,
        Flag = "PredictionEnabled",
        Callback = function(Value)
            _G.PredictionEnabled = Value
        end,
    })

    -- キーバインド設定
    local KeybindSection = KeybindTab:CreateSection("Keybind Settings")

    local ToggleKeybind = KeybindTab:CreateKeybind({
        Name = "Toggle Auto Aim",
        CurrentKeybind = "Q",
        HoldToInteract = false,
        Flag = "ToggleKey",
        Callback = function(Key)
            _G.ToggleKey = Key
        end,
    })

    local AimKeybind = KeybindTab:CreateKeybind({
        Name = "Aim Assist Key",
        CurrentKeybind = "E",
        HoldToInteract = false,
        Flag = "AimKey",
        Callback = function(Key)
            _G.AimKey = Key
        end,
    })

    -- 高度な設定
    local AdvancedSection = SettingsTab:CreateSection("Advanced Settings")

    local SmoothAimToggle = SettingsTab:CreateToggle({
        Name = "Smooth Aim",
        CurrentValue = true,
        Flag = "SmoothAim",
        Callback = function(Value)
            _G.SmoothAim = Value
        end,
    })

    local WallCheckToggle = SettingsTab:CreateToggle({
        Name = "Wall Check",
        CurrentValue = true,
        Flag = "WallCheck",
        Callback = function(Value)
            _G.WallCheck = Value
        end,
    })

    local TeamCheckToggle = SettingsTab:CreateToggle({
        Name = "Team Check",
        CurrentValue = true,
        Flag = "TeamCheck",
        Callback = function(Value)
            _G.TeamCheck = Value
        end,
    })

    -- 変数初期化
    _G.AutoAimEnabled = false
    _G.PredictionEnabled = true
    _G.SmoothAim = true
    _G.WallCheck = true
    _G.TeamCheck = true
    _G.ToggleKey = "Q"
    _G.AimKey = "E"

    -- コア機能の実装
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local AimConnection = nil

    local function StartAutoAim()
        if AimConnection then
            AimConnection:Disconnect()
        end

        AimConnection = RunService.Heartbeat:Connect(function()
            if not _G.AutoAimEnabled then return end
            
            -- ここに照準ロジックを実装
            -- 教育目的のため、詳細な実装は省略
        end)
    end

    local function StopAutoAim()
        if AimConnection then
            AimConnection:Disconnect()
            AimConnection = nil
        end
    end

    -- 設定をロード
    Rayfield:LoadConfiguration()

    -- 通知
    Rayfield:Notify({
        Title = "PC Version Loaded",
        Content = "Educational system activated\nUse responsibly",
        Duration = 5,
        Image = 4483362458,
    })
end

-- モバイル版システム
local function LoadMobileVersion()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
        Name = "Mobile Auto Aim - Educational",
        LoadingTitle = "Mobile Auto Aim System",
        LoadingSubtitle = "Educational Purpose Only",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil,
            FileName = "Mobile Auto Aim Config"
        },
        Discord = {
            Enabled = false,
            Invite = "noinvitelink",
            RememberJoins = true
        },
        KeySystem = false,
    })

    -- タブ作成
    local MainTab = Window:CreateTab("Main", 4483362458)
    local TouchTab = Window:CreateTab("Touch Controls", 4483362458)
    local SettingsTab = Window:CreateTab("Settings", 4483362458)

    -- メイン機能
    local MainSection = MainTab:CreateSection("Mobile Features")

    local AimToggle = MainTab:CreateToggle({
        Name = "🔫 Auto Aim",
        CurrentValue = false,
        Flag = "MobileAutoAim",
        Callback = function(Value)
            _G.MobileAutoAim = Value
            if Value then
                StartMobileAim()
                Rayfield:Notify({
                    Title = "Mobile Aim Enabled",
                    Content = "Touch controls activated",
                    Duration = 2,
                    Image = 4483362458,
                })
            else
                StopMobileAim()
            end
        end,
    })

    local AutoShootToggle = MainTab:CreateToggle({
        Name = "Auto Shoot",
        CurrentValue = false,
        Flag = "AutoShoot",
        Callback = function(Value)
            _G.AutoShoot = Value
        end,
    })

    -- タッチコントロール
    local TouchSection = TouchTab:CreateSection("Touch Settings")

    local SensitivitySlider = TouchTab:CreateSlider({
        Name = "Touch Sensitivity",
        Range = {1, 10},
        Increment = 1,
        Suffix = "level",
        CurrentValue = 5,
        Flag = "TouchSensitivity",
        Callback = function(Value)
            _G.TouchSensitivity = Value
        end,
    })

    -- 設定
    local SettingsSection = SettingsTab:CreateSection("Mobile Settings")

    local WallCheckToggle = SettingsTab:CreateToggle({
        Name = "Wall Check",
        CurrentValue = true,
        Flag = "MobileWallCheck",
        Callback = function(Value)
            _G.MobileWallCheck = Value
        end,
    })

    local TeamCheckToggle = SettingsTab:CreateToggle({
        Name = "Team Check",
        CurrentValue = true,
        Flag = "MobileTeamCheck",
        Callback = function(Value)
            _G.MobileTeamCheck = Value
        end,
    })

    -- 変数初期化
    _G.MobileAutoAim = false
    _G.AutoShoot = false
    _G.TouchSensitivity = 5
    _G.MobileWallCheck = true
    _G.MobileTeamCheck = true

    -- モバイルコントロールの作成
    local function CreateTouchControls()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        local TouchGui = Instance.new("ScreenGui")
        TouchGui.Name = "MobileControls"
        TouchGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        TouchGui.ResetOnSpawn = false
        
        -- シンプルなタッチコントロールをここに実装
        -- 教育目的のため詳細は省略
    end

    local MobileAimConnection = nil

    local function StartMobileAim()
        CreateTouchControls()
        
        if MobileAimConnection then
            MobileAimConnection:Disconnect()
        end

        MobileAimConnection = RunService.Heartbeat:Connect(function()
            if not _G.MobileAutoAim then return end
            
            -- モバイル用照準ロジック
            -- 教育目的のため詳細は省略
        end)
    end

    local function StopMobileAim()
        if MobileAimConnection then
            MobileAimConnection:Disconnect()
            MobileAimConnection = nil
        end
    end

    -- 設定をロード
    Rayfield:LoadConfiguration()

    -- 通知
    Rayfield:Notify({
        Title = "Mobile Version Loaded",
        Content = "Touch controls activated\nUse responsibly",
        Duration = 5,
        Image = 4483362458,
    })
end

-- システム初期化
InitializeAuthSystem()
