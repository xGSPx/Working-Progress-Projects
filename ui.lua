-- Glitterz Ui Lib
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
    }
}

-- Utility
local function create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    for _, child in ipairs(children or {}) do child.Parent = inst end
    return inst
end

local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging, dragStart, startPos = false
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

local function applyGlitchEffect(label)
    local originalText, originalPos, originalColor = label.Text, label.Position, label.TextColor3
    local running, chars = false, {"#", "%", "@", "?", "!", "$", "&", "*", "~"}
    label.MouseEnter:Connect(function()
        if running then return end
        running = true
        task.spawn(function()
            for i = 1, 12 do
                label.Position = originalPos + UDim2.fromOffset(math.random(-3,3), math.random(-2,2))
                label.TextColor3 = Color3.fromRGB(math.random(120,255), math.random(120,255), math.random(120,255))
                if math.random() > 0.6 then
                    local randChar = chars[math.random(1,#chars)]
                    local cut = math.random(1,#originalText)
                    label.Text = string.sub(originalText,1,cut)..randChar..string.sub(originalText,cut+1)
                else
                    label.Text = originalText
                end
                task.wait(0.04)
            end
            label.Position, label.TextColor3, label.Text = originalPos, originalColor, originalText
            running = false
        end)
    end)
end

function Glitterz:CreateWindow(config)
    config = config or {}
    local theme = Themes.Dark
    local screenGui = create("ScreenGui", {
        Name = "GlitterzUiLib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    if syn and syn.protect_gui then syn.protect_gui(screenGui) end
    screenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

    local window = create("Frame", {
        Size = UDim2.fromOffset(config.Width or 600, config.Height or 380),
        Position = UDim2.fromOffset(120, 120),
        BackgroundColor3 = theme.Bg,
        BorderSizePixel = 0
    }, {screenGui})
    create("UICorner", {CornerRadius = UDim.new(0, 10)}, {Parent = window})

    local titleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Panel,
        BorderSizePixel = 0
    }, {window})
    create("UICorner", {CornerRadius = UDim.new(0, 10)}, {Parent = titleBar})

    local titleLabel = create("TextLabel", {
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Glitterz Interface",
        Font = Enum.Font.GothamSemibold,
        TextSize = 16,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left
    }, {titleBar})
    if config.GlitchHover then applyGlitchEffect(titleLabel) end

    local tabHolder = create("Frame", {
        Position = UDim2.fromOffset(0, 40),
        Size = UDim2.new(0, 120, 1, -40),
        BackgroundColor3 = theme.Panel,
        BorderSizePixel = 0
    }, {window})

    local contentHolder = create("Frame", {
        Position = UDim2.new(0, 120, 0, 40),
        Size = UDim2.new(1, -120, 1, -40),
        BackgroundColor3 = theme.Panel,
        BorderSizePixel = 0
    }, {window})

    local tabButtons = {}
    local function createTab(name)
        local tabFrame = create("Frame", {
            Name = name,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false
        }, {contentHolder})

        local layout = create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, {tabFrame})

        local tabButton = create("TextButton", {
            Text = name,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = theme.Button,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = theme.Text
        }, {tabHolder})
        create("UICorner", {CornerRadius = UDim.new(0, 6)}, {Parent = tabButton})
        if config.GlitchHover then applyGlitchEffect(tabButton) end

        tabButton.MouseButton1Click:Connect(function()
            for _, btn in pairs(tabButtons) do btn.Frame.Visible = false end
            tabFrame.Visible = true
        end)

        table.insert(tabButtons, {Button = tabButton, Frame = tabFrame})

        return {
            AddButton = function(data)
                local btn = create("TextButton", {
                    Text = data.Text,
                    Size = UDim2.new(1, -20, 0, 32),
                    BackgroundColor3 = theme.Button,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextColor3 = theme.Text,
                    Parent = tabFrame
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6)}, {Parent = btn})
                if config.GlitchHover then applyGlitchEffect(btn) end
                btn.MouseButton1Click:Connect(function()
                    if data.Callback then data.Callback() end
                end)
            end
        }
    end

    makeDraggable(window, titleBar)

    return {
        CreateTab = createTab,
        Destroy = function() screenGui:Destroy() end,
        _config = config
    }
end

return Glitterz
