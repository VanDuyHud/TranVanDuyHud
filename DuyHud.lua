-- [[ VANDUYHUD HUB - PHIÊN BẢN V1.0 TIẾNG VIỆT 💎 ]]
-- Tác giả: VanDuyHud & Team
-- Tính năng: Tự động cày cấp, Sát thương diện rộng, Giảm lag

local player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- CẤU HÌNH HỆ THỐNG
_G.Settings = {
    AutoFarm = false,
    KillAura = true,
    FastAttack = true,
    WhiteScreen = false,
    SafeSpeed = 350
}

-- [1] TỰ ĐỘNG NHẬP CODE X2 KINH NGHIỆM
spawn(function()
    local codes = {"REWARD_FUN", "NEW_EXPLOIT", "VANDUY_VIP", "KITT_GAMING", "SUB2GAMERROBOT_EXP1"}
    for _, v in pairs(codes) do
        pcall(function()
            RS.Remotes.CommF_:InvokeServer("RedeemCode", v)
        end)
        task.wait(0.5)
    end
end)

-- [2] HÀM DI CHUYỂN MƯỢT (NÉ CHECK)
function SmoothTo(target)
    local root = player.Character:WaitForChild("HumanoidRootPart")
    local dist = (root.Position - target.p).Magnitude
    TS:Create(root, TweenInfo.new(dist/_G.Settings.SafeSpeed, Enum.ExpansionStyle.Linear), {CFrame = target}):Play()
end

-- [GIAO DIỆN V1.0 - PHONG CÁCH VIỆT NAM]
if player.PlayerGui:FindFirstChild("VanDuyHud_V1") then player.PlayerGui.VanDuyHud_V1:Destroy() end
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "VanDuyHud_V1"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 380, 0, 450)
main.Position = UDim2.new(0.5, -190, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- TIÊU ĐỀ TIẾNG VIỆT
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
title.Text = "VANDUYHUD V1.0 - TRÌNH CÀY CẤP 💎"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 15)

-- HÀM TẠO NÚT BẤM
local function addBtn(txt, pos, key)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.85, 0, 0, 50)
    b.Position = pos
    b.Text = txt .. ": ĐANG TẮT"
    b.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        _G.Settings[key] = not _G.Settings[key]
        b.Text = txt .. (_G.Settings[key] and ": ĐANG BẬT 🔥" or ": ĐANG TẮT")
        b.BackgroundColor3 = _G.Settings[key] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 35, 50)
        
        -- Chế độ treo máy (White Screen)
        if key == "WhiteScreen" then 
            RunService:Set3dRenderingEnabled(not _G.Settings.WhiteScreen) 
        end
    end)
end

-- DANH SÁCH TÍNH NĂNG TIẾNG VIỆT
addBtn("TỰ ĐỘNG CÀY CẤP", UDim2.new(0.075, 0, 0.2, 0), "AutoFarm")
addBtn("SÁT THƯƠNG QUANH THÂN (KILL AURA)", UDim2.new(0.075, 0, 0.35, 0), "KillAura")
addBtn("TREO MÁY GIẢM LAG (MÀN TRẮNG)", UDim2.new(0.075, 0, 0.5, 0), "WhiteScreen")

-- [3] LOGIC FARM VÀ CHIẾN ĐẤU
spawn(function()
    while task.wait() do
        if _G.Settings.AutoFarm then
            pcall(function()
                -- Tự động lấy vũ khí (Kiếm/Đấm)
                local tool = player.Backpack:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
                if tool and not player.Character:FindFirstChild(tool.Name) then
                    player.Character.Humanoid:EquipTool(tool)
                end

                -- Tìm và diệt quái
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        -- Bay lên đầu quái để né chiêu
                        player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 40, 0)
                        
                        -- Kill Aura (Gửi lệnh đánh trực tiếp)
                        if _G.Settings.KillAura then
                            RS.Remotes.CommF_:InvokeServer("Attack", v, true)
                        end
                    end
                end
            end)
        end
    end
end)

-- [4] CHỐNG KẸT VÀ ĐI XUYÊN VẬT THỂ
RunService.Stepped:Connect(function()
    if _G.Settings.AutoFarm then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- THÔNG BÁO KHI CHẠY THÀNH CÔNG
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "VanDuyHud V1.0";
    Text = "Đã kích hoạt Tiếng Việt thành công!";
    Duration = 5;
})

print("VanDuyHud V1.0 Tieng Viet da san sang!")
