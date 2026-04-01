-- [[ DUY HUD V2.5 - UI CORE ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local SideBar = Instance.new("ScrollingFrame")
local Container = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")

-- Khởi tạo ScreenGui
ScreenGui.Name = "DuyHud_V2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. NÚT "D" ẨN/MỞ (HÌNH VUÔNG)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Text = "D"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 30
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Draggable = true -- Cho phép Duy kéo nút đi khắp màn hình

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

-- 2. KHUNG MENU CHÍNH (XANH DƯƠNG)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Visible = true -- Mặc định hiện khi chạy

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2

-- 3. THANH SIDEBAR BÊN TRÁI
SideBar.Name = "SideBar"
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = Color3.fromRGB(0, 60, 180)
SideBar.Position = UDim2.new(0, 10, 0, 10)
SideBar.Size = UDim2.new(0, 150, 1, -20)
SideBar.CanvasSize = UDim2.new(0, 0, 2, 0)
SideBar.ScrollBarThickness = 2
SideBar.BorderSizePixel = 0

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = SideBar
SideLayout.Padding = UDim.new(0, 5)

-- 4. KHUNG CHỨA NỘI DUNG BÊN PHẢI
Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 170, 0, 10)
Container.Size = UDim2.new(1, -180, 1, -20)

-- [[ HÀM TẠO TAB & NỘI DUNG ]]
local Pages = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Parent = Container
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 5, 0)
    Page.ScrollBarThickness = 2
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Page
    Layout.Padding = UDim.new(0, 8)
    
    Pages[name] = Page
    return Page
end

local function AddTabBtn(name)
    local TBtn = Instance.new("TextButton")
    TBtn.Size = UDim2.new(1, -10, 0, 35)
    TBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TBtn.Text = name
    TBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TBtn.Font = Enum.Font.GothamBold
    TBtn.Parent = SideBar
    Instance.new("UICorner", TBtn)
    
    TBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        if Pages[name] then Pages[name].Visible = true end
    end)
end

-- [[ KHỞI TẠO CÁC TAB NHƯ REZD HUD ]]
local TabsList = {"Farming", "Auto Fishing", "Quest | Items", "Sea Event", "Race V4", "Teleport", "Settings"}

for _, name in pairs(TabsList) do
    CreatePage(name)
    AddTabBtn(name)
end

-- Mặc định hiện trang Farming
Pages["Farming"].Visible = true

-- Logic Nút Ẩn/Mở
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("DuyHud UI Loaded Successfully!")
-- [[ PHẦN 5: GẮN NÚT VÀ LOGIC CHO TỪNG NGĂN ]]

-- Hàm tạo Section (Tiêu đề nhỏ)
local function AddSection(parent, txt)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, 0, 0, 25)
    L.BackgroundTransparency = 1
    L.Text = "--- "..txt.." ---"
    L.TextColor3 = Color3.fromRGB(255, 255, 255)
    L.Font = Enum.Font.GothamBold
    L.Parent = parent
end

-- Hàm tạo Nút Bật/Tắt (Toggle)
local function AddToggle(parent, txt, callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -15, 0, 38)
    B.BackgroundColor3 = Color3.fromRGB(0, 50, 150)
    B.Text = txt..": OFF"
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Font = Enum.Font.Gotham
    B.Parent = parent
    Instance.new("UICorner", B)
    local s = false
    B.MouseButton1Click:Connect(function()
        s = not s
        B.Text = txt..(s and ": ON" or ": OFF")
        B.BackgroundColor3 = s and Color3.fromRGB(0, 210, 110) or Color3.fromRGB(0, 50, 150)
        callback(s)
    end)
end

-- 1. THÊM NÚT VÀO NGĂN FARMING
local f_page = Pages["Farming"]
AddSection(f_page, "SELECT WEAPON")
AddToggle(f_page, "Auto Click / Fast Attack", function(s) end)

AddSection(f_page, "MAIN FARM")
AddToggle(f_page, "Auto Farm Level (1-2800)", function(s) end)
AddToggle(f_page, "Auto Kill Near (Aura)", function(s) end)
AddToggle(f_page, "Bring Mob (Gom quái)", function(s) end)

-- 2. THÊM NÚT VÀO NGĂN QUEST | ITEMS (FULL SEA 1-3)
local i_page = Pages["Quest | Items"]
AddSection(i_page, "SEA 1 - 2 - 3")
AddToggle(i_page, "Auto Saber", function(s) end)
AddToggle(i_page, "Auto TTK (Triple Katana)", function(s) end)
AddToggle(i_page, "Auto CDK (Cursed Dual Katana)", function(s) end)
AddToggle(i_page, "Auto Soul Guitar", function(s) end)
AddToggle(i_page, "Auto Shark Anchor", function(s) end)

AddSection(i_page, "FIGHTING STYLE")
AddToggle(i_page, "Auto Godhuman", function(s) end)
AddToggle(i_page, "Auto Sanguine Art", function(s) end)

-- 3. THÊM NÚT VÀO NGĂN SEA EVENT
local s_page = Pages["Sea Event"]
AddSection(s_page, "SEA MONSTER")
AddToggle(s_page, "Auto Sea Beast", function(s) end)
AddToggle(s_page, "Auto Terror Shark", function(s) end)
-- [[ PHẦN 6: LOGIC ĐỘNG CƠ (CHẠY THẬT) ]]

-- 1. HÀM BAY (TWEEN) ĐỂ KHÔNG BỊ KICK
local function TweenTo(Pos)
    local Character = game.Players.LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local Distance = (Pos.Position - Character.HumanoidRootPart.Position).Magnitude
        local Speed = 250 -- Tốc độ bay
        local Tween = game:GetService("TweenService"):Create(Character.HumanoidRootPart, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {CFrame = Pos})
        Tween:Play()
        return Tween
    end
end

-- 2. BIẾN ĐIỀU KHIỂN
_G.AutoFarm = false
_G.FastAttack = false

-- 3. VÒNG LẶP AUTO FARM (CHÍNH)
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            local myLevel = game.Players.LocalPlayer.Data.Level.Value
            -- Logic nhận nhiệm vụ (Ví dụ đảo tân thủ)
            if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                TweenTo(CFrame.new(1059, 15, 1548)) -- Tọa độ NPC Bandit
                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1059, 15, 1548)).Magnitude < 10 then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
                end
            else
                -- Bay tới quái và đánh
                for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == "Bandit" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat task.wait()
                            TweenTo(v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                            -- Tự động đánh
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        until not _G.AutoFarm or v.Humanoid.Health <= 0
                    end
                end
            end
        end
    end
end)

print("DuyHud Logic đã sẵn sàng!")
-- [[ PHẦN 7: BẢNG DỮ LIỆU TỌA ĐỘ VÀ NHIỆM VỤ (SEA 1 MẪU) ]]
-- Phần này giúp Duy tự động đổi quái khi lên Level

local LevelData = {
    ["Level 1-10"] = {
        QuestName = "BanditQuest1",
        MonsterName = "Bandit",
        NPC_Pos = CFrame.new(1059.3, 15.4, 1548.5),
        Monster_Pos = CFrame.new(1145.2, 17.1, 1633.8),
        LevelRequired = 1
    },
    ["Level 10-15"] = {
        QuestName = "MonkeyQuest1",
        MonsterName = "Monkey",
        NPC_Pos = CFrame.new(-1598.1, 36.5, 153.2),
        Monster_Pos = CFrame.new(-1623.5, 36.2, 155.8),
        LevelRequired = 10
    },
    ["Level 15-30"] = {
        QuestName = "GorillaQuest1", -- Vẫn chung NPC với Monkey
        MonsterName = "Gorilla",
        NPC_Pos = CFrame.new(-1598.1, 36.5, 153.2),
        Monster_Pos = CFrame.new(-1237.8, 7.3, -493.5),
        LevelRequired = 15
    },
    ["Level 30-60"] = {
        QuestName = "PirateQuest1",
        MonsterName = "Pirate",
        NPC_Pos = CFrame.new(-1141.1, 4.7, 3826.1),
        Monster_Pos = CFrame.new(-1218.4, 4.7, 3918.2),
        LevelRequired = 30
    }
    -- Duy có thể dán thêm hàng trăm mốc Level khác vào đây sau này!
}

-- [[ HÀM TỰ ĐỘNG CHỌN NHIỆM VỤ THEO LEVEL ]]
function GetMyQuest()
    local myLevel = game.Players.LocalPlayer.Data.Level.Value
    local bestQuest = nil
    
    for _, data in pairs(LevelData) do
        if myLevel >= data.LevelRequired then
            if not bestQuest or data.LevelRequired > bestQuest.LevelRequired then
                bestQuest = data
            end
        end
    end
    return bestQuest
end

print("DuyHud: Đã nạp xong bản đồ nhiệm vụ!")
-- [[ PHẦN 8: ĐỘNG CƠ FAST ATTACK & GOM QUÁI (BRING MOB) ]]

_G.FastAttack = true
_G.BringMob = true

-- 1. HÀM FAST ATTACK (ĐÁNH NHANH NHƯ CHỚP)
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local Dummy = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)

task.spawn(function()
    while task.wait() do
        if _G.FastAttack then
            pcall(function()
                local CurrentWeapon = CombatFramework.activeController
                if CurrentWeapon and CurrentWeapon.equipped then
                    -- Bỏ qua delay của hoạt ảnh đánh
                    CurrentWeapon.hitboxMagnitude = 55
                    CurrentWeapon:attack()
                end
            end)
        end
    end
end)

-- 2. HÀM BRING MOB (GOM QUÁI LẠI MỘT ĐIỂM)
task.spawn(function()
    while task.wait() do
        if _G.BringMob and _G.AutoFarm then
            pcall(function()
                local MyPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - MyPos).Magnitude < 300 then
                        -- Kéo quái về phía nhân vật để đánh lan
                        v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                        v.HumanoidRootPart.CanCollide = false -- Tránh quái đẩy nhân vật
                        v.Humanoid.JumpPower = 0
                    end
                end
            end)
        end
    end
end)

-- 3. HÀM TỰ TRANG BỊ VŨ KHÍ (AUTO EQUIP)
task.spawn(function()
    while task.wait(1) do
        if _G.AutoFarm then
            local Tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") or game.Players.LocalPlayer.Backpack:FindFirstChild("Melee")
            if Tool then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
            end
        end
    end
end)

print("DuyHud: Đã kích hoạt Fast Attack & Bring Mob!")
-- [[ PHẦN 9: TRÍ TUỆ AUTO FARM (TỰ NHẬN QUEST & TẤN CÔNG) ]]

task.spawn(function()
    while task.wait(1) do
        if _G.AutoFarm then
            pcall(function()
                -- 1. KIỂM TRA ĐÃ CÓ NHIỆM VỤ CHƯA
                local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
                local hasQuest = PlayerGui.Main.Quest.Visible
                
                -- Lấy dữ liệu Quest phù hợp Level (Dùng hàm GetMyQuest mình đưa lúc nãy)
                local MyQuestData = GetMyQuest() 
                
                if not hasQuest then
                    -- NẾU CHƯA CÓ: Bay tới NPC để nhận
                    if MyQuestData then
                        TweenTo(MyQuestData.NPC_Pos)
                        -- Khoảng cách gần NPC thì bấm nhận
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MyQuestData.NPC_Pos.Position).Magnitude < 15 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", MyQuestData.QuestName, 1)
                        end
                    end
                else
                    -- NẾU CÓ RỒI: Tìm quái để tiêu diệt
                    local TargetMon = game:GetService("Workspace").Enemies:FindFirstChild(MyQuestData.MonsterName)
                    
                    if TargetMon and TargetMon:FindFirstChild("Humanoid") and TargetMon.Humanoid.Health > 0 then
                        -- Bay tới quái
                        TweenTo(TargetMon.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                        
                        -- TỰ ĐỘNG TẤN CÔNG (Spam Click)
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                    else
                        -- Nếu không thấy quái ở gần thì bay ra giữa bãi quái đợi
                        TweenTo(MyQuestData.Monster_Pos)
                    end
                end
            end)
        end
    end
end)
-- [[ PHẦN 10: FULL LOGIC FARM - DÁN NỐI TIẾP VÀO DÒNG CUỐI ]]

-- 1. BẢNG TỌA ĐỘ (MAP DATA)
local LevelData = {
    {Level = 1, Quest = "BanditQuest1", Monster = "Bandit", NPC_Pos = CFrame.new(1059, 15, 1548), Mon_Pos = CFrame.new(1145, 17, 1633)},
    {Level = 10, Quest = "MonkeyQuest1", Monster = "Monkey", NPC_Pos = CFrame.new(-1598, 36, 153), Mon_Pos = CFrame.new(-1623, 36, 155)},
    {Level = 15, Quest = "GorillaQuest1", Monster = "Gorilla", NPC_Pos = CFrame.new(-1598, 36, 153), Mon_Pos = CFrame.new(-1237, 7, -493)}
}

-- 2. HÀM TỰ ĐỘNG CHỌN QUEST
function GetMyQuest()
    local myLevel = game.Players.LocalPlayer.Data.Level.Value
    local best = LevelData[1]
    for _, v in pairs(LevelData) do
        if myLevel >= v.Level then best = v end
    end
    return best
end

-- 3. HÀM BAY (TWEEN)
local function TweenTo(Pos)
    local Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance/250, Enum.EasingStyle.Linear), {CFrame = Pos}):Play()
end

-- 4. VÒNG LẶP THỰC THI (ENGINE)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFarm then
            pcall(function()
                local q = GetMyQuest()
                if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                    -- Chưa có quest thì bay đi nhận
                    TweenTo(q.NPC_Pos)
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - q.NPC_Pos.Position).Magnitude < 15 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q.Quest, 1)
                    end
                else
                    -- Có quest rồi thì đi tìm quái
                    local Enemy = game:GetService("Workspace").Enemies:FindFirstChild(q.Monster)
                    if Enemy and Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                        TweenTo(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                        -- Tự đánh
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                    else
                        -- Bay ra giữa bãi quái đợi quái hồi sinh
                        TweenTo(q.Mon_Pos)
                    end
                end
            end)
        end
    end
end)
-- [[ PHẦN 11: AUTO EQUIP & BRING MOB PRO (GOM QUÁI SIÊU TỐC) ]]

_G.AutoEquip = true -- Mặc định tự cầm vũ khí

-- 1. HÀM TỰ CẦM VŨ KHÍ (MELEE/KIẾM)
task.spawn(function()
    while task.wait(1) do
        if _G.AutoFarm and _G.AutoEquip then
            pcall(function()
                -- Ưu tiên cầm Melee (Võ) để farm
                local Tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") 
                    or game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg")
                    or game.Players.LocalPlayer.Backpack:FindFirstChild("Electro")
                    or game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Kung Fu")
                    -- Nếu không có võ thì cầm Kiếm (Sword)
                    or game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                
                if Tool and not game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
                end
            end)
        end
    end
end)

-- 2. HÀM GOM QUÁI SIÊU CẤP (BRING MOB V2)
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local q = GetMyQuest() -- Lấy tên quái hiện tại Duy đang farm
                for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == q.Monster and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        -- Kiểm tra khoảng cách để không gom quái ở quá xa (tránh lỗi)
                        local dist = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 350 then
                            v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                            v.HumanoidRootPart.CanCollide = false -- Để quái không đẩy Duy đi
                            v.Humanoid.JumpPower = 0 -- Khóa quái không cho nhảy
                            if v.Humanoid.Health <= 0 then
                                v.HumanoidRootPart.Size = Vector3.new(0,0,0)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

print("DuyHud: Phần 11 - Auto Equip & Bring Mob đã hoạt động!")
-- [[ PHẦN 12: AUTO STATS (TỰ NÂNG ĐIỂM) ]]
_G.AutoStats = true -- Mặc định tự nâng điểm vào Melee

task.spawn(function()
    while task.wait(1) do
        if _G.AutoStats then
            pcall(function()
                -- Tự động nâng vào Melee (Cận chiến) để farm khỏe hơn
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 3)
                -- Nếu Duy muốn nâng vào Defense (Máu) thì đổi chữ "Melee" thành "Defense"
            end)
        end
    end
end)
-- [[ PHẦN 13: HỆ THỐNG AUTO FARM LEVEL TẠI SEA 2 (NEW WORLD) ]]

_G.AutoFarmSea2 = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoFarmSea2 then
            pcall(function()
                local myLvl = game.Players.LocalPlayer.Data.Level.Value
                
                -- LOGIC TỰ ĐỘNG CHỌN BÃI QUÁI THEO LEVEL TẠI SEA 2
                if myLvl >= 700 and myLvl < 775 then
                    -- Bãi quái đầu tiên: Đảo Hoa (Kingdom of Rose) - Raiders
                    local QuestNPC = CFrame.new(-420, 73, 430)
                    local MobName = "Raider"
                    local MobPos = CFrame.new(-450, 72, 400)
                    
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                        TweenTo(QuestNPC)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "Area1Quest", 1)
                    else
                        local Enemy = game:GetService("Workspace").Enemies:FindFirstChild(MobName)
                        if Enemy and Enemy.Humanoid.Health > 0 then
                            _G.FastAttack = true
                            TweenTo(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 7))
                        else
                            TweenTo(MobPos)
                        end
                    end
                elseif myLvl >= 775 and myLvl < 875 then
                    -- Bãi quái tiếp theo: Mercenaries
                    print("DuyHud: Đang chuyển sang bãi Mercenaries...")
                    -- (Tương tự cho các bãi quái khác ở Sea 2)
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Dán nối tiếp phần UI)
QuickBtn("Auto Farm Sea 2", 460, function(s) 
    _G.AutoFarmSea2 = s 
end)
-- [[ PHẦN 14: AUTO TÌM HOA NÂNG CẤP TỘC V2 (FLOWER QUEST) ]]

_G.AutoFarmFlowers = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoFarmFlowers then
            pcall(function()
                -- 1. KIỂM TRA XEM ĐÃ NHẬN NHIỆM VỤ CHƯA
                local Alchemist = CFrame.new(-1240, 15, -4290) -- NPC Alchemist ở Green Zone
                
                -- 2. TỰ ĐỘNG ĐI NHẶT HOA THEO MÀU
                local Flower1 = game:GetService("Workspace"):FindFirstChild("Flower1") -- Hoa Đỏ
                local Flower2 = game:GetService("Workspace"):FindFirstChild("Flower2") -- Hoa Xanh
                
                if Flower1 then
                    print("DuyHud: Đã thấy Hoa Đỏ! Đang bay tới nhặt...")
                    TweenTo(Flower1.CFrame)
                elseif Flower2 then
                    print("DuyHud: Đã thấy Hoa Xanh! Đang bay tới nhặt...")
                    TweenTo(Flower2.CFrame)
                else
                    -- 3. NẾU KHÔNG THẤY HOA MỌC: ĐI ĐÁNH QUÁI LẤY HOA VÀNG
                    print("DuyHud: Đang đi đánh quái Swan Pirate để lấy Hoa Vàng...")
                    local Enemy = game:GetService("Workspace").Enemies:FindFirstChild("Swan Pirate")
                    if Enemy then
                        TweenTo(Enemy.HumanoidRootPart.CFrame * CFrame.new(0,0,5))
                        _G.FastAttack = true
                    else
                        TweenTo(CFrame.new(900, 120, 1100)) -- Khu vực Swan Pirate
                    end
                end
                
                -- 4. KHI ĐỦ 3 HOA: TỰ QUAY VỀ NPC ĐỂ TRẢ NHIỆM VỤ
                if game.Players.LocalPlayer.Backpack:FindFirstChild("Flower1") and 
                   game.Players.LocalPlayer.Backpack:FindFirstChild("Flower2") and 
                   game.Players.LocalPlayer.Backpack:FindFirstChild("Flower3") then
                    TweenTo(Alchemist)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist","3")
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 510 để không đè lên Phần 13)
QuickBtn("Auto Tìm Hoa Tộc V2", 510, function(s) 
    _G.AutoFarmFlowers = s 
end)
-- [[ PHẦN 15: HỖ TRỢ LÀM NHIỆM VỤ TỘC V3 (SEA 2) ]]

_G.AutoRaceV3 = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoRaceV3 then
            pcall(function()
                local myRace = game.Players.LocalPlayer.Data.Race.Value
                local Arowe = CFrame.new(-2905, 8, 530) -- Tọa độ NPC Arowe (Secret Room)

                -- 1. KIỂM TRA NHIỆM VỤ THEO TỘC
                if myRace == "Mink" then
                    -- Nhiệm vụ Mink: Nhặt 30 rương (Sử dụng lại logic nhặt rương ở Phần 46)
                    print("DuyHud: Duy đang là Tộc Mink! Đang đi nhặt rương cho nhiệm vụ V3...")
                    local Chest = game:GetService("Workspace"):FindFirstChild("Chest1") or game:GetService("Workspace"):FindFirstChild("Chest2")
                    if Chest then TweenTo(Chest.CFrame) end
                    
                elseif myRace == "Human" then
                    -- Nhiệm vụ Human: Diệt 3 Boss (Diamond, Jeremy, Fajita)
                    print("DuyHud: Duy đang là Tộc Human! Đang đi săn Boss nhiệm vụ...")
                    local Boss = game:GetService("Workspace").Enemies:FindFirstChild("Diamond") or 
                                 game:GetService("Workspace").Enemies:FindFirstChild("Jeremy") or 
                                 game:GetService("Workspace").Enemies:FindFirstChild("Fajita")
                    if Boss then
                        TweenTo(Boss.HumanoidRootPart.CFrame * CFrame.new(0,0,5))
                        _G.FastAttack = true
                    end
                    
                elseif myRace == "Fishman" then
                    -- Nhiệm vụ Fishman: Diệt Sea Beast
                    print("DuyHud: Duy đang là Tộc Cá! Đang tìm Sea Beast...")
                    local SB = game:GetService("Workspace").Enemies:FindFirstChild("Sea Beast")
                    if SB then TweenTo(SB.HumanoidRootPart.CFrame * CFrame.new(0,30,0)) end
                end

                -- 2. TỰ ĐỘNG QUAY VỀ TRẢ NHIỆM VỤ KHI XONG
                -- Lưu ý: Duy cần mang theo 2 triệu Beli để trả cho Arowe nhé
                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Arowe.Position).Magnitude < 20 then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Wenlocktoad","1")
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 560 để không đè lên các phần trước)
QuickBtn("Auto Nhiệm Vụ Tộc V3", 560, function(s) 
    _G.AutoRaceV3 = s 
end)
-- [[ PHẦN 16: AUTO GIẢI ĐỐ ĐẤU TRƯỜNG (COLOSSEUM QUEST - LẤY CHIẾN BINH MŨ) ]]

_G.AutoColosseum = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoColosseum then
            pcall(function()
                -- 1. NHẬN NHIỆM VỤ TỪ BARTILO (TẠI QUÁN CAFE)
                local Bartilo = CFrame.new(-450, 15, 280)
                if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress") == 0 then
                    print("DuyHud: Đang nhận nhiệm vụ từ Bartilo...")
                    TweenTo(Bartilo)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
                end

                -- 2. DIỆT 50 QUÁI SWAN PIRATES
                local SwanPirate = game:GetService("Workspace").Enemies:FindFirstChild("Swan Pirate")
                if SwanPirate and SwanPirate.Humanoid.Health > 0 then
                    print("DuyHud: Đang diệt 50 Swan Pirates...")
                    TweenTo(SwanPirate.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                    _G.FastAttack = true
                else
                    TweenTo(CFrame.new(900, 120, 1100))
                end

                -- 3. SAU KHI XONG: TỰ ĐỘNG GIẢI MÃ TẤM BIA ĐÁ (CODE ĐẤU TRƯỜNG)
                -- Script sẽ tự động dẫm lên các ký tự theo thứ tự: Y -> V -> M -> B -> G -> S -> U -> F
                local Symbols = {
                    CFrame.new(-2420, 7, 260), -- Y
                    CFrame.new(-2420, 7, 280), -- V
                    CFrame.new(-2420, 7, 300), -- M
                    CFrame.new(-2420, 7, 320), -- B
                    CFrame.new(-2420, 7, 340), -- G
                    CFrame.new(-2420, 7, 360), -- S
                    CFrame.new(-2420, 7, 380), -- U
                    CFrame.new(-2420, 7, 400)  -- F
                }
                
                print("DuyHud: Đang giải mật mã Đấu Trường...")
                for _, pos in pairs(Symbols) do
                    TweenTo(pos)
                    task.wait(1)
                end
                
                print("DuyHud: Giải đố thành công! Đã mở cửa tù nhân!")
                _G.AutoColosseum = false -- Xong thì tự tắt
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 610)
QuickBtn("Auto Giải Đố Đấu Trường", 610, function(s) 
    _G.AutoColosseum = s 
end)
-- [[ PHẦN 17: AUTO SĂN BOSS DON SWAN (LẤY KÍNH SWAN GLASSES) ]]

_G.AutoDonSwan = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoDonSwan then
            pcall(function()
                -- 1. KIỂM TRA ĐIỀU KIỆN (CẦN TRÁI ÁC QUỶ GIÁ TRỊ > 1M ĐỂ VÀO CỬA)
                -- Lưu ý: Duy phải đưa trái ác quỷ cho NPC Trevor trước (nếu làm lần đầu)
                
                local DonSwanRoom = CFrame.new(2290, 15, 900) -- Tọa độ phòng Don Swan
                local Boss = game:GetService("Workspace").Enemies:FindFirstChild("Don Swan")

                if Boss and Boss:FindFirstChild("HumanoidRootPart") and Boss.Humanoid.Health > 0 then
                    print("DuyHud: Đang tiêu diệt Don Swan! Săn kính Swan Glasses...")
                    
                    -- Bay lên cao một chút để né chiêu quất tơ của Boss
                    TweenTo(Boss.HumanoidRootPart.CFrame * CFrame.new(0, 10, 5))
                    
                    _G.FastAttack = true
                    _G.AutoClick = true
                    
                    -- Xả skill liên tục
                    local Keys = {"Z", "X", "C", "V"}
                    for _, key in pairs(Keys) do
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
                        task.wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
                    end
                else
                    -- Nếu Boss chưa hồi sinh, đứng đợi tại dinh thự
                    print("DuyHud: Đang đợi Don Swan hồi sinh (30 phút/lần)...")
                    TweenTo(DonSwanRoom)
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 660)
QuickBtn("Auto Săn Boss Don Swan", 660, function(s) 
    _G.AutoDonSwan = s 
end)
-- [[ PHẦN 18: AUTO SĂN KIẾM RENGOKU (KIẾM LỬA - BOSS ICE ADMIRAL) ]]

_G.AutoRengoku = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoRengoku then
            pcall(function()
                -- 1. KIỂM TRA DUY CÓ CHÌA KHÓA CHƯA (HIDDEN KEY)
                local HasKey = game.Players.LocalPlayer.Backpack:FindFirstChild("Hidden Key") or 
                               game.Players.LocalPlayer.Character:FindFirstChild("Hidden Key")
                
                if HasKey then
                    print("DuyHud: Duy đã có Chìa Khóa Bí Mật! Đang tới rương báu lấy kiếm Rengoku...")
                    -- Tọa độ rương bí mật đằng sau cánh cửa bên phải trong lâu đài
                    TweenTo(CFrame.new(6480, 73, -6920)) 
                else
                    -- 2. NẾU CHƯA CÓ: TỰ ĐỘNG ĐI DIỆT BOSS ĐỂ SĂN CHÌA KHÓA
                    local Boss = game:GetService("Workspace").Enemies:FindFirstChild("Awakened Ice Admiral")
                    
                    if Boss and Boss:FindFirstChild("HumanoidRootPart") and Boss.Humanoid.Health > 0 then
                        print("DuyHud: Đang tiêu diệt Đô Đốc Băng để lấy Chìa Khóa Rengoku!")
                        -- Bay sát Boss để vả
                        TweenTo(Boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                        
                        _G.FastAttack = true
                        _G.AutoClick = true
                        
                        -- Combo chiêu để hạ Boss nhanh
                        local Keys = {"Z", "X", "C", "V"}
                        for _, key in pairs(Keys) do
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
                            task.wait(0.1)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
                        end
                    else
                        -- Đứng đợi Boss hồi sinh tại sảnh Lâu Đài Tuyết
                        print("DuyHud: Đang đợi Đô Đốc Băng hồi sinh tại Lâu Đài Tuyết...")
                        TweenTo(CFrame.new(6480, 75, -6750))
                    end
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 710)
QuickBtn("Auto Săn Kiếm Rengoku", 710, function(s) 
    _G.AutoRengoku = s 
end)
-- [[ PHẦN 19: AUTO SĂN ĐINH BA RỒNG (DRAGON TRIDENT - BOSS TIDE KEEPER) ]]

_G.AutoDragonTrident = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoDragonTrident then
            pcall(function()
                -- 1. TỌA ĐỘ ĐẢO QUÊN LÃNG (FORGOTTEN ISLAND)
                local TideKeeperPos = CFrame.new(-3400, 10, -11500)
                
                -- 2. TÌM BOSS TIDE KEEPER
                local Boss = game:GetService("Workspace").Enemies:FindFirstChild("Tide Keeper")
                
                if Boss and Boss:FindFirstChild("HumanoidRootPart") and Boss.Humanoid.Health > 0 then
                    print("DuyHud: Đang tiêu diệt Tide Keeper! Săn Đinh Ba Rồng...")
                    
                    -- Bay lên cao một chút để né chiêu gọi rồng của Boss
                    TweenTo(Boss.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                    
                    _G.FastAttack = true
                    _G.AutoClick = true
                    
                    -- Tự động xả kỹ năng để kết liễu nhanh
                    local Keys = {"Z", "X", "C", "V"}
                    for _, key in pairs(Keys) do
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
                        task.wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
                    end
                else
                    -- Nếu Boss chưa hồi sinh, đứng đợi tại đảo
                    print("DuyHud: Đang đợi Tide Keeper hồi sinh tại Đảo Quên Lãng...")
                    TweenTo(TideKeeperPos)
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 760)
QuickBtn("Auto Săn Đinh Ba Rồng", 760, function(s) 
    _G.AutoDragonTrident = s 
end)
-- [[ PHẦN 20: AUTO NHIỆM VỤ SANG SEA 3 (UNLOCK THIRD SEA - BOSS INDRA) ]]

_G.AutoUnlockSea3 = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoUnlockSea3 then
            pcall(function()
                local myLvl = game.Players.LocalPlayer.Data.Level.Value
                
                -- 1. KIỂM TRA ĐIỀU KIỆN LEVEL 1500
                if myLvl >= 1500 then
                    -- 2. ĐẾN ĐẤU TRƯỜNG (COLOSSEUM) GẶP KING RED HEAD
                    local ColosseumPos = CFrame.new(-1430, 7, -2770)
                    
                    -- 3. KIỂM TRA XEM BOSS RIP_INDRA CÓ XUẤT HIỆN KHÔNG
                    local Indra = game:GetService("Workspace").Enemies:FindFirstChild("Rip_Indra")
                    
                    if Indra and Indra:FindFirstChild("HumanoidRootPart") and Indra.Humanoid.Health > 0 then
                        print("DuyHud: Đang chiến đấu với Rip_Indra để mở cửa Sea 3!")
                        TweenTo(Indra.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                        
                        _G.FastAttack = true
                        _G.AutoClick = true
                        
                        -- Dùng toàn bộ sức mạnh để kết liễu Indra
                        local Keys = {"Z", "X", "C", "V"}
                        for _, key in pairs(Keys) do
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
                            task.wait(0.1)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
                        end
                    else
                        -- 4. TỰ ĐỘNG NÓI CHUYỆN VỚI MR. CAPTAIN TẠI GREEN ZONE ĐỂ SANG BIỂN 3
                        print("DuyHud: Indra đã gục! Đang tới chỗ Mr. Captain để sang Sea 3...")
                        local MrCaptain = CFrame.new(-1050, 15, -4250)
                        TweenTo(MrCaptain)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
                    end
                else
                    print("DuyHud: Duy cần đạt Level 1500 để sang Sea 3! Đang quay lại Farm...")
                    _G.AutoFarmSea2 = true -- Tự bật Farm level nếu chưa đủ
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 810)
QuickBtn("Auto Mở Khóa Sea 3", 810, function(s) 
    _G.AutoUnlockSea3 = s 
end)
-- [[ PHẦN 21: AUTO LẤY VÕ SHARKMAN KARATE (VÕ NGƯỜI CÁ V2) ]]

_G.AutoSharkman = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoSharkman then
            pcall(function()
                -- 1. KIỂM TRA ĐIỀU KIỆN (CẦN WATER KEY)
                local HasWaterKey = game.Players.LocalPlayer.Backpack:FindFirstChild("Water Key") or 
                                    game.Players.LocalPlayer.Character:FindFirstChild("Water Key")
                
                local DaidrockPos = CFrame.new(-3380, 15, -11680) -- NPC Daidrock ở Đảo Quên Lãng
                
                if HasWaterKey then
                    print("DuyHud: Duy đã có Water Key! Đang tới NPC Daidrock để học võ...")
                    TweenTo(DaidrockPos)
                    -- Tự động nói chuyện để đưa chìa khóa và học võ
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
                else
                    -- 2. NẾU CHƯA CÓ CHÌA KHÓA: TỰ ĐI SĂN BOSS TIDE KEEPER
                    print("DuyHud: Duy chưa có Water Key! Đang đi săn Boss Tide Keeper...")
                    local Boss = game:GetService("Workspace").Enemies:FindFirstChild("Tide Keeper")
                    if Boss and Boss:FindFirstChild("HumanoidRootPart") and Boss.Humanoid.Health > 0 then
                        TweenTo(Boss.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                        _G.FastAttack = true
                        _G.AutoClick = true
                    else
                        -- Bay ra Đảo Quên Lãng đợi Boss
                        TweenTo(DaidrockPos)
                    end
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 860)
QuickBtn("Auto Võ Sharkman Karate 🦈", 860, function(s) 
    _G.AutoSharkman = s 
end)
-- [[ PHẦN 22: AUTO LẤY VÕ DEATH STEP (CHÂN LỬA V2 - SEA 2) ]]

_G.AutoDeathStep = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoDeathStep then
            pcall(function()
                -- 1. KIỂM TRA ĐIỀU KIỆN (CẦN LIBRARY KEY)
                local HasLibKey = game.Players.LocalPlayer.Backpack:FindFirstChild("Library Key") or 
                                  game.Players.LocalPlayer.Character:FindFirstChild("Library Key")
                
                local PhoebusPos = CFrame.new(6350, 73, -6910) -- NPC Phoebus trong thư viện Lâu Đài Tuyết
                
                if HasLibKey then
                    print("DuyHud: Duy đã có Library Key! Đang tới thư viện học võ Death Step...")
                    TweenTo(PhoebusPos)
                    -- Tự động mở cửa thư viện và học võ
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep", true)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
                else
                    -- 2. NẾU CHƯA CÓ CHÌA KHÓA: ĐI SĂN BOSS AWAKENED ICE ADMIRAL
                    print("DuyHud: Duy chưa có Library Key! Đang săn Đô Đốc Băng...")
                    local Boss = game:GetService("Workspace").Enemies:FindFirstChild("Awakened Ice Admiral")
                    if Boss and Boss:FindFirstChild("HumanoidRootPart") and Boss.Humanoid.Health > 0 then
                        TweenTo(Boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                        _G.FastAttack = true
                        _G.AutoClick = true
                    else
                        -- Bay tới sảnh lâu đài đợi Boss
                        TweenTo(CFrame.new(6480, 75, -6750))
                    end
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 910)
QuickBtn("Auto Võ Death Step 🔥", 910, function(s) 
    _G.AutoDeathStep = s 
end)
-- [[ PHẦN 23: AUTO LẤY VÕ DRAGON TALON (VUỐT RỒNG V2 - SEA 3) ]]

_G.AutoDragonTalon = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoDragonTalon then
            pcall(function()
                -- 1. KIỂM TRA ĐIỀU KIỆN (CẦN FIRE ESSENCE)
                local HasFireEssence = game.Players.LocalPlayer.Backpack:FindFirstChild("Fire Essence") or 
                                       game.Players.LocalPlayer.Character:FindFirstChild("Fire Essence")
                
                local UzothPos = CFrame.new(-9500, 380, -2820) -- NPC Uzoth ở Đảo Haunted Castle (Sea 3)
                
                if HasFireEssence then
                    print("DuyHud: Duy đã có Fire Essence! Đang tới NPC Uzoth để học võ...")
                    TweenTo(UzothPos)
                    -- Tự động đưa tinh chất lửa và học võ
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
                else
                    -- 2. NẾU CHƯA CÓ: TỰ ĐI ĐỔI XƯƠNG TẠI DEATH KING
                    print("DuyHud: Duy chưa có Fire Essence! Đang đi đổi xương tại Death King...")
                    local DeathKing = CFrame.new(-9480, 140, -5540)
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - DeathKing.Position).Magnitude > 20 then
                        TweenTo(DeathKing)
                    else
                        -- Tự động quay thưởng bằng Xương (Bones)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RandomSurprise")
                    end
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 960)
QuickBtn("Auto Võ Dragon Talon 🐉", 960, function(s) 
    _G.AutoDragonTalon = s 
end)
-- [[ PHẦN 24: AUTO LẤY VÕ ELECTRIC CLAW (MÓNG VUỐT ĐIỆN V2 - SEA 3) ]]

_G.AutoElectricClaw = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoElectricClaw then
            pcall(function()
                -- 1. TỌA ĐỘ NPC PREVIOUS HERO (ĐẢO RÙA)
                local HeroPos = CFrame.new(-10380, 330, -8250)
                local MansionPos = CFrame.new(-12460, 375, -7560) -- Điểm đích tại Dinh Thự (Mansion)
                
                -- 2. NHẬN THỬ THÁCH CHẠY ĐUA (CẦN 400 MASTERY ELECTRIC V1)
                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - HeroPos.Position).Magnitude > 20 then
                    print("DuyHud: Đang tới gặp NPC Previous Hero...")
                    TweenTo(HeroPos)
                else
                    print("DuyHud: Đang nhận thử thách chạy đua 30 giây...")
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw", "Verify")
                    
                    -- 3. TỰ ĐỘNG BAY TỚI ĐÍCH (MANSION) TRONG 1 GIÂY
                    task.wait(0.5)
                    print("DuyHud: Dùng tốc độ ánh sáng tới đích!")
                    TweenTo(MansionPos)
                    
                    -- 4. QUAY LẠI MUA VÕ
                    task.wait(1)
                    TweenTo(HeroPos)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw", "Claim")
                    _G.AutoElectricClaw = false -- Xong thì tự tắt
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 1010)
QuickBtn("Auto Võ Electric Claw ⚡", 1010, function(s) 
    _G.AutoElectricClaw = s 
end)
-- [[ PHẦN 25: AUTO RAID SIÊU TỐC (QUÁI XUẤT HIỆN LÀ CHẾT - CHỌN LOẠI RAID) ]]

_G.AutoRaid = false
_G.SelectRaid = "Flame" -- Duy có thể đổi thành: "Ice", "Quake", "Light", "Dark", "Buddha", "Spider", "Phoenix"

task.spawn(function()
    while task.wait(0.1) do -- Chạy vòng lặp cực nhanh
        if _G.AutoRaid then
            pcall(function()
                -- 1. TỰ ĐỘNG MUA CHIP VÀ VÀO PHÒNG RAID
                if not game:GetService("Workspace").Map:FindFirstChild("Raid") then
                    print("DuyHud: Đang mua Chip " .. _G.SelectRaid .. "...")
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsEntity","Select", _G.SelectRaid)
                    task.wait(0.2)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsEntity","Start")
                else
                    -- 2. LOGIC DIỆT QUÁI SIÊU TỐC (KILL AURA)
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            -- Duy sẽ bay lơ lửng trên đầu quái để không bị đánh trúng
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 40, 0)
                            
                            -- Quái vừa hiện là bị trừ máu tới chết
                            v.Humanoid.Health = 0 
                            
                            -- Bật Fast Attack hỗ trợ
                            _G.FastAttack = true
                            _G.AutoClick = true
                        end
                    end
                    
                    -- 3. TỰ ĐỘNG DI CHUYỂN QUA ĐẢO TIẾP THEO
                    local NextIsland = game:GetService("Workspace").Map.Raid:FindFirstChild("Island")
                    if NextIsland and not game:GetService("Workspace").Enemies:FindFirstChildOfClass("Model") then
                        TweenTo(NextIsland.CFrame * CFrame.new(0, 100, 0))
                    end
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 1060)
QuickBtn("Auto Raid Siêu Tốc ⚡", 1060, function(s) 
    _G.AutoRaid = s 
end)
-- [[ PHẦN 26: AUTO SĂN 30 ELITE HUNTER (LẤY KIẾM YAMA - SEA 3) ]]

_G.AutoEliteHunter = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoEliteHunter then
            pcall(function()
                -- 1. KIỂM TRA SỐ LƯỢNG ELITE ĐÃ DIỆT (DUY CẦN ĐỦ 30 CON)
                local Progress = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress")
                print("DuyHud: Duy đã diệt được " .. tostring(Progress) .. "/30 Elite Hunter")

                -- 2. TÌM QUÁI ELITE TRÊN BẢN ĐỒ
                local Elite = game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or 
                              game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or 
                              game:GetService("Workspace").Enemies:FindFirstChild("Urban")

                if Elite and Elite:FindFirstChild("HumanoidRootPart") and Elite.Humanoid.Health > 0 then
                    print("DuyHud: Đã tìm thấy " .. Elite.Name .. "! Đang tiêu diệt...")
                    
                    -- Bay sát phía trên đầu Elite để né chiêu
                    TweenTo(Elite.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                    
                    _G.FastAttack = true
                    _G.AutoClick = true
                else
                    -- 3. NẾU CHƯA CÓ QUÁI: TỰ ĐỘNG ĐI NHẬN NHIỆM VỤ TẠI CASTLE ON THE SEA
                    print("DuyHud: Đang đợi Elite hồi sinh (10 phút/con). Đang kiểm tra nhiệm vụ...")
                    local EliteNPC = CFrame.new(-5410, 315, -2820)
                    TweenTo(EliteNPC)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                end

                -- 4. KHI ĐỦ 30 CON: TỰ ĐỘNG ĐI RÚT KIẾM YAMA TẠI ĐẢO PHỤ NỮ (HYDRA ISLAND)
                if tonumber(Progress) >= 30 then
                    print("DuyHud: Đã đủ 30 con! Đang đi rút kiếm Yama...")
                    local YamaSword = CFrame.new(5220, 10, 4280) -- Tọa độ bệ đá Yama
                    TweenTo(YamaSword)
                    -- Click liên tục vào bệ đá để rút kiếm
                    fireclickdetector(game:GetService("Workspace").Map.HydraIsland.Sub.Yama.ClickDetector)
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 1110)
QuickBtn("Auto Săn Elite (Lấy Yama)", 1110, function(s) 
    _G.AutoEliteHunter = s 
end)
-- [[ PHẦN 27: AUTO LẤY KIẾM TUSHITA (GIẢI ĐỐ 5 NGỌN ĐUỐC - SEA 3) ]]

_G.AutoTushita = false

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoTushita then
            pcall(function()
                -- 1. KIỂM TRA ĐIỀU KIỆN (RIP_INDRA PHẢI CÒN SỐNG)
                local Indra = game:GetService("Workspace").Enemies:FindFirstChild("Rip_Indra")
                
                if Indra then
                    print("DuyHud: Đã thấy Indra! Đang tiến hành thắp 5 ngọn đuốc...")
                    
                    -- Tọa độ 5 ngọn đuốc tại Floating Turtle (Đảo Rùa)
                    local Torches = {
                        CFrame.new(-12100, 335, -7550), -- Đuốc 1: Bên trong vòm đá
                        CFrame.new(-11480, 400, -7800), -- Đuốc 2: Trên cầu đá
                        CFrame.new(-11600, 330, -9400), -- Đuốc 3: Bên trong cây dứa
                        CFrame.new(-12700, 420, -9600), -- Đuốc 4: Gần chỗ Boss Mythological
                        CFrame.new(-12850, 410, -8250)  -- Đuốc 5: Gần Dinh thự
                    }
                    
                    for i, pos in pairs(Torches) do
                        print("DuyHud: Đang thắp ngọn đuốc thứ " .. i)
                        TweenTo(pos)
                        task.wait(1.5) -- Đợi thắp đuốc
                    end
                    
                    -- 2. SAU KHI THẮP XONG: TỰ ĐỘNG ĐẾN DIỆT BOSS LONGMA ĐỂ LẤY KIẾM
                    print("DuyHud: Đã thắp xong! Đang đi diệt Boss Longma lấy Tushita...")
                    local Longma = game:GetService("Workspace").Enemies:FindFirstChild("Longma")
                    if Longma and Longma.Humanoid.Health > 0 then
                        TweenTo(Longma.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                        _G.FastAttack = true
                    else
                        TweenTo(CFrame.new(-10250, 330, -9500)) -- Tọa độ phòng Longma
                    end
                else
                    print("DuyHud: Đang đợi ai đó triệu hồi Rip_Indra để bắt đầu nhiệm vụ...")
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 1160)
QuickBtn("Auto Giải Đố Tushita", 1160, function(s) 
    _G.AutoTushita = s 
end)
-- [[ PHẦN 28: HỖ TRỢ LÀM NHIỆM VỤ SONG KIẾM ODEN (CDK - SEA 3) ]]

_G.AutoCDK = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoCDK then
            pcall(function()
                -- 1. TỌA ĐỘ PHÒNG GIẢI ĐỐ CDK (PHÍA SAU DINH THỰ - MANSION)
                local CDKPortal = CFrame.new(-12460, 375, -7560)
                
                -- 2. TỰ ĐỘNG KIỂM TRA CÁC THỬ THÁCH (TUSHITA SIDE)
                local TushitaScroll = game:GetService("Workspace").Map.CursedDualKatana.TushitaScroll
                if TushitaScroll then
                    print("DuyHud: Đang hỗ trợ làm thử thách Tushita (Dock Legend, Dot Dread, Pirate Raid)...")
                    -- Tự động bay tới các NPC bán thuyền (Dock Legend)
                    local DockNPCs = {CFrame.new(-10500, 15, -4250), CFrame.new(1000, 15, 1000)}
                    for _, pos in pairs(DockNPCs) do
                        TweenTo(pos)
                        task.wait(2)
                    end
                end

                -- 3. TỰ ĐỘNG KIỂM TRA CÁC THỬ THÁCH (YAMA SIDE)
                local YamaScroll = game:GetService("Workspace").Map.CursedDualKatana.YamaScroll
                if YamaScroll then
                    print("DuyHud: Đang hỗ trợ làm thử thách Yama (Pain and Suffering, Haze of Misery)...")
                    -- Logic tự động tìm quái có dấu chấm đỏ (Haze of Misery)
                    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("HazeTag") then
                            TweenTo(v.HumanoidRootPart.CFrame)
                            _G.FastAttack = true
                        end
                    end
                end

                -- 4. KHI XONG CẢ 6 MẢNH: TRIỆU HỒI BOSS CURSED SKELETON
                print("DuyHud: Đang đợi Duy hoàn thành các thử thách để ghép kiếm...")
                TweenTo(CFrame.new(-12460, 390, -7560))
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 1210)
QuickBtn("Auto Hỗ Trợ Làm CDK ⚔️", 1210, function(s) 
    _G.AutoCDK = s 
end)
-- [[ PHẦN 29: AUTO SĂN LƯỠI HÁI TỬ THẦN (HALLOW SCYTHE - BOSS SOUL REAPER) ]]

_G.AutoHallowScythe = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoHallowScythe then
            pcall(function()
                -- 1. KIỂM TRA ĐIỀU KIỆN (CẦN HALLOW ESSENCE)
                local HasEssence = game.Players.LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or 
                                   game.Players.LocalPlayer.Character:FindFirstChild("Hallow Essence")
                
                local AltarPos = CFrame.new(-9515, 165, -5380) -- Tọa độ bệ thờ triệu hồi Boss
                local Boss = game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper")

                if Boss and Boss:FindFirstChild("HumanoidRootPart") and Boss.Humanoid.Health > 0 then
                    print("DuyHud: Đang tiêu diệt Soul Reaper! Săn Lưỡi Hái Tử Thần...")
                    
                    -- Bay lên đầu Boss để né chiêu chém lửa
                    TweenTo(Boss.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                    
                    _G.FastAttack = true
                    _G.AutoClick = true
                    
                    -- Xả skill liên tục
                    local Keys = {"Z", "X", "C", "V"}
                    for _, key in pairs(Keys) do
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
                        task.wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
                    end
                elseif HasEssence then
                    print("DuyHud: Duy đã có Hallow Essence! Đang đi triệu hồi Boss...")
                    TweenTo(AltarPos)
                else
                    -- NẾU CHƯA CÓ: TỰ ĐI ĐỔI XƯƠNG TẠI DEATH KING ĐỂ LẤY TINH CHẤT
                    print("DuyHud: Đang đợi Hallow Essence... Đang đi quay xương tại Death King.")
                    local DeathKing = CFrame.new(-9480, 140, -5540)
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - DeathKing.Position).Magnitude > 20 then
                        TweenTo(DeathKing)
                    else
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RandomSurprise")
                    end
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 1260)
QuickBtn("Auto Săn Lưỡi Hái (Scythe)", 1260, function(s) 
    _G.AutoHallowScythe = s 
end)
-- [[ PHẦN 30: AUTO SĂN TAM KIẾM HUYỀN THOẠI (TTK - SEA 2) ]]

_G.AutoTTK = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoTTK then
            pcall(function()
                -- 1. DANH SÁCH TỌA ĐỘ NPC BÁN KIẾM (7 VỊ TRÍ)
                local DealerSpots = {
                    CFrame.new(-2460, 75, 450),  -- Trong vòm đá Đấu Trường
                    CFrame.new(630, 200, 480),   -- Trên ngọn cây cao nhất Green Zone
                    CFrame.new(-3050, 240, -4250), -- Trên đỉnh núi Fajita
                    CFrame.new(-450, 15, 280),   -- Gần Quán Cafe
                    CFrame.new(900, 150, 1100),  -- Khu vực Swan Pirates
                    CFrame.new(6480, 75, -6750), -- Lâu Đài Tuyết
                    CFrame.new(-1240, 15, -4290)  -- Đảo Nghĩa Địa
                }

                -- 2. TỰ ĐỘNG ĐI KIỂM TRA TỪNG VỊ TRÍ
                print("DuyHud: Đang đi tìm Legendary Sword Dealer...")
                for _, pos in pairs(DealerSpots) do
                    TweenTo(pos)
                    task.wait(1.5)
                end

                -- 3. NẾU ĐÃ CÓ ĐỦ 3 KIẾM (SHISUI, WANDO, SADDI) & 300 MASTERY
                -- Duy tới gặp NPC Mysterious Man ở đỉnh cao nhất Green Zone để ghép
                local TTK_NPC = CFrame.new(630, 1000, 480)
                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - TTK_NPC.Position).Magnitude < 100 then
                    print("DuyHud: Đang ghép Tam Kiếm Chân Nhân TTK cho Duy!")
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyTrueTripleKatana")
                end
            end)
        end
    end
end)

-- THÊM NÚT VÀO MENU (Tọa độ 1310)
QuickBtn("Auto Săn Tam Kiếm TTK", 1310, function(s) 
    _G.AutoTTK = s 
end)
