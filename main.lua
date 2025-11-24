-- 暗殺者対保安官2 v3 - 修正版
-- エラー309解決 & 確実なRayfieldロード

local function SafeLoadRayfield()
    local Rayfield = nil
    local maxAttempts = 3
    
    for attempt = 1, maxAttempts do
        local success, result = pcall(function()
            -- 複数のRayfieldソースから試行
            local sources = {
                'https://sirius.menu/rayfield',
                'https://raw.githubusercontent.com/shlexware/Rayfield/main/source',
                'https://raw.githubusercontent.com/Sirius0/rayfield/main/source'
            }
            
            for _, source in ipairs(sources) do
                local success, content = pcall(function()
                    return game:HttpGet(source, true)
                end)
                
                if success and content then
                    local loaded = loadstring(content)
                    if loaded then
                        return loaded()
                    end
                end
            end
            return nil
        end)
        
        if success and result then
            Rayfield = result
            break
        else
            warn("Rayfieldロード試行 " .. attempt .. "/" .. maxAttempts .. " 失敗")
            if attempt < maxAttempts then
                wait(1)
            end
        end
    end
    
    return Rayfield
end

-- シンプルな認証システム
local function SimpleAuthSystem()
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- プラットフォーム検出
    local isMobile = UserInputService.TouchEnabled
    local isPC = not isMobile
    
    -- シンプルなGUI作成
    local function CreateSimpleAuthGUI()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SimpleAuth"
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        ScreenGui.ResetOnSpawn = false
        
        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 400, 0, 250)
        MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = MainFrame
        
        -- タイトル
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 50)
        Title.Position = UDim2.new(0, 0, 0, 0)
        Title.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        Title.Text = "暗殺者対保安官2 v3"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 20
        Title.Font = Enum.Font.GothamBold
        Title.Parent = MainFrame
        
        -- 説明
        local Desc = Instance.new("TextLabel")
        Desc.Size = UDim2.new(1, -40, 0, 40)
        Desc.Position = UDim2.new(0, 20, 0, 60)
        Desc.BackgroundTransparency = 1
        Desc.Text = "パスワードを入力してください"
        Desc.TextColor3 = Color3.fromRGB(200, 200, 255)
        Desc.TextSize = 16
        Desc.Font = Enum.Font.Gotham
        Desc.Parent = MainFrame
        
        -- パスワード入力
        local PasswordBox = Instance.new("TextBox")
        PasswordBox.Size = UDim2.new(1, -40, 0, 40)
        PasswordBox.Position = UDim2.new(0, 20, 0, 110)
        PasswordBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        PasswordBox.PlaceholderText = "パスワード..."
        PasswordBox.Text = ""
        PasswordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        PasswordBox.TextSize = 18
        PasswordBox.Parent = MainFrame
        
        local PasswordCorner = Instance.new("UICorner")
        PasswordCorner.CornerRadius = UDim.new(0, 5)
        PasswordCorner.Parent = PasswordBox
        
        -- 送信ボタン
        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Size = UDim2.new(1, -40, 0, 40)
        SubmitButton.Position = UDim2.new(0, 20, 0, 165)
        SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        SubmitButton.Text = "認証"
        SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitButton.TextSize = 18
        SubmitButton.Font = Enum.Font.GothamBold
        SubmitButton.Parent = MainFrame
        
        local SubmitCorner = Instance.new("UICorner")
        SubmitCorner.CornerRadius = UDim.new(0, 5)
        SubmitCorner.Parent = SubmitButton
        
        -- ステータス
        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(1, -40, 0, 20)
        StatusLabel.Position = UDim2.new(0, 20, 0, 215)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Text = ""
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.TextSize = 14
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.Parent = MainFrame
        
        return ScreenGui, PasswordBox, SubmitButton, StatusLabel
    end
    
    -- GUI作成
    local ScreenGui, PasswordBox, SubmitButton, StatusLabel = CreateSimpleAuthGUI()
    
    -- 認証処理
    SubmitButton.MouseButton1Click:Connect(function()
        local password = PasswordBox.Text
        
        if password == "しゅーくりーむ" then
            StatusLabel.Text = "✅ 認証成功！ロード中..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            -- 認証GUIを削除
            ScreenGui:Destroy()
            
            -- メインUIをロード
            LoadMainAssassinSheriffUI(isPC)
        else
            StatusLabel.Text = "❌ パスワードが間違っています"
        end
    end)
    
    -- Enterキーでも送信
    PasswordBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SubmitButton.MouseButton1Click:Fire()
        end
    end)
end

-- メインUIロード関数
local function LoadMainAssassinSheriffUI(isPC)
    -- Rayfieldを安全にロード
    local Rayfield = SafeLoadRayfield()
    
    if not Rayfield then
        -- フォールバック: シンプルな自作UI
        CreateFallbackUI(isPC)
        return
    end

    -- サービス参照
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera

    local player = Players.LocalPlayer

    -- 基本設定
    local settings = {
        softAimEnabled = false,
        autoAimEnabled = false,
        autoShootEnabled = false,
        flyEnabled = false,
        circleEnabled = false,
        magicCircleEnabled = false,
        silentAimEnabled = false,
        triggerBotEnabled = false,
        autoEquipEnabled = false,
        
        softAimStrength = 0.3,
        flySpeed = 50,
        aimPart = "Head",
        shootDelay = 0.08,
        burstCount = 1,
        circleRadius = 120
    }

    local lastShootTime = 0
    local isShootingActive = false

    -- ログシステム
    local debugLog = {}
    local function log(msg)
        table.insert(debugLog, "[" .. os.date("%X") .. "] " .. msg)
        if #debugLog > 20 then
            table.remove(debugLog, 1)
        end
        print(msg)
    end

    -- 武器管理
    local function getEquippedWeapon()
        if not player.Character then return nil end
        return player.Character:FindFirstChildOfClass("Tool")
    end

    local function autoEquipWeapon()
        if not settings.autoEquipEnabled then return getEquippedWeapon() end
        
        if not getEquippedWeapon() then
            for _, item in ipairs(player.Backpack:GetChildren()) do
                if item:IsA("Tool") then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        log("武器装備: " .. item.Name)
                        humanoid:EquipTool(item)
                        wait(0.1)
                        return item
                    end
                end
            end
        end
        return getEquippedWeapon()
    end

    -- 射撃関数
    local function shootWeapon()
        if isShootingActive then return false end
        isShootingActive = true
        
        local tool = getEquippedWeapon()
        if not tool then
            log("武器未装備")
            isShootingActive = false
            return false
        end
        
        log("射撃: " .. tool.Name)
        
        -- 複数の射撃方法を試行
        local success = false
        
        -- 方法1: Activate
        local s1 = pcall(function() tool:Activate() end)
        
        -- 方法2: リモートイベント検索
        for _, desc in ipairs(tool:GetDescendants()) do
            if desc:IsA("RemoteEvent") then
                pcall(function() desc:FireServer() end)
            end
        end
        
        success = s1
        isShootingActive = false
        return success
    end

    -- 敵検出
    local function isEnemy(plr)
        if not player.Team or not plr.Team then return true end
        return plr.Team ~= player.Team
    end

    local function getClosestEnemy()
        local closest, dist = nil, math.huge
        local camPos = Camera.CFrame.Position

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and isEnemy(p) and p.Character then
                local targetPart = p.Character:FindFirstChild(settings.aimPart) or p.Character:FindFirstChild("Head")
                local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
                if targetPart and humanoid and humanoid.Health > 0 then
                    local mag = (targetPart.Position - camPos).Magnitude
                    if mag < dist then
                        closest = p.Character
                        dist = mag
                    end
                end
            end
        end

        return closest
    end

    -- メインループ
    RunService.RenderStepped:Connect(function()
        local currentTime = tick()
        
        -- 自動エイム
        if settings.softAimEnabled or settings.autoAimEnabled then
            local target = getClosestEnemy()
            if target then
                local targetPart = target:FindFirstChild(settings.aimPart) or target:FindFirstChild("Head")
                if targetPart then
                    if settings.softAimEnabled then
                        local newCF = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), settings.softAimStrength)
                        Camera.CFrame = newCF
                    end
                    if settings.autoAimEnabled then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                    end
                end
            end
        end
        
        -- 自動射撃
        if settings.autoShootEnabled and currentTime - lastShootTime > settings.shootDelay then
            if settings.autoEquipEnabled then
                autoEquipWeapon()
            end
            
            if shootWeapon() then
                lastShootTime = currentTime
            end
        end
    end)

    -- Rayfieldウィンドウ作成
    local Window = Rayfield:CreateWindow({
        Name = "暗殺者対保安官2 v3 | " .. (isPC and "PC版" or "モバイル版"),
        LoadingTitle = "超高密度射撃システム",
        LoadingSubtitle = "安定版 - エラー309解決",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "AssassinSheriff2_Fixed",
            FileName = "config"
        },
        Discord = {
            Enabled = false,
            Invite = "noinvitelink",
            RememberJoins = true
        },
        KeySystem = false
    })

    -- タブ作成
    local MainTab = Window:CreateTab("メイン", 4483362458)
    local CombatTab = Window:CreateTab("戦闘", 4483362458)
    local VisualTab = Window:CreateTab("視覚", 4483362458)

    -- メイン設定
    local MainSection = MainTab:CreateSection("基本設定")

    local AutoEquipToggle = MainTab:CreateToggle({
        Name = "武器自動装備",
        CurrentValue = settings.autoEquipEnabled,
        Flag = "AutoEquip",
        Callback = function(Value)
            settings.autoEquipEnabled = Value
            log("自動装備: " .. (Value and "有効" or "無効"))
        end,
    })

    local AimPartDropdown = MainTab:CreateDropdown({
        Name = "狙う部位",
        Options = {"Head", "HumanoidRootPart", "UpperTorso"},
        CurrentOption = settings.aimPart,
        Flag = "AimPart",
        Callback = function(Option)
            settings.aimPart = Option
            log("狙う部位: " .. Option)
        end,
    })

    -- 戦闘設定
    local CombatSection = CombatTab:CreateSection("エイム設定")

    local SoftAimToggle = CombatTab:CreateToggle({
        Name = "ソフトエイム",
        CurrentValue = settings.softAimEnabled,
        Flag = "SoftAim",
        Callback = function(Value)
            settings.softAimEnabled = Value
            log("ソフトエイム: " .. (Value and "有効" or "無効"))
        end,
    })

    local AutoAimToggle = CombatTab:CreateToggle({
        Name = "自動エイム",
        CurrentValue = settings.autoAimEnabled,
        Flag = "AutoAim",
        Callback = function(Value)
            settings.autoAimEnabled = Value
            log("自動エイム: " .. (Value and "有効" or "無効"))
        end,
    })

    local AutoShootToggle = CombatTab:CreateToggle({
        Name = "自動射撃",
        CurrentValue = settings.autoShootEnabled,
        Flag = "AutoShoot",
        Callback = function(Value)
            settings.autoShootEnabled = Value
            log("自動射撃: " .. (Value and "有効" or "無効"))
        end,
    })

    local AimStrengthSlider = CombatTab:CreateSlider({
        Name = "エイム強度",
        Range = {0.1, 1},
        Increment = 0.1,
        Suffix = "強度",
        CurrentValue = settings.softAimStrength,
        Flag = "AimStrength",
        Callback = function(Value)
            settings.softAimStrength = Value
            log("エイム強度: " .. Value)
        end,
    })

    local ShootDelaySlider = CombatTab:CreateSlider({
        Name = "射撃間隔",
        Range = {0.05, 1},
        Increment = 0.05,
        Suffix = "秒",
        CurrentValue = settings.shootDelay,
        Flag = "ShootDelay",
        Callback = function(Value)
            settings.shootDelay = Value
            log("射撃間隔: " .. Value .. "秒")
        end,
    })

    -- 視覚効果
    local VisualSection = VisualTab:CreateSection("視覚効果")

    local CircleToggle = VisualTab:CreateToggle({
        Name = "照準円表示",
        CurrentValue = settings.circleEnabled,
        Flag = "Circle",
        Callback = function(Value)
            settings.circleEnabled = Value
            log("照準円: " .. (Value and "有効" or "無効"))
        end,
    })

    local CircleRadiusSlider = VisualTab:CreateSlider({
        Name = "円の半径",
        Range = {50, 300},
        Increment = 10,
        Suffix = "px",
        CurrentValue = settings.circleRadius,
        Flag = "CircleRadius",
        Callback = function(Value)
            settings.circleRadius = Value
            log("円半径: " .. Value)
        end,
    })

    -- 手動射撃ボタン
    local ManualSection = MainTab:CreateSection("手動操作")

    local ShootButton = MainTab:CreateButton({
        Name = "手動射撃",
        Callback = function()
            log("手動射撃実行")
            if settings.autoEquipEnabled then
                autoEquipWeapon()
            end
            shootWeapon()
        end,
    })

    -- デバッグ情報
    local DebugSection = MainTab:CreateSection("デバッグ")

    local LogLabel = MainTab:CreateLabel("システム正常")

    local RefreshButton = MainTab:CreateButton({
        Name = "状態更新",
        Callback = function()
            local weapon = getEquippedWeapon()
            local weaponName = weapon and weapon.Name or "なし"
            LogLabel:Set("武器: " .. weaponName .. " | システム正常")
        end,
    })

    -- 通知
    Rayfield:Notify({
        Title = "読み込み完了",
        Content = "暗殺者対保安官2 v3 - 安定版\nエラー309解決済み",
        Duration = 5,
        Image = 4483362458,
    })

    log("========================================")
    log("  暗殺者対保安官2 v3 - 安定版")
    log("  エラー309解決済み")
    log("  システム正常起動")
    log("========================================")
end

-- フォールバックUI (Rayfieldロード失敗時用)
local function CreateFallbackUI(isPC)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    local FallbackGui = Instance.new("ScreenGui")
    FallbackGui.Name = "FallbackUI"
    FallbackGui.Parent = player.PlayerGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0, 10, 0, 10)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    MainFrame.Parent = FallbackGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "暗殺者対保安官2 v3\n(フォールバックUI)"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    Title.Parent = MainFrame
    
    local Status = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 40)
    Title.Text = "Rayfieldロード失敗\n基本機能のみ利用可能"
    Title.TextColor3 = Color3.fromRGB(255, 200, 100)
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame
end

-- スクリプト開始
log("暗殺者対保安官2 v3 - 起動中...")

-- 安全な実行
local success, err = pcall(function()
    SimpleAuthSystem()
end)

if not success then
    warn("起動エラー: " .. tostring(err))
    -- エラー時は直接メインUIをロード
    LoadMainAssassinSheriffUI(true)
end
