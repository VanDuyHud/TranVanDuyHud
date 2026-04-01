-- [[ DUY HUD V2 - REZD STYLE ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local SideBar = Instance.new("ScrollingFrame")
local Container = Instance.new("Frame")

-- Khởi tạo ScreenGui
ScreenGui.Name = "DuyHud_V2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. NÚT ẨN/MỞ (HÌNH VUÔNG CHỮ D)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Text = "D"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 30
ToggleButton.Font = Enum.Font.GothamBold

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleButton

-- 2. KHUNG MENU CHÍNH (MÀU XANH DƯƠNG)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- 3. THANH SIDEBAR BÊN TRÁI
SideBar.Name = "SideBar"
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = Color3.fromRGB(0, 60, 180)
SideBar.Position = UDim2.new(0, 10, 0, 10)
SideBar.Size = UDim2.new(0, 150, 1, -20)
SideBar.CanvasSize = UDim2.new(0, 0, 1.5, 0)
SideBar.ScrollBarThickness = 2

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = SideBar
SideLayout.Padding = UDim.new(0, 5)

-- 4. KHUNG CHỨA NỘI DUNG BÊN PHẢI
Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 170, 0, 10)
Container.Size = UDim2.new(1, -180, 1, -20)

-- [[ HÀM TẠO CÁC THÀNH PHẦN UI ]]
local Pages = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Parent = Container
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 3, 0)
    Page.ScrollBarThickness = 2
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Page
    Layout.Padding = UDim.new(0, 8)
    
    Pages[name] = Page
    return Page
end

local function CreateSection(parent, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = "--- " .. text .. " ---"
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.Parent = parent
end

local function CreateToggle(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 50, 150)
    Btn.Text = text .. ": OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = parent
    Instance.new("UICorner").Parent = Btn
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and ": ON" or ": OFF")
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 50, 150)
        callback(state)
    end)
end

-- [[ KHỞI TẠO CÁC TRANG ]]

-- TRANG FARMING
local FarmPage = CreatePage("Farming")
CreateSection(FarmPage, "WEAPON")
CreateToggle(FarmPage, "Melee | Sword | Fruit", function() end)
CreateSection(FarmPage, "LEVEL FARM")
CreateToggle(FarmPage, "Auto Farm Level (1-2800)", function() end)
CreateToggle(FarmPage, "Auto Kill Near | Aura", function() end)

-- TRANG QUEST | ITEMS (FULL SEA 1-3)
local ItemPage = CreatePage("Quest | Items")
CreateSection(ItemPage, "SEA 1")
CreateToggle(ItemPage, "Auto Saber", function() end)
CreateSection(ItemPage, "SEA 2")
CreateToggle(ItemPage, "Auto TTK (Triple Katana)", function() end)
CreateSection(ItemPage, "SEA 3")
CreateToggle(ItemPage, "Auto CDK", function() end)
CreateToggle(ItemPage, "Auto Soul Guitar", function() end)
CreateSection(ItemPage, "MASTERY")
CreateToggle(ItemPage, "Auto Mastery 600", function() end)

-- TRANG SEA EVENT
local SeaPage = CreatePage("Sea Event")
CreateSection(SeaPage, "BOSSES")
CreateToggle(SeaPage, "Auto Sea Beast", function() end)
CreateToggle(SeaPage, "Auto Terror Shark", function() end)

-- [[ LOGIC CHUYỂN TAB ]]
local TabList = {"Farming", "Auto Fishing", "Quest | Items", "Volcano Dojo", "Sea Event", "Race V4", "Raid Fruit", "Teleport", "Settings"}

for _, name in pairs(TabList) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Parent = SideBar
    Instance.new("UICorner").Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        if Pages[name] then Pages[name].Visible = true end
    end)
end

-- Mặc định hiện trang đầu
Pages["Farming"].Visible = true

-- Logic Ẩn/Mở Menu
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
