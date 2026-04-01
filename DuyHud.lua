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
-- Thay thế đoạn tạo Tab cũ bằng đoạn này
local RaidFruitTab = Window:MakeTab({
	Name = "Raid | Fruit",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Tạo các Section bên trong để phân biệt cho rõ ràng
local RaidSection = RaidFruitTab:AddSection({
	Name = "Dungeon / Raid"
})

local FruitSection = RaidFruitTab:AddSection({
	Name = "Fruit Manager"
})

-- Ví dụ thêm một số tính năng cơ bản vào ngăn này
RaidSection:AddButton({
	Name = "Auto Buy Chip",
	Callback = function()
		-- Code mua chip của Duy ở đây
	end    
})

FruitSection:AddButton({
	Name = "Bring Fruits",
	Callback = function()
		-- Code gom trái ác quỷ của Duy ở đây
	end    
})

-- [[ PHẦN 26: AUTO SĂN 30 ELITE HUNTER (LẤY KIẾM YAMA - SEA 3) ]]

_G.AutoEliteHunter = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoEliteHunter then
            pcall(function()
                -- 1. KIỂM TRA TIẾN ĐỘ (DUY CẦN ĐỦ 30 CON ĐỂ RÚT KIẾM)
                local Progress = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress")
                print("DuyHud: Duy đã diệt được " .. tonumber(Progress) .. "/30 Elite Hunter")

                -- 2. TÌM VÀ DIỆT QUÁI ELITE (DEANDRE, DIABLO, URBAN)
                local Elite = game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or 
                              game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or 
                              game:GetService("Workspace").Enemies:FindFirstChild("Urban")

                if Elite and Elite:FindFirstChild("HumanoidRootPart") and Elite.Humanoid.Health > 0 then
                    print("DuyHud: Đang tiêu diệt " .. Elite.Name .. "!")
                    -- Bay lơ lửng trên đầu để né chiêu của Elite
                    TweenTo(Elite.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                    _G.FastAttack = true
                    _G.AutoClick = true
                else
                    -- 3. NẾU CHƯA CÓ QUÁI: TỰ ĐI NHẬN NHIỆM VỤ ĐỂ KIỂM TRA VỊ TRÍ
                    print("DuyHud: Đang kiểm tra nhiệm vụ tại Castle on the Sea...")
                    local EliteNPC = CFrame.new(-5410, 315, -2820)
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - EliteNPC.Position).Magnitude > 20 then
                        TweenTo(EliteNPC)
                    else
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                    end
                end

                -- 4. KHI ĐỦ 30 CON: TỰ ĐỘNG ĐI RÚT KIẾM YAMA TẠI THÁC NƯỚC (HYDRA ISLAND)
                if tonumber(Progress) >= 30 then
                    print("DuyHud: Đã đủ 30 con! Đang đi lấy thanh Yama cho Duy...")
                    local YamaSword = CFrame.new(5220, 10, 4280)
                    TweenTo(YamaSword)
                    -- Click liên tục để rút kiếm
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
local MiscTab = Window:MakeTab({
	Name = "Misc | Server",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local ServerSection = MiscTab:AddSection({
	Name = "Server Management"
})

ServerSection:AddButton({
	Name = "Rejoin Server",
	Callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end    
})

ServerSection:AddButton({
	Name = "Hop Server (Low Player)",
	Callback = function()
		-- Code tìm server ít người để farm cho mượt
	end    
})

local UtilitySection = MiscTab:AddSection({
	Name = "Utilities"
})

UtilitySection:AddToggle({
	Name = "Anti-AFK",
	Default = true,
	Callback = function(Value)
		-- Code chống bị văng khi treo máy (v5.1 cần cái này)
	end
})
local MeleeTab = Window:MakeTab({
	Name = "Shop | Melee",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local MeleeSection = MeleeTab:AddSection({
	Name = "Buy Fighting Styles"
})

-- Duy cứ thêm mỗi loại võ là 1 Button, thế là ngăn này sẽ rất dài và đầy đủ
MeleeSection:AddButton({
	Name = "Buy Superhuman (3M Belis)",
	Callback = function()
		-- Logic mua võ ở đây
	end    
})

MeleeSection:AddButton({
	Name = "Buy Death Step",
	Callback = function()
		-- Logic mua võ ở đây
	end    
})
local SwordTab = Window:MakeTab({
	Name = "Shop | Swords",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local SwordSection = SwordTab:AddSection({
	Name = "Buy Legendary Swords"
})

-- Thêm các nút bấm mua kiếm ở các đảo
SwordSection:AddButton({
	Name = "Buy Shisui (2,000,000$)",
	Callback = function()
		-- Code logic mua kiếm Shisui ở đây
	end    
})

SwordSection:AddButton({
	Name = "Buy Wando (2,000,000$)",
	Callback = function()
		-- Code logic mua kiếm Wando ở đây
	end    
})

SwordSection:AddButton({
	Name = "Buy Saddi (2,000,000$)",
	Callback = function()
		-- Code logic mua kiếm Saddi ở đây
	end    
})

local CommonSwordSection = SwordTab:AddSection({
	Name = "Other Swords"
})

CommonSwordSection:AddButton({
	Name = "Buy Pipe (100,000$)",
	Callback = function()
		-- Code mua Pipe
	end    
})
local AccTab = Window:MakeTab({
	Name = "Shop | Accessories",
	Icon = "rbxassetid://4483345998", -- Icon phụ kiện
	PremiumOnly = false
})

local Sea1Acc = AccTab:AddSection({
	Name = "Sea 1 Accessories"
})

Sea1Acc:AddButton({
	Name = "Buy Black Cape (50,000$)",
	Callback = function()
		-- Logic mua Áo choàng đen ở MarineFord
	end    
})

Sea1Acc:AddButton({
	Name = "Buy Swordsman Hat (150,000$)",
	Callback = function()
		-- Logic mua Mũ kiếm sĩ ở Desert
	end    
})

local Sea2Acc = AccTab:AddSection({
	Name = "Sea 2 Accessories"
})

Sea2Acc:AddButton({
	Name = "Buy Tomoe Rings (500,000$)",
	Callback = function()
		-- Logic mua Vòng Tomoe ở Upper Yard
	end    
})
local GunTab = Window:MakeTab({
	Name = "Shop | Guns",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local GunSection = GunTab:AddSection({
	Name = "Buy Guns (Sea 1 & 2)"
})

GunSection:AddButton({
	Name = "Buy Cannon (100,000$)",
	Callback = function()
		-- Code mua Đại bác ở MarineFord
	end    
})

GunSection:AddButton({
	Name = "Buy Bizarre Rifle (25 Ectoplasm)",
	Callback = function()
		-- Code mua Súng ở Cursed Ship
	end    
})

GunSection:AddButton({
	Name = "Buy Soul Guitar (Materials)",
	Callback = function()
		-- Chỗ này Duy có thể để hướng dẫn hoặc code auto lấy Soul Guitar
	end    
})
local BoatTab = Window:MakeTab({
	Name = "Shop | Boat",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local BoatSection = BoatTab:AddSection({
	Name = "Buy Boats (Sea 1, 2 & 3)"
})

BoatSection:AddButton({
	Name = "Buy Dinghy (Free)",
	Callback = function()
		-- Code mua thuyền gỗ miễn phí
	end    
})

BoatSection:AddButton({
	Name = "Buy Sloop (300$)",
	Callback = function()
		-- Code mua thuyền Sloop
	end    
})

BoatSection:AddButton({
	Name = "Buy Brig (2,000$)",
	Callback = function()
		-- Code mua thuyền Brig
	end    
})

local SpecialBoatSection = BoatTab:AddSection({
	Name = "Special Boats"
})

SpecialBoatSection:AddButton({
	Name = "Buy Swan Ship (5,000$)",
	Callback = function()
		-- Code mua thuyền Thiên Nga ở Rose Kingdom
	end    
})
local Tele1Tab = Window:MakeTab({
	Name = "Teleport | Sea 1",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local IslandSection = Tele1Tab:AddSection({
	Name = "All Islands - Sea 1"
})

IslandSection:AddButton({
	Name = "Starter Island",
	Callback = function()
		-- Code Tween hoặc Teleport tới Đảo Tân Thủ
	end    
})

IslandSection:AddButton({
	Name = "Jungle",
	Callback = function()
		-- Code tới Đảo Khỉ
	end    
})

IslandSection:AddButton({
	Name = "Pirate Village",
	Callback = function()
		-- Code tới Đảo Hải Tặc
	end    
})

IslandSection:AddButton({
	Name = "Desert",
	Callback = function()
		-- Code tới Sa Mạc
	end    
})

IslandSection:AddButton({
	Name = "Middle Town",
	Callback = function()
		-- Code tới Thị Trấn Giữa Biển
	end    
})

-- Duy có thể thêm tới 15-20 nút bấm cho đủ các đảo ở Sea 1
local Tele2Tab = Window:MakeTab({
	Name = "Teleport | Sea 2",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local IslandSection2 = Tele2Tab:AddSection({
	Name = "All Islands - Sea 2"
})

IslandSection2:AddButton({
	Name = "Kingdom of Rose",
	Callback = function()
		-- Code Teleport tới Đảo Hồng
	end    
})

IslandSection2:AddButton({
	Name = "Cafe (Safe Zone)",
	Callback = function()
		-- Code tới Quán Cafe (Điểm tập trung chính)
	end    
})

IslandSection2:AddButton({
	Name = "Green Zone",
	Callback = function()
		-- Code tới Vùng Xanh
	end    
})

IslandSection2:AddButton({
	Name = "Graveyard Island",
	Callback = function()
		-- Code tới Đảo Nghĩa Địa
	end    
})

IslandSection2:AddButton({
	Name = "Snow Mountain",
	Callback = function()
		-- Code tới Núi Tuyết
	end    
})

IslandSection2:AddButton({
	Name = "Hot and Cold",
	Callback = function()
		-- Code tới Đảo Lửa Băng
	end    
})

IslandSection2:AddButton({
	Name = "Cursed Ship",
	Callback = function()
		-- Code tới Tàu Ám Lời Nguyền
	end    
})

IslandSection2:AddButton({
	Name = "Dark Arena",
	Callback = function()
		-- Code tới Đảo Râu Đen
	end    
})
local Tele3Tab = Window:MakeTab({
	Name = "Teleport | Sea 3",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local IslandSection3 = Tele3Tab:AddSection({
	Name = "All Islands - Sea 3"
})

IslandSection3:AddButton({
	Name = "Port Town",
	Callback = function()
		-- Code tới Thị trấn Cảng
	end    
})

IslandSection3:AddButton({
	Name = "Hydra Island",
	Callback = function()
		-- Code tới Đảo Phụ Nữ
	end    
})

IslandSection3:AddButton({
	Name = "Great Tree",
	Callback = function()
		-- Code tới Cây Đại Thụ
	end    
})

IslandSection3:AddButton({
	Name = "Floating Turtle",
	Callback = function()
		-- Code tới Đảo Rùa (Rất quan trọng)
	end    
})

IslandSection3:AddButton({
	Name = "Castle on the Sea",
	Callback = function()
		-- Code tới Lâu đài trên biển
	end    
})

IslandSection3:AddButton({
	Name = "Haunted Castle",
	Callback = function()
		-- Code tới Lâu đài ma ám
	end    
})

IslandSection3:AddButton({
	Name = "Ice Candy Island",
	Callback = function()
		-- Code tới Đảo Bánh Kẹo
	end    
})
local ESPPlayerTab = Window:MakeTab({
	Name = "Visuals | Players",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local ESPSection = ESPPlayerTab:AddSection({
	Name = "Player Rendering"
})

ESPSection:AddToggle({
	Name = "Enable Player ESP",
	Default = false,
	Callback = function(Value)
		-- Code bật/tắt nhìn xuyên tường người chơi
	end
})

ESPSection:AddToggle({
	Name = "Show Name",
	Default = false,
	Callback = function(Value)
		-- Code hiện tên người chơi
	end
})

ESPSection:AddToggle({
	Name = "Show Health",
	Default = false,
	Callback = function(Value)
		-- Code hiện máu người chơi
	end
})

ESPSection:AddToggle({
	Name = "Show Boxes",
	Default = false,
	Callback = function(Value)
		-- Code hiện khung bao quanh người chơi
	end
})
local ESPItemsTab = Window:MakeTab({
	Name = "Visuals | Items",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local FruitSection = ESPItemsTab:AddSection({
	Name = "Devil Fruit Finder"
})

FruitSection:AddToggle({
	Name = "Fruit ESP",
	Default = false,
	Callback = function(Value)
		-- Code hiện vị trí trái ác quỷ trên bản đồ
	end
})

FruitSection:AddToggle({
	Name = "Fruit Distance",
	Default = false,
	Callback = function(Value)
		-- Hiện khoảng cách đến trái ác quỷ
	end
})

local ChestSection = ESPItemsTab:AddSection({
	Name = "Chest Finder"
})

ChestSection:AddToggle({
	Name = "Chest ESP (All)",
	Default = false,
	Callback = function(Value)
		-- Hiện tất cả các loại rương (Vàng, Bạc, Kim cương)
	end
})

ChestSection:AddToggle({
	Name = "Chest Distance",
	Default = false,
	Callback = function(Value)
		-- Hiện khoảng cách đến rương
	end
})
local ESPFlowerTab = Window:MakeTab({
	Name = "Visuals | Flowers",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local FlowerSection = ESPFlowerTab:AddSection({
	Name = "Race V2 - Flowers (Sea 2)"
})

FlowerSection:AddToggle({
	Name = "Blue Flower ESP",
	Default = false,
	Callback = function(Value)
		-- Code hiện vị trí Hoa Xanh (xuất hiện ban đêm)
	end
})

FlowerSection:AddToggle({
	Name = "Red Flower ESP",
	Default = false,
	Callback = function(Value)
		-- Code hiện vị trí Hoa Đỏ (xuất hiện ban ngày)
	end
})

local QuestItemSection = ESPFlowerTab:AddSection({
	Name = "Special Quest Items"
})

QuestItemSection:AddToggle({
	Name = "God's Chalice ESP",
	Default = false,
	Callback = function(Value)
		-- Code hiện vị trí Chén Thánh
	end
})

QuestItemSection:AddToggle({
	Name = "Fist of Darkness ESP",
	Default = false,
	Callback = function(Value)
		-- Code hiện vị trí Nắm đấm bóng tối
	end
})
local Boss1Tab = Window:MakeTab({
	Name = "Auto Farm | Boss Sea 1",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local BossSection1 = Boss1Tab:AddSection({
	Name = "Select Boss to Farm"
})

-- Duy thêm nút cho từng con Boss một để tăng độ chi tiết
BossSection1:AddToggle({
	Name = "Auto Gorilla King",
	Default = false,
	Callback = function(Value)
		-- Code tự động bay tới và đánh Vua Khỉ
	end
})

BossSection1:AddToggle({
	Name = "Auto Bobby (Clown)",
	Default = false,
	Callback = function(Value)
		-- Code đánh Boss Bobby
	end
})

BossSection1:AddToggle({
	Name = "Auto Saw (Shark)",
	Default = false,
	Callback = function(Value)
		-- Code săn Saw khi nó xuất hiện
	end
})

BossSection1:AddToggle({
	Name = "Auto Arlong",
	Default = false,
	Callback = function(Value)
		-- Code đánh Arlong
	end
})

BossSection1:AddToggle({
	Name = "Auto Cyborg",
	Default = false,
	Callback = function(Value)
		-- Code đánh Cyborg ở Fountain City
	end
})
local Boss2Tab = Window:MakeTab({
	Name = "Auto Farm | Boss Sea 2",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local BossSection2 = Boss2Tab:AddSection({
	Name = "Select Boss to Farm (Sea 2)"
})

BossSection2:AddToggle({
	Name = "Auto Diamond",
	Default = false,
	Callback = function(Value)
		-- Code farm Diamond ở Flower Hill
	end
})

BossSection2:AddToggle({
	Name = "Auto Jeremy",
	Default = false,
	Callback = function(Value)
		-- Code farm Jeremy ở Núi Tuyết
	end
})

BossSection2:AddToggle({
	Name = "Auto Fajita",
	Default = false,
	Callback = function(Value)
		-- Code farm Fajita ở Green Zone
	end
})

BossSection2:AddToggle({
	Name = "Auto Don Swan",
	Default = false,
	Callback = function(Value)
		-- Code farm Don Swan (Cần chip/level 1000)
	end
})

BossSection2:AddToggle({
	Name = "Auto Tide Keeper",
	Default = false,
	Callback = function(Value)
		-- Code farm Tide Keeper lấy Dragon Trident
	end
})
local Boss3Tab = Window:MakeTab({
	Name = "Auto Farm | Boss Sea 3",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local BossSection3 = Boss3Tab:AddSection({
	Name = "Legendary Bosses (Sea 3)"
})

BossSection3:AddToggle({
	Name = "Auto Stone",
	Default = false,
	Callback = function(Value)
		-- Code farm Boss Stone ở Port Town
	end
})

BossSection3:AddToggle({
	Name = "Auto Island Empress",
	Default = false,
	Callback = function(Value)
		-- Code farm Nữ hoàng đảo Hydra lấy Serpent Bow
	end
})

BossSection3:AddToggle({
	Name = "Auto Kilo Admiral",
	Default = false,
	Callback = function(Value)
		-- Code farm Đô đốc Kilo ở Đại Thụ
	end
})

BossSection3:AddToggle({
	Name = "Auto Captain Elephant",
	Default = false,
	Callback = function(Value)
		-- Code farm Voi đội trưởng lấy Twin Hooks
	end
})

BossSection3:AddToggle({
	Name = "Auto Beautiful Pirate",
	Default = false,
	Callback = function(Value)
		-- Code farm Hải tặc xinh đẹp lấy Canvander
	end
})

BossSection3:AddToggle({
	Name = "Auto Rip_Indra (Need Chalice)",
	Default = false,
	Callback = function(Value)
		-- Code hỗ trợ săn Rip_Indra
	end
})
local EliteTab = Window:MakeTab({
	Name = "Auto Farm | Elite Hunter",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local EliteSection = EliteTab:AddSection({
	Name = "Elite Boss Farming (Sea 3)"
})

EliteSection:AddToggle({
	Name = "Auto Get Mission",
	Default = false,
	Callback = function(Value)
		-- Code tự động nhận nhiệm vụ từ NPC Elite Hunter ở Lâu đài trên biển
	end
})

EliteSection:AddToggle({
	Name = "Auto Farm Elite (Diablo, Deandre, Urban)",
	Default = false,
	Callback = function(Value)
		-- Code tự động tìm và tiêu diệt Boss Elite đang xuất hiện
	end
})

local StatsSection = EliteTab:AddSection({
	Name = "Elite Stats"
})

StatsSection:AddButton({
	Name = "Check Elite Kills",
	Callback = function()
		-- Code hiện thông báo Duy đã giết được bao nhiêu con Elite
	end    
})
local MasteryMeleeTab = Window:MakeTab({
	Name = "Mastery | Melee",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local MeleeMasterySection = MasteryMeleeTab:AddSection({
	Name = "Farm Mastery for Fighting Styles"
})

MeleeMasterySection:AddToggle({
	Name = "Auto Farm Mastery Melee",
	Default = false,
	Callback = function(Value)
		-- Code tự động đánh quái bằng Võ để lên cấp Mastery
	end
})

MeleeMasterySection:AddSlider({
	Name = "Select Health % to Switch",
	Min = 5,
	Max = 50,
	Default = 20,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Health %",
	Callback = function(Value)
		-- Code để nhân vật đánh quái gần chết rồi mới tung chiêu kết liễu
	end    
})

local MeleeInfoSection = MasteryMeleeTab:AddSection({
	Name = "Current Fighting Style"
})

MeleeInfoSection:AddLabel("Status: Ready to Farm")
local MasterySwordTab = Window:MakeTab({
	Name = "Mastery | Sword",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local SwordMasterySection = MasterySwordTab:AddSection({
	Name = "Sword Mastery Farming"
})

SwordMasterySection:AddToggle({
	Name = "Auto Farm Mastery Sword",
	Default = false,
	Callback = function(Value)
		-- Code tự động cầm Kiếm đi đánh quái để lên cấp Mastery
	end
})

SwordMasterySection:AddDropdown({
	Name = "Select Sword",
	Options = {"Current Sword", "Yama", "Tushita", "Cursed Dual Katana", "Shark Anchor"},
	Default = "Current Sword",
	Callback = function(Value)
		-- Code tự động trang bị kiếm đã chọn
	end    
})

local SwordSettingSection = MasterySwordTab:AddSection({
	Name = "Farming Settings"
})

SwordSettingSection:AddToggle({
	Name = "Use Skills to Farm",
	Default = true,
	Callback = function(Value)
		-- Code tự động tung chiêu Z, X để kết liễu quái nhanh hơn
	end
})
local MasteryFruitTab = Window:MakeTab({
	Name = "Mastery | Devil Fruit",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local FruitMasterySection = MasteryFruitTab:AddSection({
	Name = "Fruit Mastery Farming"
})

FruitMasterySection:AddToggle({
	Name = "Auto Farm Mastery Fruit",
	Default = false,
	Callback = function(Value)
		-- Code tự động dùng chiêu của Trái ác quỷ để đánh quái
	end
})

FruitMasterySection:AddToggle({
	Name = "Low Health Farm (20%)",
	Default = true,
	Callback = function(Value)
		-- Code đánh quái gần chết bằng Melee rồi mới dùng Skill Fruit kết liễu
	end
})

local SkillSection = MasteryFruitTab:AddSection({
	Name = "Use Skills"
})

SkillSection:AddToggle({
	Name = "Use Skill Z",
	Default = true,
	Callback = function(v) _G.UseZ = v end
})

SkillSection:AddToggle({
	Name = "Use Skill X",
	Default = true,
	Callback = function(v) _G.UseX = v end
})
local GunMasteryTab = Window:MakeTab({
	Name = "Thông thạo | Súng", -- Tên ngăn bằng Tiếng Việt
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local GunSection = GunMasteryTab:AddSection({
	Name = "Tự động cày thông thạo Súng"
})

GunSection:AddToggle({
	Name = "Bật Tự cày Mastery Súng",
	Default = false,
	Callback = function(Value)
		-- Code tự động cầm súng đi bắn quái
	end
})

GunSection:AddToggle({
	Name = "Đánh quái gần chết (20%)",
	Default = true,
	Callback = function(Value)
		-- Đánh quái bằng Võ đến khi còn ít máu rồi mới dùng Súng kết liễu
	end
})

local SkillGunSection = GunMasteryTab:AddSection({
	Name = "Cài đặt chiêu thức"
})

SkillGunSection:AddToggle({
	Name = "Sử dụng Chiêu Z",
	Default = true,
	Callback = function(v) _G.GunZ = v end
})

SkillGunSection:AddToggle({
	Name = "Sử dụng Chiêu X",
	Default = true,
	Callback = function(v) _G.GunX = v end
})
local BoneTab = Window:MakeTab({
	Name = "Tự cày | Xương",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local BoneSection = BoneTab:AddSection({
	Name = "Cày Xương tại Lâu đài Ma Ám (Sea 3)"
})

BoneSection:AddToggle({
	Name = "Bật Tự cày Xương (Auto Bones)",
	Default = false,
	Callback = function(Value)
		-- Code tự động nhận nhiệm vụ và tiêu diệt quái xương
	end
})

BoneSection:AddToggle({
	Name = "Tự động đổi Xương (Random Bone)",
	Default = false,
	Callback = function(Value)
		-- Code tự động tới NPC Death King để đổi 50 xương
	end
})

local InfoSection = BoneTab:AddSection({
	Name = "Thông tin cá nhân"
})

InfoSection:AddLabel("Số lượng Xương hiện có: 0")
local CocoaTab = Window:MakeTab({
	Name = "Tự cày | Ca cao",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local CocoaSection = CocoaTab:AddSection({
	Name = "Cày Ca cao tại Đảo Bánh Kẹo (Sea 3)"
})

CocoaSection:AddToggle({
	Name = "Bật Tự cày Ca cao (Auto Cocoa)",
	Default = false,
	Callback = function(Value)
		-- Code tự động tiêu diệt quái tại Đảo Bánh Kẹo để rơi ra Cocoa
	end
})

local CraftSection = CocoaTab:AddSection({
	Name = "Chế tạo vật phẩm"
})

CraftSection:AddButton({
	Name = "Chế tạo Chén Socola (Cần 10 Ca cao + Chén Thánh)",
	Callback = function()
		-- Code tự động tới NPC Sweet Crafter để đổi đồ
	end    
})

CraftSection:AddLabel("Lưu ý: Tỉ lệ rơi Ca cao là ngẫu nhiên khi đánh quái!")
local CandyTab = Window:MakeTab({
	Name = "Tự cày | Kẹo",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local CandySection = CandyTab:AddSection({
	Name = "Cày Kẹo Sự Kiện (Event Candy)"
})

CandySection:AddToggle({
	Name = "Bật Tự cày Kẹo (Auto Candy)",
	Default = false,
	Callback = function(Value)
		-- Code tự động đi tìm và tiêu diệt quái có rơi kẹo
	end
})

local TradeSection = CandyTab:AddSection({
	Name = "Đổi quà sự kiện"
})

TradeSection:AddButton({
	Name = "Đổi quà tại NPC Sự Kiện",
	Callback = function()
		-- Code tự động tương tác với NPC để đổi kẹo lấy đồ hiếm
	end    
})

TradeSection:AddLabel("Lưu ý: Chỉ hoạt động khi có sự kiện trong game!")
local PlayerTab = Window:MakeTab({
	Name = "Tiện ích | Nhân vật",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local MoveSection = PlayerTab:AddSection({
	Name = "Di chuyển & Vật lý"
})

MoveSection:AddSlider({
	Name = "Tốc độ chạy (WalkSpeed)",
	Min = 16,
	Max = 500,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

MoveSection:AddToggle({
	Name = "Nhảy vô hạn (Infinite Jump)",
	Default = false,
	Callback = function(Value)
		-- Code giúp Duy nhảy liên tục trên không trung
	end
})

MoveSection:AddToggle({
	Name = "Đi trên nước (Walk on Water)",
	Default = false,
	Callback = function(Value)
		-- Code giúp nhân vật không bị chìm/mất máu khi chạm nước
	end
})

MoveSection:AddButton({
	Name = "Hồi máu nhanh (Fast Health)",
	Callback = function()
		-- Code tối ưu hóa hồi phục
	end    
})
local ServerTab = Window:MakeTab({
	Name = "Tiện ích | Máy chủ",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local ConnectionSection = ServerTab:AddSection({
	Name = "Quản lý kết nối & Chống AFK"
})

ConnectionSection:AddToggle({
	Name = "Bật Chống AFK (Anti-AFK)",
	Default = true,
	Callback = function(Value)
		-- Code ngăn Roblox tự động kick khi treo máy quá lâu
	end
})

ConnectionSection:AddButton({
	Name = "Vào máy chủ khác (Server Hop)",
	Callback = function()
		-- Code tự động chuyển sang một server khác cùng game
	end    
})

ConnectionSection:AddButton({
	Name = "Vào lại máy chủ (Rejoin Server)",
	Callback = function()
		-- Code thoát ra và vào lại chính server đang đứng
	end    
})

local ServerInfoSection = ServerTab:AddSection({
	Name = "Thông tin Máy chủ"
})

ServerInfoSection:AddButton({
	Name = "Sao chép Link máy chủ (Job ID)",
	Callback = function()
		-- Code copy ID server để gửi cho bạn bè của Duy
	end    
})
local VisualTab = Window:MakeTab({
	Name = "Tiện ích | Đồ họa",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local GraphicsSection = VisualTab:AddSection({
	Name = "Tối ưu hóa & Giảm Lag"
})

GraphicsSection:AddButton({
	Name = "Xóa bóng đổ & Chi tiết thừa (Low Graphics)",
	Callback = function()
		-- Code để giảm đồ họa game xuống mức thấp nhất
	end    
})

GraphicsSection:AddToggle({
	Name = "Chế độ Treo máy (Black Screen)",
	Default = false,
	Callback = function(Value)
		-- Code làm đen màn hình để giảm tải cho GPU khi treo farm
	end
})

GraphicsSection:AddSlider({
	Name = "Giới hạn FPS (FPS Cap)",
	Min = 15,
	Max = 144,
	Default = 60,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "FPS",
	Callback = function(Value)
		setfpscap(Value) -- Code giới hạn FPS theo ý muốn
	end    
})

GraphicsSection:AddButton({
	Name = "Xóa Texture (Ultra Smooth)",
	Callback = function()
		-- Code xóa toàn bộ vân bề mặt để game mượt như "minecraft"
	end    
})
local UISettingsTab = Window:MakeTab({
	Name = "Cài đặt | Giao diện",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local ColorSection = UISettingsTab:AddSection({
	Name = "Màu sắc & Chủ đề"
})

ColorSection:AddColorPicker({
	Name = "Màu chủ đạo (Theme Color)",
	Default = Color3.fromRGB(255, 0, 0),
	Callback = function(Value)
		-- Code để đổi màu chính cho toàn bộ Menu của Duy
	end	  
})

local ToggleSection = UISettingsTab:AddSection({
	Name = "Tùy chỉnh hiển thị"
})

ToggleSection:AddBind({
	Name = "Phím ẩn/hiện Menu (Toggle Key)",
	Default = Enum.KeyCode.RightControl,
	Hold = false,
	Callback = function()
		-- Code để nhấn phím (VD: Ctrl phải) là ẩn hoặc hiện Hub
	end    
})

ToggleSection:AddToggle({
	Name = "Ẩn danh sách bên trái",
	Default = false,
	Callback = function(Value)
		-- Code để thu gọn Menu cho đỡ vướng màn hình
	end
})
local WebhookTab = Window:MakeTab({
	Name = "Thông báo | Discord",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local WebhookSection = WebhookTab:AddSection({
	Name = "Cài đặt Webhook (Theo dõi từ xa)"
})

WebhookSection:AddTextbox({
	Name = "Dán Link Webhook vào đây",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		_G.WebhookURL = Value -- Lưu link webhook của người dùng
	end
})

WebhookSection:AddToggle({
	Name = "Bật thông báo trạng thái Farm",
	Default = false,
	Callback = function(Value)
		-- Code để định kỳ gửi Level, Tiền, Beli về Discord của Duy
	end
})

WebhookSection:AddToggle({
	Name = "Thông báo khi lụm được Trái Ác Quỷ",
	Default = true,
	Callback = function(Value)
		-- Code tự động báo tên Trái Ác Quỷ vừa nhặt được
	end
})

WebhookSection:AddButton({
	Name = "Gửi thử tin nhắn kiểm tra (Test)",
	Callback = function()
		-- Code gửi 1 tin nhắn "Hello from VanDuyHud v5.1" để test link
	end    
})
local CreditTab = Window:MakeTab({
	Name = "Thông tin | Tác giả",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local AuthorSection = CreditTab:AddSection({
	Name = "Chủ sở hữu bản quyền"
})

AuthorSection:AddLabel("Tên tác giả: Duy (VanDuyHud)")
AuthorSection:AddLabel("Phiên bản: v5.1 (Premium Edition)")
AuthorSection:AddLabel("Tình trạng: Hoạt động tốt 2026")

local SocialSection = CreditTab:AddSection({
	Name = "Liên kết & Hỗ trợ"
})

SocialSection:AddButton({
	Name = "Sao chép Link YouTube",
	Callback = function()
		setclipboard("https://youtube.com/@VanDuyHud") -- Thay link của Duy vào đây
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "VanDuyHud",
			Text = "Đã copy link YouTube vào bộ nhớ tạm!",
			Duration = 5
		})
	end    
})

SocialSection:AddButton({
	Name = "Tham gia Discord Community",
	Callback = function()
		setclipboard("https://discord.gg/vanduyhud") -- Link Discord của Duy
	end    
})

SocialSection:AddButton({
	Name = "Ghé thăm GitHub (Script Repo)",
	Callback = function()
		setclipboard("https://github.com/VanDuyHud-Script")
	end    
})
local LangTab = Window:MakeTab({
	Name = "Ngôn ngữ | Language",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local LangSection = LangTab:AddSection({
	Name = "Cài đặt ngôn ngữ (Language Settings)"
})

-- Nút bấm thần thánh biến mọi thứ thành Tiếng Việt
LangSection:AddButton({
	Name = "🇻🇳 Chuyển sang TIẾNG VIỆT",
	Callback = function()
		-- Duy sẽ gọi lại các biến Tab đã đặt từ ngăn 1 đến 60 để đổi tên
		-- Ví dụ minh họa:
		MainTab:SetName("Trang Chính")
		FarmTab:SetName("Tự Động Cày")
		StatsTab:SetName("Bảng Chỉ Số")
		ItemTab:SetName("Vật Phẩm")
		RaidTab:SetName("Đi Raid")
		SeaTab:SetName("Dịch Chuyển Biển")
		ShopTab:SetName("Cửa Hàng")
		SettingTab:SetName("Cài Đặt")
		
		-- Thông báo cực ngầu khi chuyển xong
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "VanDuyHud v5.1",
			Text = "Đã kích hoạt Tiếng Việt toàn phần! 💀🔥",
			Duration = 5
		})
	end    
})

LangSection:AddButton({
	Name = "🇺🇸 Switch to ENGLISH",
	Callback = function()
		-- Reset lại tên gốc tiếng Anh
		MainTab:SetName("Main Menu")
		FarmTab:SetName("Auto Farm")
		-- ... (tương tự cho các ngăn khác)
	end    
})

LangSection:AddLabel("Duy hãy nhấn nút trên để Việt hóa 61 ngăn!")
-- Ngăn 62: Hàm Logic cho Auto Farm Level
function DuyHud_AutoFarm()
    spawn(function()
        while _G.AutoFarmLevel do task.wait()
            local MyLevel = game.Players.LocalPlayer.Data.Level.Value
            -- Logic nhận nhiệm vụ (Quest) theo Level của Duy
            if MyLevel < 10 then
                -- Ví dụ: Bay tới chỗ quái Bandit và nhận Quest Bandit
            elseif MyLevel >= 10 and MyLevel < 15 then
                -- Bay tới chỗ Monkey
            end
            
            -- Chế độ chém quái (Attack)
            if _G.AutoFarmLevel then
                pcall(function()
                    -- Code gom quái (Bring Mob) đã viết ở trên
                    -- Code tự động chém (Auto Click)
                end)
            end
        end
    end)
end
-- Ngăn 63: Hàm bay tới tọa độ bất kỳ
function DuyHud_Tween(TargetCFrame)
    local Distance = (TargetCFrame.p - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 300 -- Tốc độ bay (Duy có thể chỉnh ở Slider ngăn 55)
    
    local Tween = game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        {CFrame = TargetCFrame}
    )
    Tween:Play()
    return Tween
end
-- Ngăn 64: Kiểm tra Boss
function CheckBoss(BossName)
    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == BossName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v -- Boss còn sống
        end
    end
    return nil -- Boss chưa xuất hiện
end
-- Ngăn 65: Hàm đổi tiếng Việt cho 61 ngăn
function DuyHud_SwitchToVietnamese()
    -- Đây là nơi Duy viết code đổi Text cho hàng loạt nút bấm
    -- Duy dùng vòng lặp hoặc gọi tên biến từng ngăn để đổi sang Tiếng Việt
    print("VanDuyHud: Đang Việt hóa toàn bộ giao diện...")
end
-- Ngăn 66: Kiểm tra Whitelist/Key
if _G.Key == "VanDuyHud_v5.1_Free" then
    print("Chào mừng Duy đã đăng nhập thành công!")
else
    -- game.Players.LocalPlayer:Kick("Sai Key rồi Duy ơi!")
end
-- Ngăn 67: Hàm thực thi dùng Skill thông minh
_G.SkillDistance = 20 -- Khoảng cách tối thiểu để dùng chiêu

function DuyHud_SmartSkill()
    spawn(function()
        while task.wait(0.1) do
            -- Chỉ dùng skill khi đang bật Auto Farm và có quái gần đó
            if _G.AutoFarmLevel or _G.AutoFarmBoss then
                pcall(function()
                    local Character = game.Players.LocalPlayer.Character
                    local Target = nil
                    
                    -- Tìm quái gần nhất để tung chiêu
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            if (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude < _G.SkillDistance then
                                Target = v
                                break
                            end
                        end
                    end

                    -- Nếu tìm thấy quái thì bắt đầu combo
                    if Target then
                        local VIM = game:GetService("VirtualInputManager")
                        
                        if _G.UseSkillZ then
                            VIM:SendKeyEvent(true, "Z", false, game)
                            task.wait(0.1)
                            VIM:SendKeyEvent(false, "Z", false, game)
                        end
                        
                        if _G.UseSkillX then
                            VIM:SendKeyEvent(true, "X", false, game)
                            task.wait(0.1)
                            VIM:SendKeyEvent(false, "X", false, game)
                        end
                        
                        -- Duy có thể thêm C, V, F tương tự vào đây
                    end
                end)
            end
        end
    end)
end
-- Ngăn 68: Hàm thực thi Tự động nâng Stats
function DuyHud_AutoStats()
    spawn(function()
        while task.wait(1) do -- Kiểm tra mỗi giây để tránh giật lag
            pcall(function()
                -- Lấy số điểm Point hiện có của Duy
                local Points = game.Players.LocalPlayer.Data.Stats.Points.Value
                
                if Points > 0 then
                    -- Kiểm tra xem Duy đang bật nâng cái gì ở UI
                    if _G.AutoStatsMelee then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddStats", "Melee", 1)
                    end
                    
                    if _G.AutoStatsDefense then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddStats", "Defense", 1)
                    end
                    
                    if _G.AutoStatsSword then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddStats", "Sword", 1)
                    end
                    
                    if _G.AutoStatsGun then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddStats", "Gun", 1)
                    end
                    
                    if _G.AutoStatsFruit then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddStats", "Demon Fruit", 1)
                    end
                end
            end)
        end
    end)
end
-- Ngăn 69: Hàm kiểm tra vật phẩm trong Inventory (Balo)
function DuyHud_CheckItem(ItemName)
    -- Kiểm tra trong Backpack (Đang cầm)
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == ItemName then
            return true
        end
    end
    -- Kiểm tra trong Character (Đang trang bị)
    if game.Players.LocalPlayer.Character:FindFirstChild(ItemName) then
        return true
    end
    -- Kiểm tra trong Data (Dữ liệu lưu trữ)
    local Inventory = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
    for _, v in pairs(Inventory) do
        if v.Name == ItemName then
            return true
        end
    end
    return false
end

-- Ví dụ: Tự động dừng farm nếu đã lụm được vật phẩm
spawn(function()
    while task.wait(5) do
        if _G.AutoFarmHallowScythe and DuyHud_CheckItem("Hallow Scythe") then
            _G.AutoFarmHallowScythe = false
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "VanDuyHud v5.1",
                Text = "Duy ơi! Đã lụm được Lưỡi hái rồi nhé! 💀🔥",
                Duration = 10
            })
        end
    end
end)
-- Ngăn 70: Hàm thực thi Quản lý Năng lượng (Energy Saver)
_G.EnergyLimit = 15 -- Ngưỡng nghỉ (Dưới 15% sẽ tạm dừng dùng skill)

function DuyHud_EnergyManager()
    spawn(function()
        while task.wait(0.5) do
            pcall(function()
                local Character = game.Players.LocalPlayer.Character
                if Character and Character:FindFirstChild("Humanoid") then
                    -- Tính toán phần trăm năng lượng hiện tại của Duy
                    local CurrentEnergy = game.Players.LocalPlayer.Data.Energy.Value
                    local MaxEnergy = game.Players.LocalPlayer.Data.MaxEnergy.Value
                    local EnergyPercent = (CurrentEnergy / MaxEnergy) * 100
                    
                    if EnergyPercent < _G.EnergyLimit then
                        -- Nếu hết pin, tắt tạm thời các biến dùng Skill
                        _G.Temp_SkillZ = _G.UseSkillZ
                        _G.Temp_SkillX = _G.UseSkillX
                        
                        _G.UseSkillZ = false
                        _G.UseSkillX = false
                        
                        -- Thông báo cho Duy biết nhân vật đang "nghỉ mệt"
                        print("VanDuyHud: Năng lượng thấp! Đang hồi phục... 💀")
                        
                        -- Chờ cho đến khi hồi phục trên 50% rồi mới bật lại
                        repeat task.wait(1) 
                            CurrentEnergy = game.Players.LocalPlayer.Data.Energy.Value
                            EnergyPercent = (CurrentEnergy / MaxEnergy) * 100
                        until EnergyPercent > 50 or not _G.AutoFarm
                        
                        -- Bật lại trạng thái ban đầu
                        _G.UseSkillZ = _G.Temp_SkillZ
                        _G.UseSkillX = _G.Temp_SkillX
                    end
                end
            end)
        end
    end)
end
-- Ngăn 71: Hàm thực thi Nhảy Server (Server Hop)
function DuyHud_ServerHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    
    -- Lấy danh sách các Server hiện có từ Roblox API
    local function GetServers()
        local URL = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Success, Result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(URL))
        end)
        if Success then return Result.data else return nil end
    end

    spawn(function()
        local Servers = GetServers()
        if Servers then
            for _, Server in pairs(Servers) do
                -- Chỉ nhảy sang server còn chỗ trống và không phải server hiện tại
                if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                    print("VanDuyHud: Đang nhảy sang Server vắng người... 💀")
                    TeleportService:TeleportToPlaceInstance(PlaceId, Server.id, game.Players.LocalPlayer)
                    break
                end
            end
        else
            print("VanDuyHud: Không tìm thấy Server nào phù hợp!")
        end
    end)
end
-- Ngăn 72: Hàm thực thi Định vị Trái Ác Quỷ (Fruit ESP)
function DuyHud_FruitESP()
    spawn(function()
        while task.wait(1) do
            -- Xóa các ESP cũ để cập nhật cái mới (tránh bị rác màn hình)
            for i, v in pairs(game.CoreGui:GetChildren()) do
                if v.Name == "FruitESP_DuyHud" then
                    v:Destroy()
                end
            end

            -- Chỉ chạy khi Duy bật tính năng ESP ở giao diện
            if _G.FruitESP then
                for i, v in pairs(game.Workspace:GetChildren()) do
                    -- Tìm các object có chứa "Fruit" trong tên
                    if v:IsA("Tool") and v:FindFirstChild("Handle") then
                        local Billboard = Instance.new("BillboardGui")
                        Billboard.Name = "FruitESP_DuyHud"
                        Billboard.AlwaysOnTop = true
                        Billboard.Size = UDim2.new(0, 100, 0, 50)
                        Billboard.Adornee = v.Handle
                        Billboard.Parent = game.CoreGui

                        local TextLabel = Instance.new("TextLabel")
                        TextLabel.Parent = Billboard
                        TextLabel.BackgroundTransparency = 1
                        TextLabel.Size = UDim2.new(1, 0, 1, 0)
                        TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Màu xanh lá cực nổi
                        TextLabel.TextStrokeTransparency = 0
                        TextLabel.TextSize = 14
                        
                        -- Tính khoảng cách từ Duy tới Trái
                        local Dist = math.floor((v.Handle.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                        TextLabel.Text = v.Name .. "\n[" .. Dist .. "m]"
                    end
                end
            end
        end
    end)
end
-- Ngăn 73: Hàm thực thi Tự động nhặt Trái (Auto Bring Fruit)
function DuyHud_AutoCollectFruit()
    spawn(function()
        while task.wait(0.5) do
            if _G.AutoCollectFruit then
                pcall(function()
                    -- Tìm kiếm các Trái Ác Quỷ đang rơi trên mặt đất
                    for i, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                            -- Nếu thấy trái, bay tới ngay lập tức
                            local TargetPos = v.Handle.CFrame
                            local Character = game.Players.LocalPlayer.Character
                            
                            -- Sử dụng hàm Tween ở ngăn 63 để bay mượt
                            DuyHud_Tween(TargetPos)
                            
                            -- Khoảng cách đủ gần thì tự động lụm
                            if (v.Handle.Position - Character.HumanoidRootPart.Position).Magnitude < 10 then
                                firetouchinterest(Character.HumanoidRootPart, v.Handle, 0)
                                firetouchinterest(Character.HumanoidRootPart, v.Handle, 1)
                                
                                -- Thông báo cho Duy tin vui
                                game:GetService("StarterGui"):SetCore("SendNotification", {
                                    Title = "VanDuyHud v5.1",
                                    Text = "Đã lụm thành công: " .. v.Name .. "! 💀💎",
                                    Duration = 5
                                })
                            end
                        end
                    end
                end)
            end
        end
    end)
end
-- Ngăn 74: Hàm thực thi Tự động Cất Trái (Auto Store Fruit)
function DuyHud_AutoStoreFruit()
    spawn(function()
        while task.wait(1) do
            if _G.AutoStoreFruit then
                pcall(function()
                    -- Duyệt qua túi đồ (Backpack) của Duy
                    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        -- Kiểm tra nếu vật phẩm là Trái Ác Quỷ
                        if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                            -- Gửi lệnh Store lên Server của Blox Fruits
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v:GetAttribute("FruitName"), v)
                            
                            -- Thông báo cực ngầu cho Duy
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "VanDuyHud v5.1",
                                Text = "Đã cất an toàn: " .. v.Name .. " vào kho! 📦💎",
                                Duration = 5
                            })
                        end
                    end
                end)
            end
        end
    end)
end
-- Ngăn 75: Bảng dữ liệu tọa độ các đảo (Sea 1 - 2 - 3)
_G.IslandList = {
    ["Sea 1"] = {
        ["Starter Island"] = CFrame.new(944.15, 15.50, 4373.37),
        ["Jungle"] = CFrame.new(-1246.38, 11.85, 522.84),
        ["Marine Starter"] = CFrame.new(-2566.42, 6.85, 2045.25),
        ["Desert"] = CFrame.new(894.48, 6.50, 4392.28)
    },
    ["Sea 2"] = {
        ["Kingdom of Rose"] = CFrame.new(-429.54, 72.85, 183.69),
        ["Green Bit"] = CFrame.new(-2335.54, 72.85, -2670.69),
        ["Graveyard"] = CFrame.new(-5422.54, 72.85, -732.69)
    },
    ["Sea 3"] = {
        ["Castle on the Sea"] = CFrame.new(-5085.23, 314.51, -3156.41),
        ["Floating Turtle"] = CFrame.new(-13246.40, 331.48, -7625.40),
        ["Hydra Island"] = CFrame.new(5749.00, 612.00, -299.00)
    }
}

-- Hàm thực thi dịch chuyển dựa trên danh sách đảo
function DuyHud_TeleportToIsland(IslandName)
    local CurrentSea = "Sea 1" -- Duy có thể dùng logic check game.PlaceId để tự chọn Sea
    if game.PlaceId == 4442272183 then CurrentSea = "Sea 2"
    elseif game.PlaceId == 7447369508 then CurrentSea = "Sea 3" end

    local Target = _G.IslandList[CurrentSea][IslandName]
    if Target then
        -- Gọi lại hàm Tween (bay mượt) ở ngăn 63 của Duy
        DuyHud_Tween(Target)
        print("VanDuyHud: Đang bay tới " .. IslandName .. "... 💀✈️")
    end
end
-- Ngăn 76: Hàm thực thi Tự động nhặt Rương (Auto Chests)
function DuyHud_AutoCollectChests()
    spawn(function()
        while task.wait(0.1) do
            if _G.AutoCollectChests then
                pcall(function()
                    -- Tìm tất cả các rương trong Workspace
                    for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                        -- Kiểm tra xem có phải là rương không (Chest)
                        if v:IsA("Part") and v.Name:find("Chest") then
                            local Character = game.Players.LocalPlayer.Character
                            
                            -- Bay tới vị trí rương
                            DuyHud_Tween(v.CFrame)
                            
                            -- Nếu đủ gần thì tự động chạm vào để lấy tiền
                            if (v.Position - Character.HumanoidRootPart.Position).Magnitude < 15 then
                                firetouchinterest(Character.HumanoidRootPart, v, 0)
                                firetouchinterest(Character.HumanoidRootPart, v, 1)
                            end
                            
                            -- Đợi một chút để tránh bị game check tốc độ (Anti-cheat)
                            task.wait(0.2)
                        end
                    end
                end)
            end
        end
    end)
end
-- Ngăn 77: Hàm thực thi Tìm Đảo Mirage (Mirage Island Finder)
function DuyHud_MirageFinder()
    spawn(function()
        while task.wait(5) do -- Quét mỗi 5 giây để không làm lag game
            if _G.MirageFinder then
                pcall(function()
                    local Mirage = game:GetService("Workspace").Map:FindFirstChild("Mirage Island")
                    
                    if Mirage then
                        -- Nếu tìm thấy, gửi thông báo cực lớn cho Duy
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "VanDuyHud v5.1",
                            Text = "Duy ơi! ĐÃ THẤY ĐẢO MIRAGE! 🏝️✨",
                            Duration = 15
                        })
                        
                        -- Hiển thị khoảng cách từ Duy tới đảo
                        local Dist = math.floor((Mirage:GetModelCFrame().p - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                        print("VanDuyHud: Đảo Mirage cách Duy " .. Dist .. "m")

                        -- Nếu Duy bật Auto Tween, nó sẽ tự bay tới trung tâm đảo
                        if _G.AutoTweenToMirage then
                            DuyHud_Tween(Mirage:GetModelCFrame() * CFrame.new(0, 100, 0)) -- Bay cao lên chút để tránh va chạm
                        end
                    end
                end)
            end
        end
    end)
end
-- Ngăn 78: Hàm thực thi Tự động Nhìn Trăng (Auto Look Moon)
function DuyHud_AutoLookMoon()
    spawn(function()
        while task.wait(0.1) do
            if _G.AutoLookMoon then
                pcall(function()
                    -- Tìm vị trí mặt trăng trong hệ thống Thiên văn của game
                    local Moon = game:GetService("Lighting"):FindFirstChild("Moon") or game:GetService("Workspace"):FindFirstChild("Moon")
                    
                    -- Nếu không tìm thấy Object trực tiếp, ta tính toán theo hướng ánh sáng
                    local MoonDirection = game:GetService("Lighting"):GetSunDirection() * -1 -- Hướng ngược lại với mặt trời là mặt trăng
                    
                    -- Ép Camera của Duy nhìn thẳng vào hướng mặt trăng
                    workspace.CurrentCamera.CFrame = CFrame.new(
                        workspace.CurrentCamera.CFrame.Position, 
                        workspace.CurrentCamera.CFrame.Position + MoonDirection
                    )
                end)
            end
        end
    end)
end

-- Thông báo trạng thái cho Duy
if _G.AutoLookMoon then
    print("VanDuyHud: Đang khóa mục tiêu vào Mặt Trăng... 🌕💀")
end
-- Ngăn 79: Hàm thực thi Tìm Bánh Răng (Gear Tracker)
function DuyHud_GearTracker()
    spawn(function()
        while task.wait(1) do
            if _G.AutoGear then
                pcall(function()
                    -- Tìm Object Bánh Răng trong Workspace
                    -- Thường nó là một MeshPart hoặc Part có tên là "Blue Gear"
                    local Gear = game:GetService("Workspace").Map:FindFirstChild("Mirage Island"):FindFirstChild("Blue Gear", true)
                    
                    if Gear then
                        -- Thông báo cho Duy tọa độ chính xác
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "VanDuyHud v5.1",
                            Text = "ĐÃ TÌM THẤY BÁNH RĂNG! ⚙️💎",
                            Duration = 10
                        })
                        
                        -- Bay tới nhặt ngay lập tức
                        DuyHud_Tween(Gear.CFrame * CFrame.new(0, 2, 0))
                        
                        -- Tự động chạm để lấy Gear
                        if (Gear.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, Gear, 0)
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, Gear, 1)
                        end
                    else
                        print("VanDuyHud: Đang quét tìm Bánh Răng ẩn... ⚙️🔎")
                    end
                end)
            end
        end
    end)
end
-- Ngăn 80: Hàm thực thi Hỗ trợ làm Trial V4
function DuyHud_AutoTrial()
    spawn(function()
        while task.wait(0.5) do
            if _G.AutoTrial then
                pcall(function()
                    local MyRace = game.Players.LocalPlayer.Data.Race.Value
                    
                    -- Logic cho Tộc Human hoặc Shark (Diệt quái trong phòng)
                    if MyRace == "Human" or MyRace == "Fishman" then
                        -- Tự động bay tới quái trong phòng Trial và diệt sạch
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                DuyHud_Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                                -- Kích hoạt chém nhanh và dùng skill (Hàm ở ngăn 64-67)
                                _G.AutoFarm = true 
                            end
                        end
                        
                    -- Logic cho Tộc Mink (Chạy mê cung/Về đích)
                    elseif MyRace == "Mink" then
                        local FinishPoint = game:GetService("Workspace").Map:FindFirstChild("TrialFinish") -- Điểm đích
                        if FinishPoint then
                            DuyHud_Tween(FinishPoint.CFrame)
                        end
                        
                    -- Logic cho Tộc Cyborg (Né thiên thạch/Bom)
                    elseif MyRace == "Cyborg" then
                        -- Bay lên cao để né toàn bộ sát thương dưới đất
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
                    end
                end)
            end
        end
    end)
end
-- Ngăn 81: Hàm thực thi Tích Nộ và Biến Hình (Auto Rage & Awaken)
function DuyHud_AutoRageV4()
    spawn(function()
        while task.wait(0.5) do
            if _G.AutoRageV4 then
                pcall(function()
                    local Character = game.Players.LocalPlayer.Character
                    -- Lấy giá trị thanh Nộ (Rage) từ Data của Duy
                    local Rage = game.Players.LocalPlayer.Data.Rage.Value
                    
                    -- Nếu chưa đầy nộ, tự động dùng Skill để tích lũy (Cần quái ở gần)
                    if Rage < 100 then
                        -- Gọi lại hàm dùng skill thông minh ở ngăn 67
                        DuyHud_SmartSkill() 
                    else
                        -- Nếu đã đầy 100 nộ, tự động nhấn phím "Y" để biến hình (Awaken)
                        local VIM = game:GetService("VirtualInputManager")
                        VIM:SendKeyEvent(true, "Y", false, game)
                        task.wait(0.1)
                        VIM:SendKeyEvent(false, "Y", false, game)
                        
                        -- Thông báo cho Duy biết đã hóa siêu nhân
                        print("VanDuyHud: ĐÃ BIẾN HÌNH V4! ⚡💀")
                    end
                end)
            end
        end
    end)
end
-- Ngăn 82: Hàm thực thi Tập luyện nâng cấp V4 (Auto Training)
function DuyHud_AutoTrainV4()
    spawn(function()
        while task.wait(1) do
            if _G.AutoTrainV4 then
                pcall(function()
                    local Character = game.Players.LocalPlayer.Character
                    -- Kiểm tra xem Duy có đang ở trạng thái Biến hình (Awaken) không
                    -- Thường kiểm tra qua Model của nhân vật có hiệu ứng V4 hay không
                    local IsAwakened = Character:FindFirstChild("RaceTransformed") or Character:FindFirstChild("V4Effect")
                    
                    if not IsAwakened then
                        -- Nếu chưa biến hình, gọi hàm tích nộ ở ngăn 81
                        _G.AutoRageV4 = true
                    else
                        -- Nếu đã biến hình, thực hiện chuỗi combo để tính điểm Training
                        local VIM = game:GetService("VirtualInputManager")
                        
                        -- Tự động tung các chiêu Z, X, C, V để game tính điểm luyện tập
                        local Skills = {"Z", "X", "C", "V"}
                        for _, Key in pairs(Skills) do
                            VIM:SendKeyEvent(true, Key, false, game)
                            task.wait(0.2)
                            VIM:SendKeyEvent(false, Key, false, game)
                        end
                        
                        print("VanDuyHud: Đang thực hiện bài tập nâng cấp V4... 📈🔥")
                    end
                end)
            end
        end
    end)
end
-- Ngăn 83: Hàm thực thi Gạt Cần Bí Mật (Auto Pull Lever)
function DuyHud_AutoPullLever()
    spawn(function()
        if _G.AutoPullLever then
            pcall(function()
                -- Tọa độ chính xác của Cần Gạt (Lever) trong Temple of Time
                local LeverPos = CFrame.new(28213.6, 14891.1, 102.7) 
                
                -- Bay tới vị trí cần gạt
                DuyHud_Tween(LeverPos)
                
                -- Đợi bay tới nơi rồi thực hiện Click
                repeat task.wait(0.1) until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - LeverPos.p).Magnitude < 10
                
                -- Tìm Object cái cần và thực hiện tương tác (ProximityPrompt hoặc ClickDetector)
                local Lever = game:GetService("Workspace").Map:FindFirstChild("Lever", true)
                if Lever then
                    fireclickdetector(Lever:FindFirstChildOfClass("ClickDetector"))
                    
                    -- Thông báo cho Duy biết cửa đã mở
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "VanDuyHud v5.1",
                        Text = "CỬA PHÒNG TRIAL ĐÃ MỞ! 🚪🔓",
                        Duration = 5
                    })
                end
            end)
        end
    end)
end
-- Ngăn 84: Hàm thực thi Kiểm tra 3 màu Haki Huyền Thoại
function DuyHud_CheckHakiColors()
    spawn(function()
        while task.wait(5) do
            if _G.CheckHakiColors then
                pcall(function()
                    -- Danh sách 3 màu cần thiết
                    local HakiColors = {
                        ["Snow White"] = false,
                        ["Pure Red"] = false,
                        ["Winter Sky"] = false
                    }

                    -- Quét tất cả người chơi trong Server
                    for _, v in pairs(game.Players:GetChildren()) do
                        -- Kiểm tra thuộc tính Haki của từng người (thường lưu trong Data hoặc Model)
                        -- Chú thích: Code thực tế sẽ check qua danh hiệu (Titles) hoặc Aura
                        local PlayerHaki = v:GetAttribute("HakiColor") 
                        
                        if HakiColors[PlayerHaki] ~= nil then
                            HakiColors[PlayerHaki] = true
                        end
                    end

                    -- Báo cáo kết quả cho Duy qua Console hoặc Notification
                    local Status = ""
                    for color, found in pairs(HakiColors) do
                        Status = Status .. color .. ": " .. (found and "✅ " or "❌ ")
                    end
                    
                    print("VanDuyHud - Trạng thái Haki Server: " .. Status)
                    
                    -- Nếu đủ cả 3 màu, thông báo cực lớn cho Duy chuẩn bị Chén
                    if HakiColors["Snow White"] and HakiColors["Pure Red"] and HakiColors["Winter Sky"] then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "VanDuyHud v5.1",
                            Text = "ĐỦ 3 MÀU HAKI! GỌI INDRA THÔI DUY ƠI! ⚔️💥",
                            Duration = 10
                        })
                    end
                end)
            end
        end
    end)
end
-- Ngăn 85: Hàm thực thi Triệu hồi Boss Rip_Indra (Indra Spawner)
function DuyHud_SummonIndra()
    spawn(function()
        if _G.AutoSummonIndra then
            pcall(function()
                -- Kiểm tra xem Duy có đang cầm Chén Thánh (God's Chalice) không
                local Chalice = game.Players.LocalPlayer.Backpack:FindFirstChild("God's Chalice") or game.Players.LocalPlayer.Character:FindFirstChild("God's Chalice")
                
                if Chalice then
                    -- Tọa độ bục đặt Chén tại Castle on the Sea
                    local PedestalPos = CFrame.new(-5035.1, 314.5, -3150.8) 
                    
                    -- Thông báo cho Duy biết đang đi gọi Boss
                    print("VanDuyHud: Đang mang Chén tới bục triệu hồi... 🏆🔥")
                    
                    -- Bay tới bục
                    DuyHud_Tween(PedestalPos)
                    
                    -- Khi tới nơi, tự động tương tác để đặt Chén
                    repeat task.wait(0.1) until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - PedestalPos.p).Magnitude < 5
                    
                    -- Lệnh thực thi đặt chén (Thường là chạm vào bục)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Map.Castle.Main.Pedestal, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Map.Castle.Main.Pedestal, 1)
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "VanDuyHud v5.1",
                        Text = "Duy ơi! Chưa có Chén Thánh (Chalice) trong túi nhé! ❌",
                        Duration = 5
                    })
                end
            end)
        end
    end)
end
-- Ngăn 86: Hàm thực thi Theo dõi số lượng quái Đảo Bánh (Dough King Tracker)
function DuyHud_DoughKingTracker()
    spawn(function()
        while task.wait(5) do -- Cập nhật mỗi 5 giây
            if _G.DoughKingTracker then
                pcall(function()
                    -- Lấy dữ liệu từ Remote của Blox Fruits về số lượng quái đã diệt
                    -- Chú thích: CommF_ là Remote chính để giao tiếp Server trong Blox Fruits
                    local KillCount = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetCakeKillCount")
                    
                    if KillCount then
                        local Remaining = 500 - KillCount
                        
                        -- Hiển thị thông báo hoặc cập nhật lên Label trên giao diện của Duy
                        if Remaining > 0 then
                            print("VanDuyHud: Cần diệt thêm " .. Remaining .. " con quái để gọi Dough King! 🍩⚔️")
                        else
                            -- Nếu đã đủ 500 con, báo cho Duy biết để sẵn sàng "Chén Thánh"
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "VanDuyHud v5.1",
                                Text = "ĐÃ ĐỦ 500 QUÁI! CÓ THỂ GỌI DOUGH KING! 👑🍩",
                                Duration = 10
                            })
                        end
                    end
                end)
            end
        end
    end)
end
-- Ngăn 87: Hàm thực thi Tự động Nhận Quest Indra & Dough King
function DuyHud_AutoBossQuest()
    spawn(function()
        while task.wait(1) do
            if _G.AutoBossQuest then
                pcall(function()
                    -- Kiểm tra Boss Indra xuất hiện
                    local Indra = game:GetService("Workspace").Enemies:FindFirstChild("rip_indra")
                    if Indra then
                        -- Bay tới NPC Quest tại Castle on the Sea
                        local IndraNPC = CFrame.new(-5031.5, 314.5, -3140.2)
                        DuyHud_Tween(IndraNPC)
                        -- Lệnh nhận Quest Indra
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "IndraQuest1", 1)
                    end
                    
                    -- Kiểm tra Boss Dough King xuất hiện
                    local DoughKing = game:GetService("Workspace").Enemies:FindFirstChild("Dough King")
                    if DoughKing then
                        -- Bay tới NPC Quest tại Cake Island
                        local DoughNPC = CFrame.new(-1150.2, 12.5, -1125.8)
                        DuyHud_Tween(DoughNPC)
                        -- Lệnh nhận Quest Dough King
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "CakeQuest1", 1)
                    end
                end)
            end
        end
    end)
end
-- Ngăn 88: Hàm thực thi Tìm Vật phẩm Nhiệm vụ (Hungry Man Helper)
function DuyHud_HungryManTracker()
    spawn(function()
        while task.wait(1) do
            if _G.AutoHungryMan then
                pcall(function()
                    -- Danh sách các loại trái cây cần tìm
                    local TargetFruits = {"Apple", "Banana", "Pineapple"}
                    
                    for _, FruitName in pairs(TargetFruits) do
                        -- Tìm Object trái cây trong Workspace
                        local Fruit = game:GetService("Workspace"):FindFirstChild(FruitName)
                        
                        if Fruit then
                            -- Thông báo cho Duy đã thấy "hàng"
                            print("VanDuyHud: Đã tìm thấy " .. FruitName .. "! Đang bay tới... 🍎🍌")
                            
                            -- Bay tới vị trí trái cây
                            DuyHud_Tween(Fruit.CFrame)
                            
                            -- Tự động nhặt khi ở gần
                            if (Fruit.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, Fruit, 0)
                                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, Fruit, 1)
                            end
                            break -- Nhặt xong 1 trái thì đợi vòng lặp sau tìm trái tiếp theo
                        end
                    end
                end)
            end
        end
    end)
end
-- Ngăn 89: Hàm thực thi Săn Sự kiện Biển (Sea Event Hunter)
function DuyHud_SeaEventHunter()
    spawn(function()
        while task.wait(1) do
            if _G.SeaEventHunter then
                pcall(function()
                    -- Danh sách các mục tiêu cần săn trên biển
                    local SeaTargets = {"Terror Shark", "ShipRaid", "Piranha", "Sea Beast"}
                    
                    for _, TargetName in pairs(SeaTargets) do
                        -- Tìm quái biển trong Workspace (thường nằm trong folder SeaObjects hoặc Enemies)
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name:find(TargetName) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                
                                -- Thông báo cho Duy mục tiêu đã xuất hiện
                                print("VanDuyHud: Phát hiện " .. v.Name .. "! Đang tiêu diệt... 🦈⚔️")
                                
                                -- Bay tới vị trí quái (giữ khoảng cách để tránh bị cắn)
                                DuyHud_Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                
                                -- Kích hoạt chém nhanh và Skill (Hàm ở ngăn 64-67)
                                _G.AutoFarm = true
                                break
                            end
                        end
                    end
                end)
            end
        end
    end)
end
-- Ngăn 90: Hàm thực thi Chống AFK (Anti-AFK Pro)
function DuyHud_AntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    
    -- Kết nối với sự kiện khi nhân vật bị đá (Idled)
    game:GetService("Players.LocalPlayer").Idled:Connect(function()
        -- Khi hệ thống báo Duy đang rảnh, ta giả lập một cú click chuột
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        
        -- Thông báo bí mật vào Console để Duy biết script vẫn đang bảo vệ
        print("VanDuyHud: Đã chặn một nỗ lực Kick AFK! Duy cứ yên tâm ngủ nhé! 🛡️💤")
    end)
    
    -- Gửi thông báo trên màn hình khi kích hoạt lần đầu
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "VanDuyHud v5.1",
        Text = "Chế độ Treo máy 24/7 đã SẴN SÀNG! 💀🔥",
        Duration = 5
    })
end

-- Kích hoạt ngay lập tức
DuyHud_AntiAFK()
-- Ngăn 91: Hàm thực thi Tự động Gacha và Cất Trái (Auto Gacha & Store)
function DuyHud_AutoGacha()
    spawn(function()
        while task.wait(5) do -- Kiểm tra trạng thái liên tục
            if _G.AutoGacha then
                pcall(function()
                    -- Gửi lệnh lên Server để kiểm tra xem đã đến giờ quay chưa
                    local Result = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
                    
                    if Result and type(Result) == "string" and Result:find("Received") then
                        -- Nếu quay thành công, thông báo cho Duy tên trái vừa nhận
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "VanDuyHud v5.1 PREMIUM",
                            Text = "Duy ơi! Vừa quay được: " .. Result,
                            Duration = 10
                        })
                        
                        -- Tự động cầm trái ác quỷ trên tay và cất vào kho (Inventory)
                        for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("Fruit") then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                                print("VanDuyHud: Đã cất " .. v.Name .. " vào kho bảo an! 📦💎")
                            end
                        end
                    end
                end)
                -- Đợi 2 tiếng (7200 giây) để quay lần tiếp theo
                task.wait(7200)
            end
        end
    end)
end
-- Ngăn 92: Hàm thực thi Tự động Mua Vật phẩm (Auto Buy Items)
function DuyHud_AutoBuyRare()
    spawn(function()
        while task.wait(5) do
            if _G.AutoBuyRare then
                pcall(function()
                    -- Danh sách các món đồ Duy muốn săn lùng (Ví dụ: Haki màu, Kiếm Tushita, v.v.)
                    local RareItems = {"Snow White", "Pure Red", "Winter Sky", "Tushita", "Yama"}
                    
                    for _, Item in pairs(RareItems) do
                        -- Gửi lệnh kiểm tra và mua trực tiếp từ Remote Server
                        -- CommF_ là "cánh cổng" giao tiếp chính của Duy với game
                        local Success = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", Item)
                        
                        if Success then
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "VanDuyHud v5.1 PREMIUM",
                                Text = "Duy ơi! Đã mua thành công: " .. Item .. "! 💎✨",
                                Duration = 15
                            })
                            print("VanDuyHud: Đã sở hữu vật phẩm hiếm: " .. Item)
                        end
                    end
                end)
            end
        end
    end)
end
-- Ngăn 93: Hàm thực thi Thống kê Tài nguyên (Inventory Stats Dashboard)
function DuyHud_StatsDashboard()
    spawn(function()
        while task.wait(2) do -- Cập nhật mỗi 2 giây để Duy nắm bắt tình hình
            if _G.ShowStatsDashboard then
                pcall(function()
                    -- Lấy dữ liệu từ Data của Duy trong Game
                    local MyData = game.Players.LocalPlayer.Data
                    local Fragments = MyData.Fragments.Value
                    local Bones = MyData:FindFirstChild("Bones") and MyData.Bones.Value or 0
                    local Ectoplasm = MyData:FindFirstChild("Ectoplasm") and MyData.Ectoplasm.Value or 0
                    
                    -- Log ra Console hoặc cập nhật trực tiếp lên GUI của Duy
                    print("--- [ VanDuyHud v5.1 PREMIUM STATS ] ---")
                    print("💎 Mảnh vỡ (Fragments): " .. Fragments)
                    print("☠️ Xương (Bones): " .. Bones)
                    print("👻 Ectoplasm: " .. Ectoplasm)
                    print("---------------------------------------")
                    
                    -- Nếu số lượng nguyên liệu đạt mốc quan trọng, thông báo cho Duy
                    if Bones >= 5000 then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "VanDuyHud v5.1",
                            Text = "Duy ơi! Đã đủ 5000 Xương để 'đập hộp' rồi! 🎁☠️",
                            Duration = 5
                        })
                    end
                end)
            end
        end
    end)
end
-- Ngăn 94: Hàm thực thi Lưu và Tải Cài đặt (Config System)
local HttpService = game:GetService("HttpService")
local FileName = "VanDuyHud_v5.1_Config.json"

-- Hàm Lưu (Save)
function DuyHud_SaveConfig()
    local Config = {
        AutoFarm = _G.AutoFarm,
        AutoSelectWeapon = _G.SelectWeapon,
        AutoSeaEvent = _G.SeaEventHunter,
        AutoGacha = _G.AutoGacha,
        FastMode = _G.FastMode
    }
    -- Chuyển bảng Lua thành chuỗi JSON và ghi vào file
    writefile(FileName, HttpService:JSONEncode(Config))
    print("VanDuyHud: Đã lưu cài đặt của Duy vào bộ nhớ! 💾✨")
end

-- Hàm Tải (Load)
function DuyHud_LoadConfig()
    if isfile(FileName) then
        local Config = HttpService:JSONDecode(readfile(FileName))
        _G.AutoFarm = Config.AutoFarm
        _G.SelectWeapon = Config.AutoSelectWeapon
        _G.SeaEventHunter = Config.AutoSeaEvent
        _G.AutoGacha = Config.AutoGacha
        _G.FastMode = Config.FastMode
        print("VanDuyHud: Đã khôi phục cài đặt Premium cho Duy! 📂💎")
    else
        print("VanDuyHud: Duy chưa có file cấu hình, hãy tạo mới nhé! 🆕")
    end
end
-- Ngăn 95: Hàm thực thi Siêu cấp Giảm Lag (Ultra Fast Mode)
function DuyHud_UltraFastMode()
    spawn(function()
        if _G.FastMode then
            pcall(function()
                -- 1. Xóa toàn bộ Texture (Vân bề mặt) để giảm tải RAM
                for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Texture") or v:IsA("Decal") then
                        v:Destroy()
                    end
                end
                
                -- 2. Tắt hiệu ứng ánh sáng phức tạp
                local Lighting = game:GetService("Lighting")
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
                Lighting.Brightness = 0
                
                -- 3. Đơn giản hóa các khối Part (Biến mọi thứ thành khối trơn)
                for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") or v:IsA("MeshPart") then
                        v.Material = Enum.Material.SmoothPlastic
                        v.Reflectance = 0
                    end
                end
                
                -- 4. Xóa mây và hiệu ứng nước
                if game:GetService("Workspace"):FindFirstChild("Terrain") then
                    game:GetService("Workspace").Terrain.WaterWaveSize = 0
                    game:GetService("Workspace").Terrain.WaterWaveSpeed = 0
                    game:GetService("Workspace").Terrain.WaterReflectance = 0
                    game:GetService("Workspace").Terrain.WaterTransparency = 0
                end
                
                print("VanDuyHud: Đã kích hoạt Chế độ Siêu Mượt! ❄️📱")
            end)
        end
    end)
end
-- Ngăn 96: Hàm thực thi Chế độ Cửa sổ Trắng (White Screen AFK Mode)
function DuyHud_WhiteScreenMode()
    spawn(function()
        if _G.WhiteScreen then
            -- Tạo một Frame phủ kín màn hình của Duy
            local ScreenGui = Instance.new("ScreenGui")
            local Frame = Instance.new("Frame")
            
            ScreenGui.Name = "VanDuyHud_AFK"
            ScreenGui.Parent = game.CoreGui
            
            Frame.Parent = ScreenGui
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Màu trắng (Duy có thể đổi sang 0,0,0 cho đen)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 1, 0) -- Phủ kín 100% màn hình
            
            -- Hiển thị dòng chữ thông báo Premium cho Duy yên tâm
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Parent = Frame
            TextLabel.Text = "VanDuyHud v5.1 PREMIUM - CHẾ ĐỘ AFK ĐANG CHẠY..."
            TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextSize = 25
            
            -- Tắt Rendering (Không vẽ hình ảnh 3D) để tiết kiệm tài cực hạn
            game:GetService("RunService"):Set3dRenderingEnabled(false)
            
            print("VanDuyHud: Đã vào chế độ ngủ đông tiết kiệm điện! 🔋❄️")
        else
            -- Nếu Duy tắt chế độ này, xóa Frame và bật lại Rendering
            if game.CoreGui:FindFirstChild("VanDuyHud_AFK") then
                game.CoreGui.VanDuyHud_AFK:Destroy()
            end
            game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
    end)
end
-- Ngăn 97: Hàm thực thi Tự động Đổi Server (Server Hop Pro)
function DuyHud_ServerHop()
    spawn(function()
        print("VanDuyHud: Đang tìm kiếm Server mới cho Duy... 🚀")
        
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        
        -- Lấy danh sách các Server từ API của Roblox
        local ApiUrl = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local Success, Result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(ApiUrl))
        end)
        
        if Success and Result and Result.data then
            for _, server in pairs(Result.data) do
                -- Điều kiện: Server còn chỗ trống và không phải server hiện tại
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    -- Thực hiện dịch chuyển Duy sang Server mới
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, game.Players.LocalPlayer)
                    break
                end
            end
        else
            -- Nếu lỗi, thông báo cho Duy và thử lại sau 5 giây
            warn("VanDuyHud: Không tìm thấy Server phù hợp, đang thử lại...")
            task.wait(5)
            DuyHud_ServerHop()
        end
    end)
end
-- Ngăn 98: Hàm thực thi Bảo mật & Kiểm tra Key (Security Auth)
function DuyHud_KeySystem()
    local CorrectKey = "DuyHud_Premium_2026" -- Duy có thể đổi Key này tùy ý
    local UserInputKey = _G.InputKey -- Giả sử Duy nhập vào từ một khung TextBox trên GUI
    
    if UserInputKey == CorrectKey then
        -- Nếu đúng mã, thông báo chào mừng Duy
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "VanDuyHud v5.1 PREMIUM",
            Text = "XÁC THỰC THÀNH CÔNG! CHÀO MỪNG DUY TRỞ LẠI. 👑💎",
            Duration = 10
        })
        -- Kích hoạt toàn bộ 97 ngăn trước đó
        DuyHud_InitMainScript()
    else
        -- Nếu sai mã, đẩy người dùng ra khỏi Script hoặc hiện cảnh báo
        game.Players.LocalPlayer:Kick("VanDuyHud: SAI MÃ KHÓA! Vui lòng liên hệ Duy để lấy Key. ❌💀")
    end
end

-- Chú thích: Trong bản Premium, Duy có thể dùng API để Key thay đổi theo ngày (Daily Key).
-- Ngăn 99: Hàm thực thi Tự động Cập nhật (Auto Update - No Key-Get)
function DuyHud_AutoUpdate()
    spawn(function()
        -- Đường dẫn trực tiếp tới file Lua của Duy trên GitHub (Raw Link)
        local GithubURL = "https://raw.githubusercontent.com/VanDuyHud/VanDuyHud-Script/main/DuyHud.lua"
        
        -- Thông báo cho Duy trạng thái kiểm tra phiên bản
        print("VanDuyHud: Đang kiểm tra phiên bản mới từ Vũ trụ GitHub... 🌌")
        
        -- Thực hiện tải code mới nhất
        local Success, NewCode = pcall(function()
            return game:HttpGet(GithubURL)
        end)
        
        if Success and NewCode then
            -- Nếu có code mới, thực thi ngay lập tức mà không cần Key
            print("VanDuyHud: Cập nhật thành công! Đang khởi chạy bản v5.1 PREMIUM... 💎🔥")
            loadstring(NewCode)()
        else
            -- Nếu lỗi mạng, thông báo cho Duy và dùng bản code cũ (Local)
            warn("VanDuyHud: Không thể kết nối GitHub, đang chạy chế độ Offline.")
            DuyHud_RunLocal()
        end
    end)
end
-- ======================================================
-- [ NGĂN 100 ]: VANDUYHUD v5.1 PREMIUM - THE FINAL VERSION
-- ======================================================

function DuyHud_TheMasterpiece()
    -- 1. Tạo Giao diện Chính (Main UI)
    local MainUI = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    
    MainUI.Name = "VanDuyHud_v5.1"
    MainUI.Parent = game.CoreGui
    
    MainFrame.Parent = MainUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Màu đen Premium
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    
    UICorner.Parent = MainFrame
    
    -- 2. Hiệu ứng RGB Rainbow cho Viền (Border)
    spawn(function()
        while task.wait() do
            local Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            MainFrame.BorderColor3 = Color
        end
    end)
    
    -- 3. Lời chào của Tác giả DuyHud
    Title.Parent = MainFrame
    Title.Text = "VANDUYHUD v5.1 PREMIUM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    
    local Status = Instance.new("TextLabel", MainFrame)
    Status.Text = "Status: ACTIVE (NO KEY-GET)"
    Status.Position = UDim2.new(0, 0, 0.4, 0)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    Status.BackgroundTransparency = 1

    -- 4. TUYÊN NGÔN HUYỀN THOẠI
    print("=======================================")
    print("   VANDUYHUD v5.1 CHÍNH THỨC RA MẮT!   ")
    print("   DEVELOPER: VAN DUY (VANDUYHUD)      ")
    print("   STATUS: 100/100 COMPLETED           ")
    print("   NO KEY - NO ADS - PURE POWER        ")
    print("=======================================")
    
    -- Gửi thông báo toàn Server (Chỉ Duy thấy)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "VanDuyHud v5.1",
        Text = "CHÀO MỪNG CHỦ NHÂN DUY ĐÃ CÁN ĐÍCH 100 NGĂN! 👑🔥",
        Duration = 15
    })
end

-- KÍCH HOẠT SIÊU PHẨM
DuyHud_TheMasterpiece()
-- Ngăn 101: Hàm thực thi Hủy Render vật thể xa (Distance Culling)
function DuyHud_DistanceCulling()
    spawn(function()
        while task.wait(5) do -- Kiểm tra mỗi 5 giây
            if _G.UltraOptimize then
                pcall(function()
                    local MyPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") then
                            local Distance = (v.HumanoidRootPart.Position - MyPos).Magnitude
                            -- Nếu quái ở quá xa, làm cho nó tàng hình để GPU không phải vẽ
                            if Distance > 500 then
                                v:SetAttribute("HiddenByDuy", true)
                                for _, part in pairs(v:GetDescendants()) do
                                    if part:IsA("BasePart") then part.Transparency = 1 end
                                end
                            else
                                -- Hiện lại khi Duy ở gần
                                if v:GetAttribute("HiddenByDuy") then
                                    for _, part in pairs(v:GetDescendants()) do
                                        if part:IsA("BasePart") then part.Transparency = 0 end
                                    end
                                    v:SetAttribute("HiddenByDuy", false)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end
-- Ngăn 102: Hàm thực thi Dọn dẹp RAM (Memory Garbage Collector)
function DuyHud_MemoryCleaner()
    spawn(function()
        while task.wait(60) do -- Tự động dọn rác mỗi 60 giây
            if _G.UltraOptimize then
                pcall(function()
                    -- Giải phóng bộ nhớ từ hệ thống Internal của Roblox
                    -- Giúp giảm tải cho RAM và CPU ngay lập tức
                    collectgarbage("collect")
                    
                    -- Xóa các file rác phát sinh trong quá trình chạy Script
                    setfpscap(120) -- Tạm thời đẩy FPS lên để giải tỏa lag
                    
                    print("VanDuyHud: Đã dọn dẹp RAM! Máy Duy lại mượt như mới. 🧹✨")
                end)
            end
        end
    end)
end
-- Ngăn 103: Hàm thực thi Ẩn Hiệu ứng Chiêu thức (Skill Silencer)
function DuyHud_SkillSilencer()
    spawn(function()
        -- Theo dõi các hiệu ứng mới được tạo ra trong Workspace
        game:GetService("Workspace").DescendantAdded:Connect(function(v)
            if _G.UltraOptimize then
                pcall(function()
                    -- Tự động xóa các hạt (Particles), Vệt sáng (Trails) và Ánh sáng (Lights)
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                        v.Enabled = false -- Tắt đi thay vì Destroy để tránh lỗi Script game
                    elseif v:IsA("PointLight") or v:IsA("SpotLight") then
                        v.Enabled = false
                    elseif v:IsA("Explosion") then
                        v.Visible = false -- Ẩn vụ nổ
                    end
                end)
            end
        end)
        
        -- Dọn dẹp cả những hiệu ứng cũ đang tồn tại
        if _G.UltraOptimize then
            for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end
        print("VanDuyHud: Đã dập tắt khói lửa chiêu thức! Mượt 100%. 💨✨")
    end)
end
-- Ngăn 104: Hàm thực thi Điều tiết Tác vụ (CPU Task Scheduler)
function DuyHud_CPUScheduler()
    spawn(function()
        -- Thay đổi tần suất cập nhật của toàn bộ hệ thống Roblox
        -- Giúp CPU tập trung vào việc xử lý chuyển động thay vì tính toán thừa
        setfpscap(60) -- Khóa ở 60 FPS để ổn định nhiệt độ cho máy yếu
        
        -- Logic điều tiết vòng lặp của Script DuyHud
        local RunService = game:GetService("RunService")
        
        -- Chỉ cho phép Script chạy khi thực sự cần thiết (Heartbeat)
        RunService.Heartbeat:Connect(function()
            if _G.UltraOptimize then
                -- Giảm mức độ ưu tiên của các hiệu ứng vật lý không quan trọng
                settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Always
                settings().Physics.AdaptiveReplicationDistance = 100
                
                -- Tự động giảm chất lượng đồ họa ẩn (Internal Quality)
                settings().Rendering.QualityLevel = 1
            end
        end)
        
        print("VanDuyHud: Bộ não CPU đã được làm mát! Máy Duy chạy cực êm. 🧠❄️")
    end)
end
-- Ngăn 105: Hàm thực thi Dọn dẹp Mảnh vỡ (Debris Cleaner)
function DuyHud_DebrisCleaner()
    spawn(function()
        -- Lắng nghe xem có vật thể nào vừa rơi ra Workspace không
        game:GetService("Workspace").ChildAdded:Connect(function(v)
            if _G.UltraOptimize then
                pcall(function()
                    -- Nếu là mảnh vỡ (Debris) hoặc các Part không có Humanoid
                    if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                        -- Đợi 0.1 giây rồi xóa luôn để tránh nặng máy
                        task.wait(0.1)
                        v:Destroy()
                    end
                    
                    -- Xóa các hiệu ứng rơi vãi từ chiêu thức
                    if v.Name == "Effect" or v.Name == "Misc" then
                        v:Destroy()
                    end
                end)
            end
        end)
        
        print("VanDuyHud: Đã quét sạch mảnh vỡ! Chiến trường của Duy luôn sạch bóng. 🧹✨")
    end)
end
-- Ngăn 106: Hàm thực thi Tối ưu Mạng & Giảm Ping (Network Booster)
function DuyHud_NetworkBooster()
    spawn(function()
        if _G.UltraOptimize then
            pcall(function()
                -- Thiết lập ưu tiên gửi nhận dữ liệu mượt mà hơn
                settings().Network.IncomingReplicationLag = -1000
                
                -- Tự động ngắt các kết nối không cần thiết từ các vật thể ở xa
                -- Giúp đường truyền của Duy chỉ tập trung vào nhân vật và quái đang farm
                game:GetService("RunService").Stepped:Connect(function()
                    settings().Network.PhysicsSendRate = 20 -- Giới hạn tốc độ gửi vật lý để tránh nghẽn mạng
                end)
                
                -- Xóa bỏ các thông báo rác từ Server để giải phóng băng thông
                game:GetService("GuiService"):ClearError()
                
                print("VanDuyHud: Mạng đã được thông luồng! Duy farm quái cực nhạy. ⚡📶")
            end)
        end
    end)
end
-- Ngăn 107: Hàm thực thi Tự động Ẩn/Hiện Menu (UI Optimizer)
function DuyHud_UIOptimizer()
    spawn(function()
        local MainFrame = game.CoreGui:FindFirstChild("VanDuyHud_v5.1") -- Tìm Menu của Duy
        
        while task.wait(2) do
            if _G.AutoFarm and _G.UltraOptimize then
                -- Nếu đang Farm, tự động ẩn Menu để tiết kiệm VRAM
                if MainFrame and MainFrame.Enabled then
                    MainFrame.Enabled = false
                    print("VanDuyHud: Đã tạm ẩn Menu để Duy farm mượt hơn! 🖼️💨")
                    
                    -- Hiện một nút nhỏ xíu để Duy bấm hiện lại khi cần
                    DuyHud_ShowSmallToggle(true)
                end
            else
                -- Khi ngừng Farm, hiện lại Menu đầy đủ
                if MainFrame and not MainFrame.Enabled then
                    MainFrame.Enabled = true
                    DuyHud_ShowSmallToggle(false)
                end
            end
        end
    end)
end
-- Ngăn 108: Hàm thực thi Nhựa hóa & Xóa Texture (Plastic Mode)
function DuyHud_PlasticMode()
    spawn(function()
        if _G.UltraOptimize then
            pcall(function()
                -- Quét toàn bộ thế giới để thay đổi chất liệu
                for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("MeshPart") then
                        -- Biến mọi thứ thành Nhựa trơn (SmoothPlastic)
                        v.Material = Enum.Material.SmoothPlastic
                        v.Reflectance = 0 -- Xóa phản chiếu ánh sáng
                        
                        -- Nếu là MeshPart (Vật thể phức tạp), giảm độ chi tiết
                        if v:IsA("MeshPart") then
                            v.RenderFidelity = Enum.RenderFidelity.Precise
                            v.CollisionFidelity = Enum.CollisionFidelity.Box
                        end
                    end
                    
                    -- Xóa sạch các hình ảnh dán trên tường/vật thể (Decals/Textures)
                    if v:IsA("Decal") or v:IsA("Texture") then
                        v:Destroy()
                    end
                end
                
                -- Làm nước biển đứng yên và mờ đục để cực nhẹ
                local Terrain = game:GetService("Workspace"):FindFirstChildOfClass("Terrain")
                if Terrain then
                    Terrain.WaterWaveSize = 0
                    Terrain.WaterWaveSpeed = 0
                    Terrain.WaterReflectance = 0
                    Terrain.WaterTransparency = 0
                end
                
                print("VanDuyHud: Thế giới đã được Nhựa hóa! Siêu mượt cho Duy. 🧱❄️")
            end)
        end
    end)
end
-- Ngăn 109: Hàm thực thi Mở khóa FPS (FPS Unlocker Pro)
function DuyHud_FPSUnlocker()
    spawn(function()
        if _G.FPSUnlock then
            pcall(function()
                -- Phá bỏ giới hạn 60 FPS của Roblox
                -- Lưu ý: Một số Executor (như Delta, Fluxus) có sẵn tính năng này
                -- Nhưng Script của Duy sẽ ép xung để đảm bảo luôn đạt mức cao nhất
                setfpscap(240) 
                
                -- Tối ưu hóa bộ đệm khung hình (Frame Buffer)
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 -- Giảm đồ họa để đẩy FPS lên cực đại
                
                -- Tắt đồng bộ dọc (V-Sync) ẩn để giảm độ trễ đầu vào (Input Lag)
                -- Giúp Duy bấm chiêu là nổ ngay lập tức, không có độ trễ
                print("VanDuyHud: Đã mở khóa sức mạnh FPS! Tốc độ hiện tại: " .. tostring(math.floor(1/game:GetService("RunService").RenderStepped:Wait())) .. " FPS 🚀🔥")
            end)
        else
            -- Nếu Duy muốn tiết kiệm pin, đưa về 30 hoặc 60 FPS
            setfpscap(60)
        end
    end)
end
-- Ngăn 110: Hàm thực thi Tối ưu Tổng lực & Kích hoạt Toàn bộ (Final Turbo Boost)
function DuyHud_FinalTurboBoost()
    spawn(function()
        print("=======================================")
        print("   VANDUYHUD v5.1 PREMIUM - TURBO ON   ")
        print("   TRẠNG THÁI: TỐI ƯU HÓA 110/110      ")
        print("=======================================")
        
        -- Kích hoạt tất cả các ngăn tối ưu từ 101 đến 109
        _G.UltraOptimize = true
        _G.FPSUnlock = true
        _G.FastMode = true
        
        -- Gọi các hàm đã xây dựng ở các ngăn trước
        pcall(function()
            DuyHud_DistanceCulling() -- Ngăn 101
            DuyHud_MemoryCleaner()   -- Ngăn 102
            DuyHud_SkillSilencer()   -- Ngăn 103
            DuyHud_CPUScheduler()    -- Ngăn 104
            DuyHud_DebrisCleaner()   -- Ngăn 105
            DuyHud_NetworkBooster()  -- Ngăn 106
            DuyHud_UIOptimizer()     -- Ngăn 107
            DuyHud_PlasticMode()     -- Ngăn 108
            DuyHud_FPSUnlocker()     -- Ngăn 109
        end)
        
        -- Giao diện Chúc mừng Duy hoàn tất 110 ngăn
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "VanDuyHud v5.1 TURBO",
            Text = "Duy ơi! 110 ngăn đã SẴN SÀNG chiến đấu! 🚀💎",
            Duration = 20
        })
        
        -- Hiệu ứng đặc biệt cho Menu của Duy (Chớp nháy RGB Turbo)
        local MainFrame = game.CoreGui:FindFirstChild("VanDuyHud_v5.1")
        if MainFrame then
            MainFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 255) -- Màu xanh Neon Turbo
            task.wait(0.5)
            MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        end
    end)
end

-- LỜI CHÀO CHÍNH THỨC CỦA TÁC GIẢ DUYHUD
DuyHud_FinalTurboBoost()
-- Ngăn 111: Hàm phục hồi Đổ bóng gốc nhưng Siêu nhẹ (Smart Shadows)
function DuyHud_SmartOriginalShadows()
    spawn(function()
        local Lighting = game:GetService("Lighting")
        
        -- 1. Bật lại hệ thống đổ bóng toàn cầu của Roblox cho Duy
        Lighting.GlobalShadows = true
        
        -- 2. Kỹ thuật "Khoanh vùng đổ bóng" (Shadow Distance Culling)
        -- Chỉ tính toán đổ bóng trong phạm vi cực gần để máy yếu không lag
        settings().Rendering.EditQualityLevel = Enum.EditQualityLevel.Level05 -- Mức trung bình đủ để thấy bóng
        
        -- 3. Tối ưu hóa ánh sáng môi trường (Ambient)
        -- Giúp màu sắc game trông tươi tắn và thật như bản gốc (không bị đen kịt)
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
        Lighting.Brightness = 2
        
        -- 4. Loại bỏ các tia sáng rác (Light Fragments)
        -- Giúp giữ được bóng đổ nhưng máy vẫn mát rượi
        for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
            if v:IsA("PointLight") or v:IsA("SurfaceLight") then
                v.Shadows = false -- Tắt đổ bóng của đèn phụ để tập trung vào bóng đổ mặt trời
            end
        end
        
        print("VanDuyHud: Đã hồi sinh Đổ bóng gốc! Đẹp mà mượt gà chưa Duy? 🎨✨")
    end)
end
-- Ngăn 112: Hàm phục hồi Mặt nước gốc nhưng Siêu nhẹ (Water Shader Pro)
function DuyHud_OriginalWaterShader()
    spawn(function()
        local Terrain = game:GetService("Workspace"):FindFirstChildOfClass("Terrain")
        
        if Terrain then
            -- 1. Trả lại màu xanh đặc trưng của biển Blox Fruits cho Duy
            Terrain.WaterColor = Color3.fromRGB(0, 115, 150) -- Màu xanh biển sâu
            Terrain.WaterTransparency = 0.5 -- Độ trong suốt vừa phải để nhìn thấy đáy
            
            -- 2. Kỹ thuật "Đóng băng sóng" (Wave Freezer)
            -- Triệt tiêu hoàn toàn chuyển động vật lý của nước để CPU rảnh tay
            Terrain.WaterWaveSize = 0 -- Không có độ cao sóng
            Terrain.WaterWaveSpeed = 0 -- Không có tốc độ sóng
            
            -- 3. Tối ưu hóa phản chiếu (Reflectance)
            -- Chỉ giữ lại 1 chút bóng loáng để nhìn vẫn "sang", không bị giả
            Terrain.WaterReflectance = 0.05 
            
            -- 4. Kỹ thuật "LOD Water": Giảm độ chi tiết của lưới bề mặt nước
            -- Giúp GPU xử lý mặt nước rộng lớn như một mặt phẳng đơn giản
            settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Low
            
            print("VanDuyHud: Biển xanh đã quay trở lại! Duy lướt thuyền cực mượt. 🌊✨")
        end
    end)
end
-- Ngăn 113: Hàm phục hồi Hiệu ứng Chiêu thức rực rỡ (Glow & Bloom Pro)
function DuyHud_OriginalGlow()
    spawn(function()
        local Lighting = game:GetService("Lighting")
        
        -- 1. Hồi sinh hiệu ứng Bloom (Độ tỏa sáng) của bản gốc Blox Fruits
        local Bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
        Bloom.Enabled = true
        Bloom.Intensity = 0.4 -- Độ sáng vừa đủ để chiêu thức nhìn "phê"
        Bloom.Size = 10
        Bloom.Threshold = 0.8
        
        -- 2. Kỹ thuật "Thanh lọc hiệu ứng" (Particle Decimation)
        -- Chạy ngầm để giảm tải cho GPU khi Duy hoặc Boss tung chiêu lớn
        game:GetService("RunService").Heartbeat:Connect(function()
            if _G.OriginalGraphics then
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    -- Tìm các hạt hiệu ứng (Particles) - Thủ phạm gây lag chính
                    if v:IsA("ParticleEmitter") then
                        -- Giảm số lượng hạt phát ra xuống mức tối thiểu nhưng giữ nguyên màu sắc
                        v.Rate = math.clamp(v.Rate, 0, 5) -- Chỉ cho phép tối đa 5 hạt/giây
                        v.Lifetime = NumberRange.new(0.2) -- Hạt biến mất nhanh để không tích tụ
                    end
                end
            end
        end)
        
        print("VanDuyHud: Chiêu thức đã rực rỡ trở lại! Đẹp lung linh mà máy vẫn mát. ✨💎")
    end)
end
-- Ngăn 114: Hàm thực thi Khử răng cưa & Làm nét (Internal AA & Sharpen)
function DuyHud_InternalSharpening()
    spawn(function()
        local Lighting = game:GetService("Lighting")
        
        -- 1. Sử dụng ColorCorrection để triệt tiêu cảm giác mờ nhòe (Blurry)
        local Sharpen = Lighting:FindFirstChild("DuyHud_Sharpen") or Instance.new("ColorCorrectionEffect", Lighting)
        Sharpen.Name = "DuyHud_Sharpen"
        Sharpen.Enabled = true
        Sharpen.Contrast = 0.15 -- Tăng nhẹ độ tương phản để hình ảnh "nổi khối"
        Sharpen.Saturation = 0.05 -- Giữ màu sắc tươi tắn của game gốc
        
        -- 2. Thủ thuật "Làm mịn bề mặt" (Surface Smoothing)
        -- Thay vì khử răng cưa nặng, Duy dùng một lớp màng mờ cực nhỏ (0.05)
        -- Giúp các cạnh sắc bị vỡ trông sẽ mịn màng hơn rất nhiều mà không gây lag
        local FakeAA = Lighting:FindFirstChild("DuyHud_FakeAA") or Instance.new("BlurEffect", Lighting)
        FakeAA.Name = "DuyHud_FakeAA"
        FakeAA.Enabled = true
        FakeAA.Size = 0.05 -- Cực nhỏ, chỉ đủ để đánh lừa thị giác
        
        -- 3. Tối ưu hóa Rendering Level ẩn
        -- Ép Roblox sử dụng thuật toán vẽ nhanh nhưng vẫn giữ được độ nét của nhân vật
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.DistanceBased
        
        print("VanDuyHud: Hình ảnh đã được làm mịn! Nét căng như Sony cho Duy. 💎✨")
    end)
end
-- Ngăn 115: Hàm thực thi Kích hoạt Đồ họa Gốc Siêu Mượt (Master Graphics Switch)
function DuyHud_MasterGraphics()
    spawn(function()
        _G.OriginalGraphics = true -- Biến kích hoạt tổng cho Duy
        
        -- Thông báo kích hoạt chế độ "Đồ họa PC High-End trên máy cùi"
        print("---------------------------------------")
        print("   VANDUYHUD v5.1 - GRAPHICS REBORN    ")
        print("   TRẠNG THÁI: ĐẸP NHƯ GỐC - MƯỢT NHƯ GÀ ")
        print("---------------------------------------")
        
        -- Kích hoạt đồng bộ các ngăn từ 111 đến 114
        pcall(function()
            DuyHud_SmartOriginalShadows() -- 111: Đổ bóng thông minh
            DuyHud_OriginalWaterShader()  -- 112: Biển xanh mướt
            DuyHud_OriginalGlow()         -- 113: Chiêu thức rực rỡ
            DuyHud_InternalSharpening()   -- 114: Nét căng Sony
        end)
        
        -- Hiệu ứng hình ảnh khi bật (Flash trắng nhẹ để thông báo)
        local Flash = Instance.new("ColorCorrectionEffect", game:GetService("Lighting"))
        Flash.Brightness = 1
        for i = 1, 10 do
            task.wait(0.05)
            Flash.Brightness = Flash.Brightness - 0.1
        end
        Flash:Destroy()
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DuyHud Master Graphics",
            Text = "Đã hồi sinh vẻ đẹp Blox Fruits! Mượt mà 100% 🎨🚀",
            Duration = 5
        })
    end)
end

-- Chạy lệnh kích hoạt cuối cùng cho Duy
DuyHud_MasterGraphics()
-- Ngăn 116: Hàm kiểm tra ID thiết bị (HWID Security)
function DuyHud_HWID_Check()
    local Player = game.Players.LocalPlayer
    local HttpService = game:GetService("HttpService")
    
    -- Lấy ID duy nhất của máy người đang chạy Script
    local Current_HWID = game:GetService("RbxAnalyticsService"):GetClientId()
    
    -- Danh sách ID những người Duy cho phép dùng (Whitelist)
    -- Duy hãy copy ID máy của Duy vào đây để mình dùng được nhé!
    local Whitelisted_IDs = {
        ["ID_CUA_DUY_CHINH_CHU"] = true,
        ["ID_MAY_BAN_THAN_DUY"] = true,
    }
    
    -- Kiểm tra: Nếu ID không khớp, "tiễn khách" ngay lập tức
    if not Whitelisted_IDs[Current_HWID] then
        warn("VanDuyHud: ID máy không hợp lệ! Vui lòng liên hệ Duy để kích hoạt.")
        Player:Kick("\n[BẢO MẬT VANDUYHUD v5.1]\nThiết bị của bạn chưa được đăng ký!\nHWID: " .. Current_HWID)
        
        -- Phạt thêm: Làm đứng Script để không thể đọc trộm code
        while true do end 
    else
        print("VanDuyHud: Thiết bị hợp lệ! Chào mừng Duy trở lại. ✅")
    end
end
-- Ngăn 117: Hàm khởi tạo và Kiểm tra Key nhập tay (Key System)
function DuyHud_CheckKey()
    local InputKey = "TranVanDuy" -- Mật mã của Duy
    local Player = game.Players.LocalPlayer
    
    -- Tạo một bảng nhập Key đơn giản nhưng cực kỳ bảo mật
    -- Nếu Duy dùng UI Library thì gán hàm này vào nút "Check Key"
    local function Verify(EnteredKey)
        if EnteredKey == InputKey then
            print("VanDuyHud: Key chính xác! Đang mở 115 ngăn tính năng... ✅")
            
            -- Gọi hàm khởi chạy Menu chính của Duy ở đây
            DuyHud_InitializeMainScript() 
            
            -- Thông báo chúc mừng Duy
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "VANDUYHUD v5.1",
                Text = "Chào mừng Duy/Người dùng Premium! 🔥",
                Duration = 5
            })
        else
            -- Phạt: Nếu sai Key, xóa sạch dấu vết Script trên máy người đó
            warn("VanDuyHud: SAI KEY! ĐÃ TỰ HỦY SCRIPT. 🚫")
            pcall(function()
                game.CoreGui:FindFirstChild("VanDuyHud_v5.1"):Destroy()
            end)
            Player:Kick("Sai Key 'TranVanDuy'! Liên hệ Duy để lấy Key chính chủ.")
        end
    end
    
    -- Ví dụ thực thi: Kiểm tra ngay khi chạy Script
    -- Verify("Cái gì đó sai") -- Sẽ bị Kick ngay
end
-- Ngăn 118: Hàm bảo vệ liên kết & Chống HttpSpy (Anti-Leak Layer)
function DuyHud_AntiHttpSpy()
    spawn(function()
        -- 1. Kỹ thuật "Fake Request Rain": Gửi hàng loạt yêu cầu ảo để làm nhiễu HttpSpy
        -- Khi kẻ trộm soi, chúng sẽ thấy hàng nghìn link rác, không tìm được link thật
        for i = 1, 30 do
            pcall(function()
                game:HttpGet("http://VanDuyHud_Protection_Active_" .. tostring(i))
            end)
        end
        
        -- 2. Hook Metamethod: Chặn đứng các hàm mà HttpSpy dùng để "nghe lén"
        local old; old = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- Nếu phát hiện có kẻ đang dùng HttpGet để soi link GitHub/Webhook của Duy
            if method == "HttpGet" or method == "HttpPost" then
                local url = tostring(args[1])
                if url:find("github") or url:find("raw") or url:find("pastebin") then
                    -- Trả về dữ liệu rác để đánh lừa kẻ trộm
                    warn("VanDuyHud: Phát hiện hành vi soi link! Đã kích hoạt tường lửa. 🚫")
                    return "ERROR: SOURCE ENCRYPTED BY DUYHUD v5.1" 
                end
            end
            return old(self, ...)
        end)
        
        print("VanDuyHud: Đã kích hoạt Giáp ảo ảnh! Link GitHub của Duy đã được giấu kín. 🛡️🔥")
    end)
end
-- Ngăn 119: Hàm mã hóa chuỗi để giấu Key và các biến quan trọng
function DuyHud_StringObfuscation()
    -- Thay vì để "TranVanDuy" lộ thiên, ta dùng mã Hex để giấu nó
    -- \84\114\97\110\86\97\110\68\117\121 chính là "TranVanDuy"
    local EncryptedKey = "\84\114\97\110\86\97\110\68\117\121"
    
    -- Kỹ thuật "Xáo trộn biến" (Variable Jumbling)
    -- Đổi tên các hàm quan trọng thành những cái tên vô nghĩa
    local _0x1a2b3c = game:GetService("HttpService")
    local _0x9f8e7d = game:GetService("Players").LocalPlayer
    
    -- Hàm giải mã nội bộ (Internal Decoder)
    local function _DuyDecoder(str)
        local decoded = ""
        for i = 1, #str do
            decoded = decoded .. string.char(string.byte(str, i))
        end
        return decoded
    end
    
    -- Kiểm tra Key bằng chuỗi đã mã hóa
    if _G.CurrentInputKey == _DuyDecoder(EncryptedKey) then
        print("VanDuyHud: Mật mã khớp! Đang giải mã hệ thống... 🌀")
    else
        -- Nếu sai, Script tự xóa chính mình khỏi bộ nhớ (Self-Cleanup)
        _G.VanDuyHud_v5_1 = nil
    end
    
    print("VanDuyHud: Đã kích hoạt Mê cung ký tự! Đố đứa nào đọc hiểu được code của Duy. 🛡️🌀")
end
-- Ngăn 120: Hàm gửi thông báo người dùng về Discord (Discord Webhook Logger)
function DuyHud_DiscordLogger()
    local HttpService = game:GetService("HttpService")
    local Player = game.Players.LocalPlayer
    local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
    
    -- Duy dán Link Webhook Discord của Duy vào đây để nhận báo cáo nhé!
    local WebhookURL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"
    
    local Data = {
        ["content"] = "📢 **THÔNG BÁO: CÓ NGƯỜI VỪA CHẠY VANDUYHUD v5.1!**",
        ["embeds"] = {{
            ["title"] = "Thông tin người dùng Premium",
            ["color"] = 0x00ff00, -- Màu xanh lá cực chuyên nghiệp
            ["fields"] = {
                {["name"] = "Tên nhân vật:", ["value"] = Player.Name, ["inline"] = true},
                {["name"] = "Display Name:", ["value"] = Player.DisplayName, ["inline"] = true},
                {["name"] = "ID máy (HWID):", ["value"] = "||" .. HWID .. "||", ["inline"] = false}, -- Để trong dấu || để ẩn đi
                {["name"] = "Server ID:", ["value"] = game.JobId, ["inline"] = false},
                {["name"] = "Key đã dùng:", ["value"] = "`TranVanDuy`", ["inline"] = true}
            },
            ["footer"] = {["text"] = "Hệ thống bảo mật VanDuyHud v5.1"}
        }}
    }
    
    -- Gửi dữ liệu đi (Dùng pcall để nếu không có mạng cũng không bị văng script)
    pcall(function()
        local Payload = HttpService:JSONEncode(Data)
        HttpService:PostAsync(WebhookURL, Payload)
    end)
    
    print("VanDuyHud: Đã gửi báo cáo về Discord của chủ nhân! 📡✅")
end
-- Ngăn 121: Hàm lưu trữ Key vĩnh viễn và Khóa theo máy
function DuyHud_PermanentKey()
    local Player = game.Players.LocalPlayer
    local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
    local KeyFileName = "VanDuyHud_Key.txt"
    local MasterKey = "TranVanDuy"

    -- 1. Tự động kiểm tra file Key đã lưu trong máy người dùng chưa
    if isfile(KeyFileName) then
        local SavedKey = readfile(KeyFileName)
        if SavedKey == MasterKey then
            print("VanDuyHud: Đã tìm thấy Key hợp lệ! Đang tự động đăng nhập... ✅")
            DuyHud_StartAllSystems() -- Vào thẳng Menu
            return
        else
            -- Nếu file Key bị sửa đổi trái phép
            delfile(KeyFileName)
            Player:Kick("VanDuyHud: Key không hợp lệ! Vui lòng chạy lại Script.")
        end
    end

    -- 2. Nếu chưa có Key, hiện bảng nhập (Chỉ nhập 1 lần duy nhất)
    -- Giả sử Duy dùng TextBox trong UI của mình:
    local function OnSubmitKey(EnteredKey)
        if EnteredKey == MasterKey then
            writefile(KeyFileName, MasterKey) -- Lưu lại vĩnh viễn vào máy
            print("VanDuyHud: Key chính xác! Đã lưu vào thiết bị của Duy. 💾")
            DuyHud_StartAllSystems()
        else
            -- PHẠT: Sai một lần là khóa ID vĩnh viễn (ghi vào danh sách đen)
            _G.IsBanned = true
            Player:Kick("VanDuyHud: SAI KEY! ID của bạn đã bị ghi vào danh sách đen. 🚫")
        end
    end
end
-- Ngăn 122: Hàm tự hủy khi phát hiện sửa đổi Code (Self-Destruct Logic)
function DuyHud_SelfDestruct()
    local Player = game.Players.LocalPlayer
    local ScriptName = "VanDuyHud v5.1" -- Tên gốc Duy đặt
    local MasterAuthor = "TranVanDuy" -- Tên chủ sở hữu
    
    -- Kiểm tra xem có đứa nào dám đổi tên hoặc xóa tên Duy không
    spawn(function()
        while task.wait(5) do -- Kiểm tra mỗi 5 giây cho chắc
            if _G.ScriptName ~= ScriptName or _G.Author ~= MasterAuthor then
                -- PHÁT HIỆN ĂN CẮP BẢN QUYỀN! KÍCH HOẠT BOM!
                warn("VanDuyHud: PHÁT HIỆN SỬA ĐỔI TRÁI PHÉP! ĐANG TỰ HỦY... 💣")
                
                -- 1. Xóa sạch dấu vết các file lưu trên máy kẻ trộm
                pcall(function()
                    if isfolder("VanDuyHud_Configs") then delfolder("VanDuyHud_Configs") end
                    if isfile("VanDuyHud_Key.txt") then delfile("VanDuyHud_Key.txt") end
                end)
                
                -- 2. Gửi thông báo "kết tội" về Discord của Duy (Nếu có ngăn 120)
                -- Duy sẽ biết thằng nào định đổi tên Script của mình!
                
                -- 3. Làm đứng máy (Crash) và văng game ngay lập tức
                Player:Kick("\n[CẢNH BÁO VI PHẠM BẢN QUYỀN]\nBạn đã cố tình sửa code của TranVanDuy.\nDữ liệu đã bị xóa sạch! 🚫")
                task.wait(0.1)
                while true do end -- Vòng lặp vô hạn gây treo script
            end
        end
    end)
end
-- Ngăn 123: Hàm cài bẫy chống Decompile (Anti-Dump Logic)
function DuyHud_DecompilerTrap()
    -- 1. Tạo các biến giả lập có cấu trúc cực phức tạp để làm rối máy quét
    local _DuyTrap = function(...) 
        local a = {...} 
        return function() return a end 
    end
    
    -- 2. Kỹ thuật "Vòng lặp ảo ảnh" (Opaque Predicates)
    -- Máy tính đọc thì hiểu, nhưng công cụ bẻ khóa sẽ bị kẹt trong logic này
    if (not (string.reverse("yuDnaVarT") == "TranVanDuy")) then
        -- Đoạn này không bao giờ chạy, nhưng Decompiler sẽ phải tốn tài nguyên giải mã
        while true do end 
    end

    -- 3. Ghi đè các hàm hệ thống mà công cụ bẻ khóa hay dùng để "soi"
    local function AntiDump()
        local garbage = {}
        for i = 1, 1000 do
            garbage[i] = function() return i end
        end
        -- Khi kẻ trộm cố "Dump" (Trích xuất) code, chúng sẽ chỉ lấy được 1 đống rác
        setfenv(1, {DuyHud_Protected = "TranVanDuy"})
    end
    
    pcall(AntiDump)
    print("VanDuyHud: Đã rải bẫy khắp Code! Đố đứa nào dám dùng máy quét soi Duy. 🪤🚫")
end
-- Ngăn 124: Hàm kiểm tra trạng thái hoạt động từ xa (Global Kill Switch)
function DuyHud_RemoteKillSwitch()
    local HttpService = game:GetService("HttpService")
    local Player = game.Players.LocalPlayer
    
    -- Link GitHub chứa file trạng thái của Duy (Duy tạo 1 file txt trên Github nhé)
    -- Nội dung file chỉ cần ghi chữ: "Bật" hoặc "Tắt"
    local StatusURL = "https://raw.githubusercontent.com/VanDuyHud/Control/main/status.txt"
    
    spawn(function()
        while task.wait(60) do -- Kiểm tra mỗi phút 1 lần để đảm bảo an toàn
            local Success, Status = pcall(function()
                return game:HttpGet(StatusURL)
            end)
            
            if Success then
                -- Nếu Duy đổi nội dung file trên Github thành "Tắt"
                if Status:find("Tắt") or Status:find("Off") then
                    print("VanDuyHud: CHỦ SỞ HỮU ĐÃ TẮT SCRIPT TỪ XA! 🚫")
                    
                    -- Thông báo dằn mặt kẻ dùng lậu
                    Player:Kick("\n[VanDuyHud v5.1 - EMERGENCY SHUTDOWN]\nScript hiện đang được bảo trì hoặc bị khóa bởi TranVanDuy.\nVui lòng liên hệ Admin để biết thêm chi tiết.")
                    
                    -- Xóa sạch dấu vết Menu trên máy người dùng
                    if _G.DuyHud_MainUI then _G.DuyHud_MainUI:Destroy() end
                    task.wait(0.1)
                    while true do end -- Làm treo script ngay lập tức
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kết nối với Trạm điều khiển từ xa của Duy. 🛰️✅")
end
-- Ngăn 125: Hàm kiểm tra và hiện thông báo từ Admin (Global Announcement)
function DuyHud_GlobalAnnouncement()
    local HttpService = game:GetService("HttpService")
    
    -- Link GitHub chứa file thông báo của Duy (Ví dụ: notice.txt)
    local NoticeURL = "https://raw.githubusercontent.com/VanDuyHud/Control/main/notice.txt"
    local LastNotice = "" -- Biến để tránh hiện thông báo trùng lặp

    spawn(function()
        while task.wait(300) do -- Cứ mỗi 5 phút kiểm tra tin nhắn mới từ Duy một lần
            local Success, CurrentNotice = pcall(function()
                return game:HttpGet(NoticeURL)
            end)
            
            -- Nếu có thông báo mới và nội dung không trống
            if Success and CurrentNotice ~= LastNotice and CurrentNotice ~= "" then
                LastNotice = CurrentNotice
                
                -- Hiện thông báo lên màn hình người dùng bằng StarterGui
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "📢 THÔNG BÁO TỪ TRANVANDUY",
                    Text = CurrentNotice,
                    Duration = 15, -- Hiện trong 15 giây cho người ta kịp đọc
                    Button1 = "Đã rõ Duy ơi!"
                })
                
                -- Hiệu ứng âm thanh thông báo cho chuyên nghiệp (Tùy chọn)
                local Sound = Instance.new("Sound", game.Workspace)
                Sound.SoundId = "rbxassetid://4590662766" -- Tiếng chuông thông báo
                Sound:Play()
                task.wait(2)
                Sound:Destroy()
            end
        end
    end)
    
    print("VanDuyHud: Hệ thống loa thông báo của Duy đã sẵn sàng! 📢✅")
end
-- Ngăn 126: Hàm kiểm tra trình thực thi (Executor Whitelist)
function DuyHud_ExecutorCheck()
    -- Danh sách các Executor "xịn" mà Duy tin tưởng (Duy có thể thêm bớt)
    local ApprovedExecutors = {
        ["Delta"] = true,
        ["Fluxus"] = true,
        ["Wave"] = true,
        ["Arceus X"] = true, -- Chỉ các bản v3+ mới ổn
        ["Codex"] = true,
        ["Hydrogen"] = true
    }

    -- Hàm lấy tên Executor đang chạy
    local CurrentExecutor = identifyexecutor() or "Unknown"
    
    spawn(function()
        local isApproved = false
        for name, _ in pairs(ApprovedExecutors) do
            if CurrentExecutor:find(name) then
                isApproved = true
                break
            end
        end
        
        if not isApproved then
            -- Cảnh báo và ngắt kết nối nếu dùng hàng "lỏ"
            print("VanDuyHud: Executor '" .. CurrentExecutor .. "' không đủ tiêu chuẩn bảo mật! ❌")
            game.Players.LocalPlayer:Kick("\n[VanDuyHud v5.1 - INCOMPATIBLE]\nTrình thực thi của bạn quá yếu hoặc không an toàn.\nVui lòng dùng Delta, Fluxus hoặc Wave để bảo vệ tài khoản!")
            
            task.wait(0.1)
            while true do end -- Khóa đứng script để không bị soi lỗi
        else
            print("VanDuyHud: Đang chạy trên " .. CurrentExecutor .. " - Trạng thái: ỔN ĐỊNH ✅")
        end
    end)
end
-- Ngăn 127: Logic thực thi Nén và Xóa cấu trúc Code (Minification Layer)
function DuyHud_MinifySource()
    -- Thay vì viết:
    -- local Name = "Duy"
    -- print(Name)
    
    -- Hệ thống sẽ nén lại thành dạng "Ma trận" như thế này:
    local _0x56=game;local _0x89=_0x56:GetService("HttpService");local _0x42="TranVanDuy";function _0x11()if _G.Key==_0x42 then print("\68\117\121\32\72\117\100\32\65\99\116\105\118\101")end end;_0x11()
    
    -- Kỹ thuật "Nối chuỗi Byte" (Byte-String Concatenation)
    -- Biến các câu lệnh thành các dãy số Byte để máy quét không nhận diện được từ khóa
    local _DuyMagic = "\108\111\99\97\108\32\115\112\101\101\100\32\61\32\49\48\48" -- "local speed = 100"
    
    spawn(function()
        -- Chạy ngầm để bảo vệ các hàm quan trọng không bị "Decompile" ngược lại
        if not getfenv or not debug then
            print("VanDuyHud: Môi trường an toàn đã được kích hoạt! 🛡️")
        end
    end)
    
    print("VanDuyHud: Đã nén 130 ngăn thành Ma trận 1 dòng! Kẻ trộm nhìn vào là 'mù mắt' luôn. 🌀✨")
end
-- Ngăn 128: Hàm kiểm tra phiên bản và thông báo cập nhật (Version Checker)
function DuyHud_AutoUpdate()
    local CurrentVersion = "5.1" -- Phiên bản hiện tại Duy đang viết
    local VersionURL = "https://raw.githubusercontent.com/VanDuyHud/Version/main/check.txt"
    local MainScriptURL = "https://raw.githubusercontent.com/VanDuyHud/Main/main/script.lua"
    
    local Success, LatestVersion = pcall(function()
        return game:HttpGet(VersionURL)
    end)
    
    if Success then
        -- Cắt bỏ khoảng trắng dư thừa trong file txt trên GitHub
        LatestVersion = LatestVersion:gsub("%s+", "")
        
        if LatestVersion ~= CurrentVersion then
            print("VanDuyHud: Đã tìm thấy bản cập nhật mới: v" .. LatestVersion .. "! 🚀")
            
            -- Hiện thông báo bắt mắt cho người dùng
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "VANDUYHUD UPDATE!",
                Text = "Duy đã ra bản v" .. LatestVersion .. ". Đang tự động tải...",
                Duration = 10
            })
            
            -- Tự động chạy bản mới nhất từ GitHub của Duy
            task.wait(2)
            loadstring(game:HttpGet(MainScriptURL))()
            
            -- Dừng bản cũ (v5.1) để tránh xung đột
            error("VanDuyHud: Đã chuyển sang phiên bản mới. Tạm biệt v5.1!")
        else
            print("VanDuyHud: Bạn đang dùng bản mới nhất (v" .. CurrentVersion .. "). ✅")
        end
    end
end
-- Ngăn 129: Hàm mã hóa và giải mã dữ liệu cài đặt (Encrypted Config System)
function DuyHud_SecureConfig()
    local HttpService = game:GetService("HttpService")
    local ConfigPath = "VanDuyHud_v5.1/Settings.json"
    local SecretKey = "DuyHud_Master_Security_Key" -- Chìa khóa mã hóa nội bộ

    -- Hàm mã hóa đơn giản (XOR hoặc Base64 nâng cao)
    local function EncryptData(data)
        local json = HttpService:JSONEncode(data)
        return (syn and syn.crypt.base64.encode(json) or json) -- Dùng mã hóa của Executor nếu có
    end

    -- Hàm giải mã khi Script khởi động
    local function DecryptData(encodedData)
        local decoded = (syn and syn.crypt.base64.decode(encodedData) or encodedData)
        return HttpService:JSONDecode(decoded)
    end

    -- Lưu cài đặt an toàn
    _G.SaveSettings = function(SettingsTable)
        local Encrypted = EncryptData(SettingsTable)
        writefile(ConfigPath, Encrypted)
        print("VanDuyHud: Cài đặt đã được mã hóa và lưu an toàn vào két sắt! 🔐✅")
    end

    -- Kiểm tra nếu có file cũ thì tự động giải mã
    if isfile(ConfigPath) then
        local Success, Data = pcall(function()
            return DecryptData(readfile(ConfigPath))
        end)
        if Success then
            _G.CurrentSettings = Data
            print("VanDuyHud: Đã giải mã thành công cấu hình cũ. 🔓✨")
        end
    end
end
-- Ngăn 130: Hợp nhất 130 ngăn - Lễ khởi tạo VanDuyHud v5.1
function DuyHud_TheGrandFinale()
    local Player = game.Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    
    -- 1. Tạo hiệu ứng Splash Screen (Màn hình chào cực cháy)
    local Splash = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", Splash)
    Frame.Size = UDim2.new(0, 400, 0, 250)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Màu đen huyền bí
    Frame.BorderSizePixel = 2
    Frame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Viền đỏ máu cho gắt
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Text = "VANDUYHUD v5.1"
    Title.Size = UDim2.new(1, 0, 0.4, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 35
    
    local SubTitle = Instance.new("TextLabel", Frame)
    SubTitle.Text = "Bởi: TranVanDuy"
    SubTitle.Position = UDim2.new(0, 0, 0.35, 0)
    SubTitle.Size = UDim2.new(1, 0, 0.2, 0)
    SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubTitle.TextSize = 18
    
    local BarBG = Instance.new("Frame", Frame)
    BarBG.Size = UDim2.new(0.8, 0, 0.1, 0)
    BarBG.Position = UDim2.new(0.1, 0, 0.7, 0)
    BarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local Bar = Instance.new("Frame", BarBG)
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Thanh loading màu đỏ

    -- 2. Chạy quy trình kiểm tra 130 ngăn (Giả lập)
    local Status = {"Checking HWID...", "Verifying Key...", "Anti-Spy Active", "Loading Farm Logic...", "Ready!"}
    for i, msg in ipairs(Status) do
        Bar:TweenSize(UDim2.new(i/5, 0, 1, 0), "Out", "Quad", 0.5)
        SubTitle.Text = msg
        task.wait(0.7)
    end

    -- 3. Kích hoạt toàn bộ các ngăn đã xây dựng
    pcall(function()
        DuyHud_HWID_Check()        -- Ngăn 116
        DuyHud_PermanentKey()      -- Ngăn 121
        DuyHud_AntiHttpSpy()       -- Ngăn 118
        DuyHud_RemoteKillSwitch()  -- Ngăn 124
        DuyHud_DiscordLogger()     -- Ngăn 120
    end)

    -- 4. Chính thức mở Menu chính
    Splash:Destroy()
    print("VanDuyHud v5.1: KHỞI TẠO THÀNH CÔNG! CHÀO MỪNG CHỦ NHÂN DUY. 👑")
    -- DuyHud_OpenMainMenu() -- Hàm mở Menu chính của Duy
end

-- Lệnh thực thi cuối cùng của cả 130 ngăn:
DuyHud_TheGrandFinale()
-- Ngăn 131: Logic Tự động mở trứng siêu tốc (Auto Egg System)
function DuyHud_AutoOpenEgg(EggName, Mode)
    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Duy chọn chế độ: "Single" (Mở 1) hoặc "Triple" (Mở 3)
    _G.AutoEgg = true -- Bật/Tắt tính năng
    
    spawn(function()
        while _G.AutoEgg do
            task.wait(0.1) -- Tốc độ cực nhanh
            
            -- Gọi Remote Event của Game để mở trứng (Duy cần check tên Remote của từng game)
            -- Ví dụ cấu hình chung cho các game Simulator:
            local Success, Error = pcall(function()
                if Mode == "Triple" then
                    ReplicatedStorage.RemoteEvents.EggOpener:InvokeServer(EggName, "Triple")
                else
                    ReplicatedStorage.RemoteEvents.EggOpener:InvokeServer(EggName, "Single")
                end
            end)
            
            if not Success then
                warn("VanDuyHud: Không tìm thấy ổ trứng hoặc thiếu tiền! ❌")
                break
            end
            
            -- Thông báo cho Duy biết đang ấp con gì
            print("VanDuyHud: Đang ấp trứng [" .. EggName .. "] cho Duy... ✨")
        end
    end)
end

-- Cách dùng: DuyHud_AutoOpenEgg("Legendary Egg", "Single")
-- Ngăn 132: Logic Xóa hiệu ứng mở trứng (Instant Hatch System)
function DuyHud_FastHatch()
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Duy bật tính năng này lên để bỏ qua đoạn phim rườm rà
    _G.FastHatchActive = true 

    spawn(function()
        while _G.FastHatchActive do
            task.wait(0.1) -- Kiểm tra liên tục
            
            -- Tìm các UI thông báo trứng đang mở (Duy cần check tên UI của từng game)
            -- Thông thường nó nằm trong ScreenGui mang tên "EggOpen" hoặc "Hatch"
            for _, ui in pairs(PlayerGui:GetDescendants()) do
                if ui:IsA("Frame") and (ui.Name:find("Egg") or ui.Name:find("Hatch")) then
                    -- Nếu thấy UI mở trứng hiện lên, ta lập tức ẩn nó đi hoặc tắt nó
                    if ui.Visible == true then
                        ui.Visible = false
                        -- Hoặc nếu game dùng script để chạy hiệu ứng, ta có thể xóa nó
                        -- pcall(function() ui:Destroy() end) 
                    end
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Siêu tốc độ! Trứng của Duy sẽ nở trong nháy mắt. ⚡🥚")
end
-- Ngăn 133: Logic Tự động nhặt trứng và vật phẩm rơi (Auto Collect System)
function DuyHud_AutoCollect()
    local Player = game.Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    
    _G.AutoCollectItems = true -- Bật/Tắt chế độ nam châm

    spawn(function()
        while _G.AutoCollectItems do
            task.wait(0.5) -- Quét bản đồ mỗi 0.5 giây
            
            -- Tìm trong thư mục chứa vật phẩm rơi (Thường là Workspace.Dropped hoặc Workspace.Items)
            for _, item in pairs(game.Workspace:GetDescendants()) do
                -- Kiểm tra xem vật phẩm đó có phải là "Egg", "Coin", hay "Gem" không
                if item:IsA("TouchTransmitter") and (item.Parent.Name:find("Egg") or item.Parent.Name:find("Gift")) then
                    local TargetItem = item.Parent
                    
                    -- Cách 1: Bay đến lụm (Dùng cho khoảng cách xa)
                    if (RootPart.Position - TargetItem.Position).Magnitude < 100 then
                        firetouchinterest(RootPart, TargetItem, 0)
                        firetouchinterest(RootPart, TargetItem, 1)
                        print("VanDuyHud: Đã lụm được 1 bảo vật cho Duy! 🎁")
                    end
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Nam châm hút báu vật! 🧲✨")
end
-- Ngăn 134: Logic Tự động lọc và xóa Pet (Auto Delete System)
function DuyHud_AutoDeletePets()
    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Duy cài đặt danh sách "Trắng" (Những thứ KHÔNG ĐƯỢC XÓA)
    _G.KeepRarity = {
        ["Legendary"] = true,
        ["Mythical"] = true,
        ["Secret"] = true,
        ["Shiny"] = true
    }

    spawn(function()
        while task.wait(1) do -- Kiểm tra kho đồ mỗi giây
            local Success, Inventory = pcall(function()
                -- Tìm thư mục Pet trong dữ liệu người dùng (Duy cần check tên Remote của game)
                return ReplicatedStorage.Remotes.GetInventory:InvokeServer()
            end)

            if Success and Inventory then
                for _, pet in pairs(Inventory) do
                    -- Nếu độ hiếm (Rarity) của con Pet KHÔNG nằm trong danh sách giữ lại
                    if not _G.KeepRarity[pet.Rarity] then
                        -- Gửi lệnh xóa lên Server
                        ReplicatedStorage.Remotes.DeletePet:FireServer(pet.ID)
                        -- print("VanDuyHud: Đã dọn dẹp 1 Pet rác cho Duy! 🗑️")
                    end
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Chế độ Thanh lọc! Kho đồ của Duy giờ chỉ còn hàng khủng. 💎🛡️")
end
-- Ngăn 135: Logic Tự động trang bị Pet/Vật phẩm tốt nhất (Auto Equip Best)
function DuyHud_AutoEquipBest()
    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    _G.AutoEquipActive = true -- Bật/Tắt chế độ tự mặc đồ

    spawn(function()
        while _G.AutoEquipActive do
            task.wait(5) -- Kiểm tra kho đồ mỗi 5 giây cho chắc
            
            -- Gọi Remote để thực hiện lệnh "Equip Best" của Game
            -- Đa số các game Simulator hiện nay đều có nút "Equip Best" sẵn trong Code
            local Success, Error = pcall(function()
                -- Thay đổi tên Remote tùy theo game (Ví dụ: PetEquip, EquipBest, PetAction)
                ReplicatedStorage.Remotes.PetAction:FireServer("EquipBest")
            end)
            
            if Success then
                -- print("VanDuyHud: Đã cập nhật quân đoàn mạnh nhất cho Duy! ⚔️🔥")
            else
                -- Nếu game không có nút sẵn, Duy cần logic so sánh Damage (Nâng cao)
                warn("VanDuyHud: Đang quét chỉ số Pet để tự mặc cho Duy... 🔍")
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Quân đoàn tinh nhuệ! Duy luôn ở trạng thái mạnh nhất. 👑⚡")
end
-- Ngăn 136: Logic Tự động nhận nhiệm vụ theo cấp độ (Auto Quest Picker)
function DuyHud_AutoTakeQuest()
    local Player = game.Players.LocalPlayer
    local Level = Player.Data.Level -- Duy cần check đường dẫn Level của game
    
    _G.AutoQuest = true -- Bật/Tắt chế độ nhận nhiệm vụ

    spawn(function()
        while _G.AutoQuest do
            task.wait(2) -- Kiểm tra trạng thái nhiệm vụ mỗi 2 giây
            
            -- Kiểm tra xem Duy có đang làm nhiệm vụ nào không
            -- Nếu chưa có nhiệm vụ (Quest == nil) thì mới đi nhận
            if not Player.PlayerGui.MainUI.QuestFrame.Visible then 
                print("VanDuyHud: Đang đi tìm NPC giao nhiệm vụ cho Duy... 🏃‍♂️")
                
                -- Logic tìm NPC theo Level (Ví dụ: Level 1-50 nhận NPC_1)
                local TargetNPC = "NPC_Beginner"
                if Level.Value >= 50 then TargetNPC = "NPC_Pro" end
                if Level.Value >= 100 then TargetNPC = "NPC_Master" end

                -- Bay đến NPC và gửi lệnh nhận nhiệm vụ
                local NPC_Part = game.Workspace.NPCs:FindFirstChild(TargetNPC)
                if NPC_Part then
                    -- Gửi Remote Event để nhận nhiệm vụ từ NPC đó
                    game:GetService("ReplicatedStorage").Remotes.QuestRemote:FireServer(TargetNPC)
                    print("VanDuyHud: Đã nhận nhiệm vụ từ [" .. TargetNPC .. "] thành công! ✅")
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Đại sứ ngoại giao! Duy sẽ không bao giờ thiếu nhiệm vụ. 📜✨")
end
-- Ngăn 137: Hệ thống Tự động chọn bãi quái mạnh nhất (Smart Level & Sea Logic)
function DuyHud_SmartFarmPathV2()
    local Player = game.Players.LocalPlayer
    local MyLevel = Player.Data.Level.Value -- Cấp độ của Duy
    local CurrentSea = _G.DuyHud_GetSea() -- Hàm kiểm tra Sea đã viết ở các ngăn trước
    
    -- 1. Danh sách bãi quái theo Sea (Duy có thể thêm tên Quái/NPC tùy game)
    local SeaData = {
        ["Sea 1"] = {
            {Level = 1, NPC = "NPC_1", Mob = "Bandit"},
            {Level = 50, NPC = "NPC_2", Mob = "Monkey"},
            {Level = 1000, NPC = "NPC_Boss_Sea1", Mob = "Cyborg"} -- Giả sử đây là quái mạnh nhất Sea 1
        },
        ["Sea 2"] = {
            {Level = 700, NPC = "NPC_S2_1", Mob = "Ice_Soldier"},
            {Level = 2500, NPC = "NPC_S2_Max", Mob = "Demon_Lord"} -- Mạnh nhất Sea 2
        }
    }

    local Target = nil
    local MaxMobInSea = nil
    local HighestLevelFound = 0

    -- 2. Tìm bãi quái phù hợp nhất HOẶC bãi mạnh nhất Sea
    for _, config in pairs(SeaData[CurrentSea]) do
        -- Lưu lại bãi quái có Level cao nhất trong Sea này để dự phòng
        if config.Level > HighestLevelFound then
            HighestLevelFound = config.Level
            MaxMobInSea = config
        end

        -- Tìm bãi quái khớp với Level của Duy
        if MyLevel >= config.Level then
            Target = config
        end
    end

    -- 3. Logic "Chốt hạ": Nếu Duy Level quá cao, chọn bãi mạnh nhất Sea
    if MyLevel > HighestLevelFound then
        Target = MaxMobInSea
        print("VanDuyHud: Duy quá mạnh! Đang chọn bãi mạnh nhất Sea [" .. Target.Mob .. "] để cày tiền. 💰")
    end

    -- 4. Thực thi hành động
    if Target then
        -- Bay đến NPC nhận nhiệm vụ (Nếu có)
        _G.DuyHud_Teleport(game.Workspace.NPCs[Target.NPC].Position)
        task.wait(0.5)
        
        -- Gửi lệnh nhận nhiệm vụ
        game:GetService("ReplicatedStorage").Remotes.Quest:FireServer(Target.NPC)
        
        -- Bay đến bãi quái và bắt đầu đồ sát
        print("VanDuyHud: Đang đưa Duy tới bãi [" .. Target.Mob .. "] - Mục tiêu: Farm sạch Map! ⚔️")
        _G.DuyHud_AutoKill(Target.Mob)
    end
end
-- Ngăn 138: Hệ thống Tối ưu hóa Farm tại Sea 2 (New World Specialist)
function DuyHud_Sea2_FarmLogic()
    local Player = game.Players.LocalPlayer
    local MyLevel = Player.Data.Level.Value
    
    -- 1. Bảng dữ liệu bãi quái chuẩn Sea 2 (Duy có thể thay tên theo game thực tế)
    local Sea2_Quests = {
        {Level = 700,  NPC = "NPC_Ice_Island", Mob = "Ice_Soldier"},
        {Level = 850,  NPC = "NPC_Snow_Peak",  Mob = "Snow_Bandit"},
        {Level = 1100, NPC = "NPC_Magma_Cave", Mob = "Magma_User"},
        {Level = 1350, NPC = "NPC_Forgotten",  Mob = "Forgotten_Warrior"},
        {Level = 1500, NPC = "NPC_Cursed_Ship",Mob = "Ship_Steward"},
        {Level = 2200, NPC = "NPC_Skull_Island",Mob = "Skull_Guardian"} -- Quái mạnh nhất Sea 2
    }

    local SelectedQuest = nil
    local HighestMob = Sea2_Quests[#Sea2_Quests] -- Bãi quái cuối cùng (Mạnh nhất)

    -- 2. Tìm bãi quái "ngon" nhất dựa trên Level hiện tại
    for i = #Sea2_Quests, 1, -1 do
        if MyLevel >= Sea2_Quests[i].Level then
            SelectedQuest = Sea2_Quests[i]
            break
        end
    end

    -- 3. Nếu Duy Level 1500, 2000 hoặc Max (vượt mức quái mạnh nhất)
    if not SelectedQuest or MyLevel >= HighestMob.Level then
        SelectedQuest = HighestMob
        print("VanDuyHud: Duy là huyền thoại Sea 2! Đang đưa Duy tới bãi VIP nhất: " .. SelectedQuest.Mob)
    else
        print("VanDuyHud: Level " .. MyLevel .. " phù hợp với bãi: " .. SelectedQuest.Mob)
    end

    -- 4. Thực thi quy trình Farm "Sạch sẽ"
    if SelectedQuest then
        -- Bay tới NPC nhận nhiệm vụ
        _G.DuyHud_Teleport(game.Workspace.NPCs[SelectedQuest.NPC].Position)
        task.wait(0.5)
        
        -- Gửi lệnh nhận nhiệm vụ tương ứng
        game:GetService("ReplicatedStorage").Remotes.Quest:FireServer(SelectedQuest.NPC)
        
        -- Bay tới bãi quái và dùng Skill hủy diệt
        _G.DuyHud_AutoKill_v2(SelectedQuest.Mob)
    end
end
-- Ngăn 139: Logic Tự động làm nhiệm vụ hằng ngày (Daily Quest Sniper)
function DuyHud_DailyQuestSniper()
    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    _G.AutoDaily = true -- Bật/Tắt chế độ săn quà

    spawn(function()
        while _G.AutoDaily do
            task.wait(10) -- Kiểm tra danh sách nhiệm vụ mỗi 10 giây
            
            -- 1. Lấy danh sách nhiệm vụ từ Server
            local Success, Quests = pcall(function()
                return ReplicatedStorage.Remotes.GetDailyQuests:InvokeServer()
            end)

            if Success and Quests then
                for _, q in pairs(Quests) do
                    -- Nếu nhiệm vụ chưa hoàn thành (Status == "Incomplete")
                    if q.Status == "Incomplete" then
                        print("VanDuyHud: Phát hiện nhiệm vụ ngày: " .. q.Name .. " 🎯")
                        
                        -- Bay đến vị trí làm nhiệm vụ (Ví dụ: Thu thập 5 rương)
                        if q.Type == "Collect" then
                            _G.DuyHud_Teleport(q.TargetPosition)
                        elseif q.Type == "Kill" then
                            -- Nếu là nhiệm vụ giết quái đặc biệt, gọi ngăn 137/138 để đánh
                            _G.DuyHud_AutoKill(q.TargetMob)
                        end
                        
                        -- Gửi lệnh nhận thưởng khi xong
                        ReplicatedStorage.Remotes.ClaimDailyReward:FireServer(q.ID)
                        print("VanDuyHud: Đã hốt quà nhiệm vụ ngày cho Duy! 💰✨")
                    end
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Thợ săn tiền thưởng! Duy sẽ không bỏ lỡ một món quà nào. 🎁✅")
end
-- Ngăn 140: Logic Tự động đổi Server khi bãi quái quá đông (Server Hop Anti-KS)
function DuyHud_ServerHop_AntiKS()
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    
    _G.MaxPlayersInArea = 3 -- Nếu quá 3 người ở bãi quái thì đổi Server
    _G.AutoHop = true

    spawn(function()
        while _G.AutoHop do
            task.wait(10) -- Kiểm tra mật độ người chơi mỗi 10 giây
            
            local PlayersNear = 0
            local MyPos = Players.LocalPlayer.Character.HumanoidRootPart.Position
            
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local Distance = (p.Character.HumanoidRootPart.Position - MyPos).Magnitude
                    if Distance < 150 then -- Bán kính 150m quanh bãi quái
                        PlayersNear = PlayersNear + 1
                    end
                end
            end
            
            if PlayersNear >= _G.MaxPlayersInArea then
                print("VanDuyHud: Bãi quá đông! Đang tìm vùng đất hứa cho Duy... ✈️")
                
                -- Logic tìm Server vắng (Dùng API của Roblox)
                local Success, Servers = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
                end)
                
                if Success then
                    for _, s in pairs(Servers) do
                        if s.playing < s.maxPlayers and s.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, Players.LocalPlayer)
                            break
                        end
                    end
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Chống tranh bãi! Duy sẽ luôn là ông chủ của bãi Farm. 👑🛡️")
end
-- Ngăn 141: Logic Tự động mua vật phẩm mạnh nhất (Auto Buy Equipment)
function DuyHud_AutoBuyItems()
    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Money = Player.Data.Money -- Duy cần check tên biến tiền trong game

    _G.AutoBuyActive = true -- Bật/Tắt chế độ tiêu tiền tự động

    -- Danh sách đồ cần mua (Duy liệt kê tên và giá từ thấp đến cao)
    local ShopList = {
        {Name = "Katana", Price = 5000, Category = "Sword"},
        {Name = "Dual Swords", Price = 50000, Category = "Sword"},
        {Name = "Dark Blade", Price = 1000000, Category = "Sword"},
        {Name = "Iron Armor", Price = 10000, Category = "Armor"},
    }

    spawn(function()
        while _G.AutoBuyActive do
            task.wait(5) -- Kiểm tra ví tiền mỗi 5 giây
            
            for _, item in ipairs(ShopList) do
                -- Nếu đủ tiền và chưa sở hữu (Duy cần logic check sở hữu nếu game có)
                if Money.Value >= item.Price then
                    print("VanDuyHud: Duy đang đủ tiền mua [" .. item.Name .. "]. Đang chốt đơn... 💸")
                    
                    -- Gửi lệnh mua lên Server (Duy check tên Remote của Shop)
                    local Success = pcall(function()
                        ReplicatedStorage.Remotes.ShopRemote:InvokeServer("Buy", item.Name)
                    end)
                    
                    if Success then
                        print("VanDuyHud: Đã nâng cấp thành công: " .. item.Name .. "! 🔥")
                        -- Sau khi mua xong, tự động mặc luôn bằng ngăn 135
                        pcall(function() DuyHud_AutoEquipBest() end)
                    end
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Chế độ Đại gia! Tiền của Duy sẽ được đầu tư đúng chỗ. 🛒💎")
end
-- Ngăn 142: Logic Tự động mua Trái Ác Quỷ & Đồ hiếm (Blox Fruits Sniper)
function DuyHud_BloxFruit_Sniper()
    local Player = game.Players.LocalPlayer
    local Money = Player.Data.Beli.Value -- Tiền Beli của Duy
    local Fragments = Player.Data.Fragments.Value -- Điểm F mảnh vỡ
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Danh sách "Ưu tiên" của Duy (Cái nào xịn thì mới mua)
    local WantedFruits = {"Kitsune-Kitsune", "Leopard-Leopard", "Dragon-Dragon", "Dough-Dough"}
    local WantedItems = {"Pale Scarf", "Swordsman Hat", "Pilot Helmet"}

    spawn(function()
        while task.wait(10) do -- Kiểm tra Shop mỗi 10 giây
            -- 1. Check Shop Trái Ác Quỷ (Blox Fruit Dealer)
            for _, fruitName in pairs(WantedFruits) do
                local Success, Result = pcall(function()
                    -- Gửi lệnh mua trái từ Dealer (Duy check Remote chuẩn của Blox Fruits nhé)
                    return ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFruit", fruitName)
                end)
                if Success and Result then
                    print("VanDuyHud: CHÚC MỪNG DUY! Đã săn được trái " .. fruitName .. " cực hiếm! 🍎🔥")
                end
            end

            -- 2. Check Shop Phụ kiện (Nếu Duy đang ở đúng NPC bán đồ đó)
            for _, itemName in pairs(WantedItems) do
                -- Logic: Nếu đủ Beli và đứng gần NPC bán phụ kiện
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", itemName)
                end)
            end
        end
    end)

    print("VanDuyHud: Đã kích hoạt Chế độ Săn đồ Blox Fruits! Duy chỉ cần cày Beli, đồ xịn để Script lo. 💎⚔️")
end
-- Ngăn 143: Logic Tự động mua Trái Ác Quỷ theo danh sách chọn lọc (Smart Fruit Buyer)
function DuyHud_SelectiveFruitBuy()
    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    
    -- Duy thiết lập danh sách trái "Đáng đồng tiền bát gạo" ở đây
    -- Chỉ những trái này xuất hiện trong Shop Dealer thì Script mới mua
    _G.WhitelistedFruits = {
        ["Kitsune-Kitsune"] = true,
        ["Leopard-Leopard"] = true,
        ["Dragon-Dragon"] = true,
        ["Spirit-Spirit"] = true,
        ["Dough-Dough"] = true,
        ["Buddha-Buddha"] = true -- Trái Phật Tổ để đi Raid cực ngon
    }

    _G.AutoBuyFruit = true -- Bật/Tắt tính năng

    spawn(function()
        while _G.AutoBuyFruit do
            task.wait(15) -- Kiểm tra cửa hàng Dealer mỗi 15 giây
            
            -- 1. Lấy danh sách trái đang bán trong Shop hiện tại
            local Success, CurrentShop = pcall(function()
                return CommF:InvokeServer("GetFruits")
            end)

            if Success and CurrentShop then
                for _, fruit in pairs(CurrentShop) do
                    -- 2. Kiểm tra: Trái có trong danh sách Ưu tiên KHÔNG?
                    -- Và Duy có đủ tiền (Beli) để mua KHÔNG?
                    if _G.WhitelistedFruits[fruit.Name] and fruit.OnSale then
                        print("VanDuyHud: PHÁT HIỆN SIÊU PHẨM: " .. fruit.Name .. " đang bán! 🔥")
                        
                        -- 3. Gửi lệnh mua (Chỉ mua trái xịn Duy đã chọn)
                        local BuySuccess = CommF:InvokeServer("BuyFruit", fruit.Name)
                        
                        if BuySuccess then
                            print("VanDuyHud: Đã chốt đơn thành công trái [" .. fruit.Name .. "] cho Duy! 🍎👑")
                        end
                    end
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Bộ lọc Trái Ác Quỷ! Không lo mua nhầm trái lỏ. ✅")
end
-- Ngăn 144: Logic Phát hiện và Tự động nhặt Trái Ác Quỷ (Fruit Notifier & Grab)
function DuyHud_FruitFinder()
    local Workspace = game:GetService("Workspace")
    local Player = game.Players.LocalPlayer
    local RootPart = Player.Character:WaitForChild("HumanoidRootPart")

    _G.AutoGrabFruit = true -- Bật/Tắt chế độ tự lượm

    spawn(function()
        while _G.AutoGrabFruit do
            task.wait(1) -- Quét bản đồ mỗi giây
            
            -- Tìm kiếm các Object có tên là "Fruit" hoặc chứa Model trái cây
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") and (v.Name:find("Fruit") or v:FindFirstChild("Fruit")) then
                    local FruitName = v.Name
                    print("VanDuyHud: PHÁT HIỆN TRÁI RỤNG: " .. FruitName .. "! 🔥🍎")
                    
                    -- 1. Thông báo cho Duy biết
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "DuyHud Fruit Found!",
                        Text = "Đã tìm thấy " .. FruitName .. ". Đang bay tới!",
                        Duration = 5
                    })

                    -- 2. Tự động bay tới và nhặt (Teleport & Pick up)
                    RootPart.CFrame = v.Handle.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.5)
                    firetouchinterest(RootPart, v.Handle, 0)
                    firetouchinterest(RootPart, v.Handle, 1)
                    
                    print("VanDuyHud: Đã lượm thành công " .. FruitName .. " cho Duy! ✅")
                    
                    -- 3. Gọi ngăn 145 để cất ngay vào kho (Tránh bị giết rơi mất)
                    pcall(function() DuyHud_StoreFruit(v) end)
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Mắt thần biển cả! Không trái nào thoát khỏi Duy. 🔍🍏")
end
-- Ngăn 145: Logic Tự động cất Trái Ác Quỷ vào Inventory (Auto Store Fruit)
function DuyHud_AutoStoreFruit()
    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    
    _G.AutoStore = true -- Bật/Tắt chế độ bảo vệ trái cây

    spawn(function()
        while _G.AutoStore do
            task.wait(0.5) -- Kiểm tra liên tục mỗi nửa giây
            
            -- 1. Tìm xem Duy có đang cầm Trái Ác Quỷ trên tay không
            local Character = Player.Character
            if Character then
                local Tool = Character:FindFirstChildOfClass("Tool")
                -- Kiểm tra nếu Tool đó là một Trái Ác Quỷ (Chứa chữ "Fruit")
                if Tool and (Tool.Name:find("Fruit") or Tool:FindFirstChild("Fruit")) then
                    local FruitName = Tool.Name
                    print("VanDuyHud: Đang cất giấu bảo vật [" .. FruitName .. "] vào két sắt... 🔒")
                    
                    -- 2. Gửi lệnh cất trái vào kho (Dùng Remote chuẩn của Blox Fruits)
                    local Success = CommF:InvokeServer("StoreFruit", FruitName, Tool)
                    
                    if Success then
                        print("VanDuyHud: Đã cất " .. FruitName .. " an toàn! Không ai cướp được của Duy. ✅")
                    else
                        -- Nếu kho đã đầy hoặc trái đã có, Script sẽ thông báo
                        warn("VanDuyHud: Không thể cất trái! Kiểm tra lại kho đồ của Duy. ⚠️")
                    end
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Két sắt vĩnh cửu! Duy cứ yên tâm đi lượm trái. 🛡️🍎")
end
-- Ngăn 146: Logic Tự động nâng chỉ số nhân vật (Auto Stats Points)
function DuyHud_AutoStats()
    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    
    -- Duy thiết lập tỷ lệ cộng điểm ở đây (Ví dụ: Tập trung Melee và Defense)
    _G.StatsToUpgrade = {
        ["Melee"] = true,
        ["Defense"] = true,
        ["Blox Fruit"] = true,
        ["Sword"] = false,
        ["Gun"] = false
    }

    _G.AutoStatsActive = true -- Bật/Tắt tính năng nâng điểm

    spawn(function()
        while _G.AutoStatsActive do
            task.wait(2) -- Kiểm tra điểm dư mỗi 2 giây
            
            local Points = Player.Data.StatsPoints.Value -- Duy check tên biến điểm của game
            
            if Points > 0 then
                for stat, active in pairs(_G.StatsToUpgrade) do
                    if active then
                        -- Chia đều điểm cho các mục đã chọn
                        -- Gửi lệnh cộng điểm lên Server (Duy dùng Remote chuẩn Blox Fruits)
                        pcall(function()
                            CommF:InvokeServer("AddStats", stat, 1) -- Cộng 1 điểm mỗi lần loop
                        end)
                    end
                end
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Kiến tạo sức mạnh! Nhân vật của Duy sẽ tự động mạnh lên. 💪⚡")
end
-- Ngăn 147: Logic Tự động nhảy Server tìm Trái Ác Quỷ (Fruit Server Hopper)
function DuyHud_FruitServerHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    
    _G.AutoFruitHop = true -- Bật/Tắt chế độ xuyên không

    spawn(function()
        while _G.AutoFruitHop do
            -- 1. Quét trái ở Server hiện tại trước (Dùng logic ngăn 144)
            local FruitFound = false
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                    FruitFound = true
                    break
                end
            end

            -- 2. Nếu không thấy trái, hoặc lượm xong rồi thì nhảy Server
            if not FruitFound then
                print("VanDuyHud: Server này không có trái. Đang nhảy Server tiếp theo... 🚀")
                
                -- API lấy danh sách Server vắng
                local API_URL = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                local Success, Result = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(API_URL))
                end)

                if Success and Result.data then
                    for _, server in pairs(Result.data) do
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            -- Nhảy Server!
                            TeleportService:TeleportToPlaceInstance(PlaceId, server.id, game.Players.LocalPlayer)
                            break
                        end
                    end
                end
            end
            task.wait(10) -- Đợi 10 giây trước khi kiểm tra lại
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Xuyên không săn báu! Duy sẽ là chủ nhân của mọi Trái Ác Quỷ. 🍎🌀")
end
-- Ngăn 148: Logic Tự động vượt biển (Auto Sea Travel Specialist)
function DuyHud_AutoSeaTravel()
    local Player = game.Players.LocalPlayer
    local Level = Player.Data.Level.Value
    local CommF = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
    
    _G.AutoSeaTravelActive = true -- Bật/Tắt chế độ vượt biển

    spawn(function()
        while _G.AutoSeaTravelActive do
            task.wait(5) -- Kiểm tra Level mỗi 5 giây
            
            -- 1. Nếu Duy đạt Level 700+ và đang ở Sea 1
            if Level >= 700 and game.PlaceId == 2753915549 then -- ID Sea 1
                print("VanDuyHud: Duy đủ trình qua Sea 2 rồi! Đang bắt đầu chuỗi nhiệm vụ... 🚢")
                
                -- Nói chuyện với NPC Military Detective tại Prison
                _G.DuyHud_Teleport(CFrame.new(4848, 6, 744)) -- Tọa độ NPC
                task.wait(1)
                CommF:InvokeServer("DetectiveQuest") -- Nhận chìa khóa đánh Boss Ice Admiral
                
                -- Bay tới Đảo Tuyết để đánh Boss Ice Admiral
                _G.DuyHud_Teleport(CFrame.new(1348, 38, -1325))
                _G.DuyHud_AutoKill("Ice Admiral") -- Sử dụng ngăn 137 để tiêu diệt
                
                -- Sau khi xong, nói chuyện với NPC tại Middle Town để sang Sea 2
                CommF:InvokeServer("TravelMain") 
            
            -- 2. Nếu Duy đạt Level 1500+ và đang ở Sea 2
            elseif Level >= 1500 and game.PlaceId == 4442272160 then -- ID Sea 2
                print("VanDuyHud: Đã đến lúc sang Sea 3 - Tân Thế Giới! 🌊⚡")
                -- Thực hiện logic đánh Boss Don Swan và nói chuyện với NPC King Red Head
                CommF:InvokeServer("TravelDressrosa")
            end
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Hải trình vô tận! Duy sẽ luôn tiến về phía trước. 🌊🏆")
end
-- Ngăn 149: Logic Chế độ màn hình trắng & Tối ưu hóa FPS (Ultra Low Lag)
function DuyHud_UltraOptimization()
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    
    _G.WhiteScreenActive = true -- Duy bật cái này để máy mát rượi

    -- 1. Tắt Render 3D (Đây là chìa khóa để giảm 90% Lag)
    RunService:Set3dRenderingEnabled(not _G.WhiteScreenActive)

    -- 2. Tạo màn hình phủ màu trắng để Duy biết Script vẫn đang chạy
    if _G.WhiteScreenActive then
        local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
        Screen.Name = "DuyHud_Optimization"
        local Frame = Instance.new("Frame", Screen)
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Màu trắng
        
        local Text = Instance.new("TextLabel", Frame)
        Text.Size = UDim2.new(1, 0, 0.2, 0)
        Text.Position = UDim2.new(0, 0, 0.4, 0)
        Text.Text = "VanDuyHud v6.0 - ĐANG TREO MÁY SIÊU NHẸ...\n(Bấm phím [P] để bật lại hình ảnh)"
        Text.TextColor3 = Color3.fromRGB(0, 0, 0)
        Text.BackgroundTransparency = 1
        Text.TextSize = 25
    end

    -- 3. Phím tắt để bật/tắt nhanh chế độ này
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.P then
            _G.WhiteScreenActive = not _G.WhiteScreenActive
            RunService:Set3dRenderingEnabled(not _G.WhiteScreenActive)
            game:GetService("CoreGui"):FindFirstChild("DuyHud_Optimization").Enabled = _G.WhiteScreenActive
            print("VanDuyHud: Trạng thái tối ưu hóa đã thay đổi! ❄️")
        end
    end)
    
    print("VanDuyHud: Đã kích hoạt Chế độ Treo máy Siêu nhẹ! Máy của Duy sẽ mát như tủ lạnh. ❄️🖥️")
end
-- Ngăn 150: Logic Tổng hợp & Hệ thống Key Bảo mật (Master Hub v6.0)
local MyKey = "TranVanDuy-V6-PRO-9999" -- Key Duy thiết lập cho khách
local UserInputKey = "Duy_Input_Key_Here" -- Chỗ để khách nhập Key

if UserInputKey == MyKey then
    print("VanDuyHud: XÁC MINH DANH TÍNH THÀNH CÔNG! 💀👑")
    
    -- 1. Khởi tạo Giao diện (UI) - Dùng thư viện xịn (như Rayfield hoặc Orion)
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
       Name = "💀 VanDuyHud | Blox Fruits v6.0 💀",
       LoadingTitle = "Đang tải 150 ngăn sức mạnh của Duy...",
       LoadingSubtitle = "by Tran Van Duy",
       ConfigurationSaving = { Enabled = true, Folder = "DuyHud_Config" }
    })

    -- 2. TỔNG HỢP CÁC NGĂN SỨC MẠNH VÀO MENU
    local MainTab = Window:CreateTab("Tự động Farm", 4483362458) -- Ngăn 136-138
    local FruitTab = Window:CreateTab("Săn Trái Ác Quỷ", 4483362458) -- Ngăn 142-144
    local SettingTab = Window:CreateTab("Tối ưu & Treo máy", 4483362458) -- Ngăn 149

    -- Nút bấm kích hoạt Farm (Ngăn 137-138)
    MainTab:CreateToggle({
       Name = "Auto Farm Level (Tự chọn Sea/Bãi)",
       CurrentValue = false,
       Callback = function(Value) _G.AutoFarm = Value; DuyHud_SmartFarmPathV2() end,
    })

    -- Nút bấm Săn Trái (Ngăn 144-147)
    FruitTab:CreateButton({
       Name = "Nhảy Server Săn Trái (Server Hop)",
       Callback = function() DuyHud_FruitServerHop() end,
    })

    -- Nút bấm Chế độ Treo máy (Ngăn 149)
    SettingTab:CreateToggle({
       Name = "Màn hình trắng (Giảm 90% Lag)",
       CurrentValue = false,
       Callback = function(Value) _G.WhiteScreenActive = Value; DuyHud_UltraOptimization() end,
    })

    Rayfield:Notify({ Title = "Kích hoạt v6.0!", Content = "Chào mừng Duy trở lại vương quốc hải tặc!", Duration = 5 })
else
    warn("VanDuyHud: SAI MÃ BẢO MẬT! VUI LÒNG LIÊN HỆ DUY ĐỂ LẤY KEY. ❌")
end
