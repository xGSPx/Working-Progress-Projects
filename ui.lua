-- =================================================================================================
-- |                                                                                               |
-- |                        Glitch UI Lib (V2 - Modular) - By Gemini                               |
-- |                                                                                               |
-- =================================================================================================
-- [ LIBRARY START ]

local Glitch = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- // THEME //
local Theme = {
    Background = Color3.fromRGB(30, 30, 40),
    Primary = Color3.fromRGB(45, 45, 55),
    Secondary = Color3.fromRGB(60, 60, 70),
    Accent = Color3.fromRGB(120, 80, 220),
    AccentDark = Color3.fromRGB(90, 60, 180),
    Text = Color3.fromRGB(240, 240, 240),
    Red = Color3.fromRGB(220, 50, 50),
    Green = Color3.fromRGB(50, 220, 50)
}

-- // UTILITY //
local function Create(inst, props) local i=Instance.new(inst); for p,v in pairs(props or {}) do i[p]=v end; return i end

--==================================================================================================
--[[                                      MAIN LIBRARY OBJECTS                                    ]]
--==================================================================================================

function Glitch:CreateWindow(config)
    if getgenv().GlitchUI then pcall(function() getgenv().GlitchUI:Destroy() end) end

    local screenGui = Create("ScreenGui", { Name="GlitchUI", Parent=game:GetService("CoreGui"), ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Global })
    getgenv().GlitchUI = screenGui

    local mainFrame = Create("Frame", { Name="MainFrame", Parent=screenGui, Size=UDim2.new(0,500,0,400), Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Theme.Background, BorderSizePixel=0 })
    local titleBar = Create("Frame", { Name="TitleBar", Parent=mainFrame, Size=UDim2.new(1,0,0,35), BackgroundColor3=Theme.Primary, BorderSizePixel=0 })
    local titleLabel = Create("TextLabel", { Name="Title", Parent=titleBar, Size=UDim2.new(1,-10,1,0), Position=UDim2.fromOffset(10,0), Font=Enum.Font.SourceSansBold, Text="Glitch UI | ".. (config.Name or ""), TextSize=18, TextColor3=Theme.Text, TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1 })
    local tabsContainer = Create("Frame", { Name="TabsContainer", Parent=mainFrame, Position=UDim2.fromOffset(0,35), Size=UDim2.new(1,0,0,35), BackgroundColor3=Theme.Primary, BorderSizePixel=0 })
    Create("UIListLayout", { Parent=tabsContainer, FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,5) })
    Create("UIPadding", { Parent=tabsContainer, PaddingLeft=UDim.new(0,5) })
    local contentContainer = Create("Frame", { Name="ContentContainer", Parent=mainFrame, Position=UDim2.fromOffset(0,70), Size=UDim2.new(1,0,1,-70), BackgroundTransparency=1, ClipsDescendants=true })
    
    local dragging,dragStart,startPos=false; titleBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging,dragStart,startPos=true,i.Position,mainFrame.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end) end end); RunService.RenderStepped:Connect(function() if dragging then mainFrame.Position=UDim2.new(0,startPos.X.Offset+(UserInputService:GetMouseLocation().X-dragStart.X),0,startPos.Y.Offset+(UserInputService:GetMouseLocation().Y-dragStart.Y)) end end)
    
    local Window = {}
    local TabsObject = {}
    local tabList = {}
    local activeTab = nil

    Window.Frame = mainFrame
    Window.Name = config.Name
    Window.Tabs = TabsObject

    function TabsObject:Create(name)
        local tabContent = Create("ScrollingFrame", { Name=name, Parent=contentContainer, Size=UDim2.fromScale(1,1), BackgroundColor3=Theme.Background, BorderSizePixel=0, Visible=false, ScrollBarThickness=4, ScrollBarImageColor3=Theme.Accent })
        local listLayout = Create("UIListLayout", { Parent=tabContent, Padding=UDim.new(0,5), HorizontalAlignment=Enum.HorizontalAlignment.Center })
        Create("UIPadding", { Parent=tabContent, PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10) })
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tabContent.CanvasSize=UDim2.fromOffset(0,listLayout.AbsoluteContentSize.Y) end)
        
        local tabButton = Create("TextButton", { Name=name.."_Button", Parent=tabsContainer, Size=UDim2.new(0,100,1,-10), Position=UDim2.fromScale(0,0.5), AnchorPoint=Vector2.new(0,0.5), Text=name, Font=Enum.Font.SourceSansSemibold, TextSize=16, TextColor3=Theme.Text, BackgroundColor3=Theme.Secondary, BorderSizePixel=0 })

        local Tab = {}
        function Tab:CreateSection(text) Create("TextLabel", { Parent=tabContent, Size=UDim2.new(1,0,0,25), Font=Enum.Font.SourceSansBold, Text=text, TextColor3=Theme.Accent, TextSize=14, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center }) end
        function Tab:CreateLabel(config) Create("TextLabel", { Parent=tabContent, Size=UDim2.new(1,0,0,20), Font=Enum.Font.SourceSans, Text=config.Text, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left }) end
        function Tab:CreateButton(config) local b=Create("TextButton",{ Parent=tabContent, Size=UDim2.new(1,0,0,35), BackgroundColor3=Theme.Primary, Text=config.Name, TextColor3=Theme.Text, Font=Enum.Font.SourceSansBold, TextSize=16 }); b.MouseButton1Click:Connect(config.Callback); return b end
        function Tab:CreateToggle(config) local v=config.CurrentValue or false; local t=Create("TextButton",{ Parent=tabContent, Size=UDim2.new(1,0,0,35), BackgroundColor3=v and Theme.Accent or Theme.Red, Text=config.Name, TextColor3=Theme.Text, Font=Enum.Font.SourceSansSemibold, TextSize=16 }); local T={Value=v}; function T:SetValue(nV) v=nV; T.Value=v; t.BackgroundColor3=v and Theme.Accent or Theme.Red; if config.Callback then config.Callback(v) end end; t.MouseButton1Click:Connect(function() T:SetValue(not v) end); return T end
        function Tab:CreateSlider(config) local v=config.CurrentValue or config.Min; local f=Create("Frame",{ Parent=tabContent, Size=UDim2.new(1,0,0,40), BackgroundTransparency=1 }); local t=Create("TextLabel",{ Parent=f, Size=UDim2.new(1,0,0,20), Font=Enum.Font.SourceSans, Text=config.Name, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left }); local vL=Create("TextLabel",{ Parent=t, Size=UDim2.fromScale(1,1), Font=Enum.Font.SourceSansSemibold, Text=tostring(v), TextColor3=Theme.Accent, TextSize=14, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right }); local b=Create("Frame",{ Parent=f, Position=UDim2.new(0,0,0,20), Size=UDim2.new(1,0,0,20), BackgroundColor3=Theme.Primary, BorderSizePixel=0 }); local fR=Create("Frame",{ Parent=b, Size=UDim2.fromScale((v-config.Min)/(config.Max-config.Min),1), BackgroundColor3=Theme.Accent, BorderSizePixel=0 }); local S={Value=v}; function S:Update(i) local p=math.clamp((i.Position.X-b.AbsolutePosition.X)/b.AbsoluteSize.X,0,1); local rV=config.Min+p*(config.Max-config.Min); v=math.floor(rV/(config.Precision or 1)+0.5)*(config.Precision or 1); S.Value=v; fR.Size=UDim2.fromScale(p,1); vL.Text=tostring(v); if config.Callback then config.Callback(v) end end; b.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then S:Update(i); local c; c=UserInputService.InputChanged:Connect(function(iC) if iC.UserInputType==Enum.UserInputType.MouseMovement then S:Update(iC) else c:Disconnect() end end) end end); return S end
        function Tab:CreateDropdown(config) local v=config.CurrentOption or "None"; local o=config.Options or {"None"}; local op=false; local dF=Create("Frame",{ Parent=tabContent, Size=UDim2.new(1,0,0,35), BackgroundTransparency=1, ZIndex=2 }); local mB=Create("TextButton",{ Parent=dF, Size=UDim2.fromScale(1,1), BackgroundColor3=Theme.Primary, Text=v, TextColor3=Theme.Text, Font=Enum.Font.SourceSansSemibold, TextSize=16 }); local oF=Create("ScrollingFrame",{ Parent=screenGui, BackgroundColor3=Theme.Secondary, BorderSizePixel=0, Visible=false, ZIndex=100}); Create("UIListLayout",{ Parent=oF, Padding=UDim.new(0,2)}); local D={Value=v}; function D:SetOptions(nO) for _,c in ipairs(oF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end; o=nO; for _,opt in ipairs(o) do local b=Create("TextButton",{ Parent=oF, Size=UDim2.new(1,0,0,30), BackgroundColor3=Theme.Primary, Text=opt, TextColor3=Theme.Text, Font=Enum.Font.SourceSans, TextSize=14 }); b.MouseButton1Click:Connect(function() v=opt; D.Value=v; mB.Text=v; op=false; oF.Visible=false; if config.Callback then config.Callback(v) end end) end end; mB.MouseButton1Click:Connect(function() op=not op; oF.Visible=op; oF.Size=UDim2.new(0,mB.AbsoluteSize.X,0,120); oF.Position=UDim2.fromOffset(mB.AbsolutePosition.X, mB.AbsolutePosition.Y+mB.AbsoluteSize.Y) end); D:SetOptions(o); return D end

        table.insert(tabList, {Button=tabButton, Content=tabContent, Object=Tab})
        
        tabButton.MouseButton1Click:Connect(function() for _,t in ipairs(tabList) do t.Content.Visible=false; t.Button.BackgroundColor3=Theme.Secondary end; tabContent.Visible=true; tabButton.BackgroundColor3=Theme.AccentDark; activeTab=Tab end)
        if not activeTab then tabButton:MouseButton1Click() end
        return Tab
    end
    
    return Window
end

return Glitch
