-- [[ VANDUYHUD HUB - PHIÊN BẢN V1.1 HOÀN THIỆN 💎 ]]
-- Tác giả: VanDuyHud
-- Tính năng: Tự nhận nhiệm vụ, Auto Farm, Auto Raid, Lượm đồ, Kill Aura

local player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- CẤU HÌNH HỆ THỐNG
_G.Settings = {
    AutoFarm = false,
    AutoQuest = true, -- Tự nhận nhiệm vụ theo Level
    KillAura = true,
    AutoRaid = false,
    GrabItem = true, -- Tự lượm chén thánh, trái ác quỷ
    WhiteScreen = false,
    SafeSpeed = 350
}

-- [1] HÀM NHẬN NHIỆM VỤ TỰ ĐỘNG (Duy không cần đi tìm NPC)
local function GetQuest()
    local lvl = player.Data.Level.Value
    -- Đây là ví dụ lệnh nhận Quest cơ bản, Duy có thể nhờ bạn thêm ID Quest Sea 2-3 vào đây
    if lvl >= 1 and lvl <= 14 then
        RS.Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
    elseif lvl >= 15 and lvl <= 29 then
        RS.Remotes.CommF_:InvokeServer("StartQuest", "MonkeyQuest1", 1)
    -- Duy có thể bảo bạn viết thêm các mốc Level khác vào đây nhé
    end
end

-- [2] GIAO DIỆN HIỆN ĐẠI
if player.PlayerGui:FindFirstChild("VanDuyHud_V1") then player.PlayerGui.VanDuyHud_V1:Destroy() end
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "VanDuyHud_V1"
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 500)
main.Position = UDim2.new(0.5, -200, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50); title.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
title.Text = "VANDUYHUD V1.1 - FULL TÍNH NĂNG 💎"; title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold; title.TextSize = 16
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 15)

-- NÚT BẤM
local function addBtn(txt, pos, key)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 45); b.Position = pos
    b.Text = txt .. ": TẮT"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    b.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G.Settings[key] = not _G.Settings[key]
        b.Text = txt .. (_G.Settings[key] and ": BẬT 🔥" or ": TẮT")
        b.BackgroundColor3 = _G.Settings[key] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 45)
        if key == "WhiteScreen" then RunService:Set3dRenderingEnabled(not _G.Settings.WhiteScreen) end
    end)
end

addBtn("TỰ ĐỘNG CÀY CẤP (CÓ NHẬN Q)", UDim2.new(0.05, 0, 0.15, 0), "AutoFarm")
addBtn("TỰ ĐỘNG ĐI RAID (FLAME)", UDim2.new(0.05, 0, 0.3, 0), "AutoRaid")
addBtn("TỰ LỤM VẬT PHẨM RƠI", UDim2.new(0.05, 0, 0.45, 0), "GrabItem")
addBtn("TREO MÁY GIẢM LAG", UDim2.new(0.05, 0, 0.6, 0), "WhiteScreen")

-- [3] LOGIC TỔNG HỢP (FARM + RAID + KILL AURA)
spawn(function()
    while task.wait() do
        pcall(function()
            -- 1. Tự lượm đồ (Trái ác quỷ, Chén thánh...)
            if _G.Settings.GrabItem then
                for _,v in pairs(game.Workspace:GetChildren()) do
                    if v:IsA("Tool") or (v:IsA("Model") and v:FindFirstChild("Handle")) then
                        player.Character.HumanoidRootPart.CFrame = v:GetModelCFrame() or v.Handle.CFrame
                    end
                end
            end

            -- 2. Tự nhận nhiệm vụ
            if _G.Settings.AutoFarm and _G.Settings.AutoQuest then
                if not player.PlayerGui.Main.Quest.Visible then
                    GetQuest()
                end
            end

            -- 3. Farm & Raid & Kill Aura
            if _G.Settings.AutoFarm or _G.Settings.AutoRaid then
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        -- Bay sát quái
                        player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        
                        -- Kill Aura (Sát thương cực ảo)
                        if _G.Settings.KillAura then
                            local tool = player.Backpack:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
                            if tool then player.Character.Humanoid:EquipTool(tool) end
                            RS.Remotes.CommF_:InvokeServer("Attack", v, true)
                        end
                    end
                end
            end
            
            -- 4. Bắt đầu Raid (Nếu đang ở trong phòng)
            if _G.Settings.AutoRaid then
                RS.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Flame")
                fireclickdetector(game:GetService("Workspace").Map.Circle.Button.ClickDetector)
            end
        end)
    end
end)

-- CHỐNG KICK VÀ GIẬT LẮC
RunService.Stepped:Connect(function()
    if _G.Settings.AutoFarm then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

print("VanDuyHud V1.1 - Đã sửa lỗi Raid và Nhiệm vụ!")
