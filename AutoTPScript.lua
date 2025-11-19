-- Advanced Auto TP Script with Modern GUI
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.5, 0, 0.5, 0)
Frame.Position = UDim2.new(0.25, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Parent = ScreenGui
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Add multi-NPC TP options
local NPCList = {"NPC1", "NPC2", "NPC3"} -- Replace with actual NPC names

for _, npc in ipairs(NPCList) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0.1, 0)
    Button.Position = UDim2.new(0.05, 0, 0.1 * _, 0)
    Button.Text = "Teleport to " .. npc
    Button.Parent = Frame
    Button.MouseButton1Click:Connect(function()
        local targetNPC = game.Workspace:FindFirstChild(npc)
        if targetNPC then
            Player.Character.HumanoidRootPart.CFrame = targetNPC.HumanoidRootPart.CFrame
        end
    end)
end

-- Close GUI Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.3, 0, 0.1, 0)
CloseButton.Position = UDim2.new(0.35, 0, 0.85, 0)
CloseButton.Text = "Close"
CloseButton.Parent = Frame
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
