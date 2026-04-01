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
