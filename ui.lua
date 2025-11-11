-- Glitterz Ui Lib
-- Author: You + Copilot
-- Features: Sidebar tabs, draggable window, hide/show, delete, buttons, toggles, dropdowns, inputs
-- Extra: Global glitch hover animation (cyberpunk vibe)

local Glitterz = {}
Glitterz.__index = Glitterz

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Theme presets
local Themes = {
    Dark = {
        Bg = Color3.fromRGB(20, 20, 24),
        Panel = Color3.fromRGB(26, 26, 32),
        Accent = Color3.fromRGB(148, 93, 214),
        Text = Color3.fromRGB(230, 230, 235),
        MutedText = Color3.fromRGB(170, 170, 175),
        Divider = Color3.fromRGB(40, 40, 48),
        Button = Color3.fromRGB(35, 35, 42),
        ButtonHover = Color3.fromRGB(45, 45, 56),
        ToggleOn = Color3.fromRGB(93, 214, 148),
        ToggleOff = Color3.fromRGB(90, 90, 96),
        Input = Color3.fromRGB(30, 30, 36),
        Dropdown = Color3.fromRGB(30, 30, 36),
        Danger = Color3.fromRGB(214, 93, 93)
    },
    Light = {
        Bg = Color3.fromRGB(242, 242, 247),
        Panel = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(74, 112, 214),
        Text = Color3.fromRGB(33, 33, 36),
        MutedText = Color3.fromRGB(92, 92, 96),
        Divider = Color3.fromRGB(225, 225, 230),
        Button = Color3.fromRGB(245, 245, 250),
        ButtonHover = Color3.fromRGB(235, 235, 245),
        ToggleOn = Color3.fromRGB(93, 214, 148),
        ToggleOff = Color3.fromRGB(160, 160, 168),
        Input = Color3.fromRGB(248, 248, 252),
        Dropdown = Color3.fromRGB(248, 248, 252),
        Danger = Color3.fromRGB(214, 93, 93)
    }
}

-- Utility
local function create(class, props, children)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            inst[k] = v
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end
    return inst
end

local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Glitch hover effect
local function applyGlitchEffect(label)
    local originalText = label.Text
    local originalPos = label.Position
    local originalColor = label.TextColor3
    local running = false
    local chars = {"#", "%", "@", "?", "!", "$", "&", "*", "~"}

    local function glitchBurst()
        if running then return end
        running = true
        task.spawn(function()
            for i = 1, 12 do
                local dx = math.random(-3, 3)
                local dy = math.random(-2, 2)
                label.Position = originalPos + UDim2.fromOffset(dx, dy)

                label.TextColor3 = Color3.fromRGB(
                    math.random(120,255),
                    math.random(120,255),
                    math.random(120,255)
                )

                if math.random() > 0.6 then
                    local randChar = chars[math.random(1, #chars)]
                    local cut = math.random(1, #originalText)
                    label.Text = string.sub(originalText, 1, cut) .. randChar .. string.sub(originalText, cut+1)
                else
                    label.Text = originalText
                end

                task.wait(0.04)
            end
            label.Position = originalPos
            label.TextColor3 = originalColor
            label.Text = originalText
            running = false
        end)
    end

    label.MouseEnter:Connect(glitchBurst)
end

-- Main creation
function Glitterz:CreateWindow(config)
    config = config or {}
    local width = config.Width or 600
    local height = config.Height or 380
    local theme = Themes[(config.Theme == "Light") and "Light" or "Dark"]
    local name = config.Name or "Glitterz Interface"
    local hideKey = config.HideKey or Enum.KeyCode.RightShift
    local glitchHover = config.GlitchHover or false

    local screenGui = create("ScreenGui", {
        Name = "GlitterzUiLib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
    screenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

    local window = create("Frame", {
        Name = "Window",
        Size = UDim2.fromOffset(width, height),
        Position = UDim2.fromOffset(120, 120),
        BackgroundColor3 = theme.Bg,
        BorderSizePixel = 0,
        Parent = screenGui
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10)}, {Parent = window})

    local titleBar = create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Panel,
        BorderSizePixel = 0,
        Parent = window
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10)}, {Parent = titleBar})

    local titleLabel = create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 16,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    if glitchHover then applyGlitchEffect(titleLabel) end

    local controls = create("Frame", {
        Name = "Controls",
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(1, -124, 0, 0),
        BackgroundTransparency = 1,
        Parent = titleBar
    })

    local hideButton = create("TextButton", {
        Name = "Hide",
        Size = UDim2.new(0, 56, 0, 26),
        Position = UDim2.fromOffset(4, 7),
        BackgroundColor3 = theme.Button,
        Text = "Hide",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = theme.Text,
        Parent = controls
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, {Parent = hideButton})
    if glitchHover then applyGlitchEffect(hideButton) end

    local deleteButton = create("TextButton", {
        Name = "Delete",
        Size = UDim2.new(0, 56, 0, 26),
        Position = UDim2.fromOffset(64, 7),
        BackgroundColor3 = theme.Danger,
        Text = "Delete",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255,255,255),
        Parent = controls
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, {Parent = deleteButton})
    if glitchHover then applyGlitchEffect(deleteButton)
