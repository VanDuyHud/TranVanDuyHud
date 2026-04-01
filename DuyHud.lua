-- [[ VANDUYHUD HUB - V1.3 AUTO QUEST FIX 💎 ]]
local player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")

_G.Settings = {
    AutoFarm = false,
    KillAura = true,
    Weapon = "Melee", -- Melee, Sword, Blox Fruit
    WhiteScreen = false,
    SafeSpeed = 350
}

-- [1] HÀM TWEEN DI CHUYỂN MƯỢT
function SmoothTo(target)
    local root = player.Character:WaitForChild("HumanoidRootPart")
    local dist = (root.Position - target.p).Magnitude
    local tween = TS:Create(root, TweenInfo.new(dist/_G.Settings.SafeSpeed, Enum.EasingStyle.Linear), {CFrame = target})
    tween:Play()
    repeat task.wait() until (root.Position - target.p).Magnitude < 10 or not _G.Settings.AutoFarm
end

-- [2] HÀM TỰ ĐỘNG LẤY NHIỆM VỤ THEO CẤP ĐỘ (SEA 1)
-- Duy có thể bảo bạn thêm các đảo khác vào đây nhé
function GetBestQuest()
    local lvl = player.Data.Level.Value
    local name, quest, id = "", "", 1
    
    if lvl >= 1 and lvl < 15 then
        name, quest, id = "Bandit [Lv. 5]", "BanditQuest1", 1
    elseif lvl >= 15 and lvl < 30 then
        name, quest, id = "Monkey [Lv. 14]", "MonkeyQuest1", 1
    elseif lvl >= 30 and lvl < 40 then
        name, quest, id = "Gorilla [Lv. 20]", "MonkeyQuest1", 2
    elseif lvl >= 40 and lvl < 60 then
        name, quest, id = "Pirate [Lv. 35]", "PirateQuest1", 1
    -- Thêm các mốc khác ở đây...
    end
    return name, quest, id
end

-- [3] GIAO DIỆN V1.3
if player.PlayerGui:FindFirstChild("VanDuyHud_V1") then player.PlayerGui.VanDuyHud_V1:Destroy() end
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "VanDuyHud_V1"
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 500); main.Position = UDim2.new(0.5, -200, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(15, 10, 20); Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50); title.Text = "VANDUYHUD V1.3 - FIX AUTO QUEST 💎"
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255); title.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", title)

-- NÚT BẤM CHỌN VŨ KHÍ
local wBtn = Instance.new("TextButton", main)
wBtn.Size = UDim2.new(0.9, 0, 0, 45); wBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
wBtn.Text = "VŨ KHÍ: " .. _G.Settings.Weapon; wBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
wBtn.TextColor3 = Color3.fromRGB(255, 255, 0); Instance.new("UICorner", wBtn)
wBtn.MouseButton1Click:Connect(function()
    local list = {"Melee", "Sword", "Blox Fruit"}
    local i = table.find(list, _G.Settings.Weapon) or 1
    _G.Settings.Weapon = list[i+1] or list[1]
    wBtn.Text = "VŨ KHÍ: " .. _G.Settings.Weapon
end)

-- NÚT BẬT AUTO FARM
local fBtn = Instance.new("TextButton", main)
fBtn.Size = UDim2.new(0.9, 0, 0, 50); fBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
fBtn.Text = "BẮT ĐẦU CÀY CẤP: TẮT"; fBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
fBtn.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", fBtn)
fBtn.MouseButton1Click:Connect(function()
    _G.Settings.AutoFarm = not _G.Settings.AutoFarm
    fBtn.Text = "BẮT ĐẦU CÀY CẤP: " .. (_G.Settings.AutoFarm and "BẬT 🔥" or "TẮT")
    fBtn.BackgroundColor3 = _G.Settings.AutoFarm and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 30, 45)
end)

-- [4] VÒNG LẶP CHÍNH (LOGIC NHẬN Q + BAY FARM)
spawn(function()
    while task.wait(1) do
        if _G.Settings.AutoFarm then
            pcall(function()
                local qName, qQuest, qID = GetBestQuest()
                
                -- KIỂM TRA ĐÃ CÓ NHIỆM VỤ CHƯA
                if not player.PlayerGui.Main.Quest.Visible then
                    -- Tìm NPC giao nhiệm vụ (Thường nằm trong Workspace.NPCs)
                    for _, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                        if v.Name:find("Quest Giver") then
                            SmoothTo(v.HumanoidRootPart.CFrame) -- Bay đến NPC
                            task.wait(0.5)
                            RS.Remotes.CommF_:InvokeServer("StartQuest", qQuest, qID) -- Nhận Quest
                        end
                    end
                else
                    -- NẾU ĐÃ CÓ NHIỆM VỤ THÌ ĐI FARM
                    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name:find(qName) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                -- Tự cầm vũ khí
                                for _, tool in pairs(player.Backpack:GetChildren()) do
                                    if tool:IsA("Tool") and tool.ToolTip == _G.Settings.Weapon then
                                        player.Character.Humanoid:EquipTool(tool)
                                    end
                                end
                                -- Bay sát đầu quái
                                player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                                -- Kill Aura
                                if _G.Settings.KillAura then
                                    RS.Remotes.CommF_:InvokeServer("Attack", v, true)
                                end
                            until not _G.Settings.AutoFarm or v.Humanoid.Health <= 0 or not player.PlayerGui.Main.Quest.Visible
                        end
                    end
                end
            end)
        end
    end
end)

-- CHỐNG KẸT ĐỊA HÌNH
RunService.Stepped:Connect(function()
    if _G.Settings.AutoFarm then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
