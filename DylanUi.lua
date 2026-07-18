--[[
    ConceptUI - Modern UI Library
    Preserved all original functions, new visual design
--]]

local ui_options = {
    main_color = Color3.fromRGB(110, 45, 220), -- Purple accent to match gradient
    min_size = Vector2.new(400, 300),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true,
}

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("RunService")
local ps = game:GetService("Players")
local p = ps.LocalPlayer
local mouse = p:GetMouse()

local cloneref = cloneref and cloneref or function(...) return ... end
local CoreGui = cloneref(game:GetService("CoreGui"))

-- Cleanup old UI
do
    local oldGui = game:GetService("CoreGui"):FindFirstChild("ConceptUI")
    if oldGui then oldGui:Destroy() end
    local oldGui2 = p:FindFirstChild("PlayerGui") and p.PlayerGui:FindFirstChild("ConceptUI")
    if oldGui2 then oldGui2:Destroy() end
end

-- Create ScreenGui
local Gui = Instance.new("ScreenGui")
Gui.Name = "ConceptUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = gethui and gethui() or (CoreGui or p:WaitForChild("PlayerGui"))

-- Helper functions
local function CreateGradient(parent)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110, 45, 220)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176, 96, 244)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236, 198, 255))
    }
    gradient.Parent = parent
    return gradient
end

local function CreateMarbleTexture(parent, cornerRadius)
    local marble = Instance.new("ImageLabel")
    marble.Name = "MarbleTexture"
    marble.Size = UDim2.fromScale(1, 1)
    marble.BackgroundTransparency = 1
    marble.BorderSizePixel = 0
    marble.Image = "rbxassetid://133709037992585"
    marble.ImageTransparency = 0.6
    marble.ScaleType = Enum.ScaleType.Stretch
    marble.ZIndex = 1
    marble.Parent = parent
    if cornerRadius then
        Instance.new("UICorner", marble).CornerRadius = UDim.new(0, cornerRadius)
    end
    return marble
end

local function ApplyGlassStyle(frame, cornerRadius, zIndex)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    if zIndex then frame.ZIndex = zIndex end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius or 20)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    
    CreateGradient(frame)
    CreateMarbleTexture(frame, cornerRadius)
end

local function CreatePanel(name, anchorPos, size, cornerRadius, zIndex)
    local panel = {}
    
    -- Shadow
    panel.Shadow = Instance.new("Frame")
    panel.Shadow.Name = name .. "Shadow"
    panel.Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Shadow.Position = anchorPos + UDim2.new(0, 4, 0, 8)
    panel.Shadow.Size = size
    panel.Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panel.Shadow.BackgroundTransparency = 0.5
    panel.Shadow.BorderSizePixel = 0
    panel.Shadow.ZIndex = (zIndex or 1) - 1
    panel.Shadow.Parent = Gui
    Instance.new("UICorner", panel.Shadow).CornerRadius = UDim.new(0, cornerRadius or 20)

    -- Main frame
    panel.Frame = Instance.new("Frame")
    panel.Frame.Name = name
    panel.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Frame.Position = anchorPos
    panel.Frame.Size = size
    panel.Frame.ZIndex = zIndex or 1
    panel.Frame.Parent = Gui
    
    ApplyGlassStyle(panel.Frame, cornerRadius, zIndex)

    return panel
end

-- Layout parameters
local MainWidth = 0.45
local MainHeight = 0.78
local SideWidth = 0.15
local SideHeight = 0.78
local Gap = 0.025

-- Create panels
local MainSize = UDim2.fromScale(MainWidth, MainHeight)
local MainPos = UDim2.fromScale(0.5, 0.54)
local MainPanel = CreatePanel("Main", MainPos, MainSize, 20, 2)

local SideX = (0.5 - MainWidth/2) - Gap - SideWidth/2
local SidePos = UDim2.new(SideX, 0, 0.54, 0)
local SideSize = UDim2.fromScale(SideWidth, SideHeight)
local SidePanel = CreatePanel("Side", SidePos, SideSize, 20, 2)

-- Header on main panel
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.AnchorPoint = Vector2.new(0.5, 0)
Header.Position = UDim2.new(0.5, 0, -0.045, 0)
Header.Size = UDim2.fromScale(0.55, 0.1)
Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Header.BackgroundTransparency = 0.1
Header.BorderSizePixel = 0
Header.ZIndex = 10
Header.Parent = MainPanel.Frame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)
CreateGradient(Header)

local HeaderMarble = Instance.new("ImageLabel")
HeaderMarble.Size = UDim2.fromScale(1, 1)
HeaderMarble.BackgroundTransparency = 1
HeaderMarble.BorderSizePixel = 0
HeaderMarble.Image = "rbxassetid://133709037992585"
HeaderMarble.ImageTransparency = 0.6
HeaderMarble.ScaleType = Enum.ScaleType.Stretch
HeaderMarble.ZIndex = 1
HeaderMarble.Parent = Header
Instance.new("UICorner", HeaderMarble).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.Position = UDim2.fromScale(0.5, 0.5)
Title.Size = UDim2.fromScale(0.85, 0.75)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "UI"
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.ZIndex = 12
Title.Parent = Header

-- Close/Minimize button
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.Position = UDim2.new(1, -12, 0, 12)
CloseButton.Size = UDim2.fromOffset(40, 40)
CloseButton.BackgroundTransparency = 1
CloseButton.BorderSizePixel = 0
CloseButton.Image = "rbxassetid://114840795551292"
CloseButton.ScaleType = Enum.ScaleType.Fit
CloseButton.ZIndex = 20
CloseButton.Parent = MainPanel.Frame

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.15), {Size = UDim2.fromOffset(46, 46)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.15), {Size = UDim2.fromOffset(40, 40)}):Play()
end)

-- Minimized restore button
local MinimizedFrame = Instance.new("ImageButton")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.AnchorPoint = Vector2.new(1, 0)
MinimizedFrame.Position = UDim2.new(1, -20, 0, 20)
MinimizedFrame.Size = UDim2.fromOffset(0, 0)
MinimizedFrame.BackgroundTransparency = 1
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.ZIndex = 100
MinimizedFrame.Image = "rbxassetid://103591022804634"
MinimizedFrame.ScaleType = Enum.ScaleType.Fit
MinimizedFrame.Parent = Gui
Instance.new("UICorner", MinimizedFrame).CornerRadius = UDim.new(1, 0)

local MinimizedStroke = Instance.new("UIStroke")
MinimizedStroke.Color = Color3.fromRGB(255, 255, 255)
MinimizedStroke.Thickness = 2
MinimizedStroke.Transparency = 0.3
MinimizedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MinimizedStroke.Parent = MinimizedFrame

-- Tab content containers
local MainContent = Instance.new("Frame")
MainContent.Name = "MainContent"
MainContent.Position = UDim2.new(0, 0, 0.05, 0)
MainContent.Size = UDim2.new(1, 0, 0.95, 0)
MainContent.BackgroundTransparency = 1
MainContent.ZIndex = 5
MainContent.Parent = MainPanel.Frame

-- Tab buttons bar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Position = UDim2.new(0, 16, 0, 8)
TabBar.Size = UDim2.new(1, -32, 0, 42)
TabBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabBar.BackgroundTransparency = 0.85
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 6
TabBar.Parent = MainContent
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 14)

local TabButtonsList = Instance.new("UIListLayout")
TabButtonsList.FillDirection = Enum.FillDirection.Horizontal
TabButtonsList.SortOrder = Enum.SortOrder.LayoutOrder
TabButtonsList.Padding = UDim.new(0, 4)
TabButtonsList.Parent = TabBar

-- Tab content area
local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Position = UDim2.new(0, 16, 0, 58)
TabContent.Size = UDim2.new(1, -32, 1, -66)
TabContent.BackgroundTransparency = 1
TabContent.ZIndex = 5
TabContent.Parent = MainContent

-- Side panel tab buttons
local SideTabButtons = Instance.new("Frame")
SideTabButtons.Name = "SideTabButtons"
SideTabButtons.Position = UDim2.new(0, 10, 0, 10)
SideTabButtons.Size = UDim2.new(1, -20, 1, -20)
SideTabButtons.BackgroundTransparency = 1
SideTabButtons.ZIndex = 5
SideTabButtons.Parent = SidePanel.Frame

local SideTabList = Instance.new("UIListLayout")
SideTabList.SortOrder = Enum.SortOrder.LayoutOrder
SideTabList.Padding = UDim.new(0, 8)
SideTabList.Parent = SideTabButtons

-- Utility functions (preserved from original)
local checks = { ["binding"] = false }

local function Resize(part, new, _delay)
    _delay = _delay or 0.5
    local tweenInfo = TweenInfo.new(_delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(part, tweenInfo, new)
    tween:Play()
end

local function rgbtohsv(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max
    local d = max - min
    if max == 0 then s = 0 else s = d / max end
    if max == min then
        h = 0
    else
        if max == r then h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then h = (b - r) / d + 2
        elseif max == b then h = (r - g) / d + 4 end
        h = h / 6
    end
    return h, s, v
end

local function hasprop(object, prop)
    local a, b = pcall(function() return object[tostring(prop)] end)
    if a then return b end
end

local function gNameLen(obj)
    return obj.TextBounds.X + 20
end

local function gMouse()
    return Vector2.new(UIS:GetMouseLocation().X + 1, UIS:GetMouseLocation().Y - 35)
end

-- Toggle key
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == ((typeof(ui_options.toggle_key) == "EnumItem") and ui_options.toggle_key or Enum.KeyCode.RightShift) then
        if not checks.binding then
            Gui.Enabled = not Gui.Enabled
        end
    end
end)

-- Minimize/Restore functionality
local minimized = false

MinimizedFrame.MouseButton1Click:Connect(function()
    MinimizedFrame.Visible = false
    MainPanel.Frame.Visible = true
    MainPanel.Shadow.Visible = true
    SidePanel.Frame.Visible = true
    SidePanel.Shadow.Visible = true

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(MainPanel.Frame, tweenInfo, {Size = MainSize, Position = MainPos}):Play()
    TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = MainSize, Position = MainPos + UDim2.new(0, 4, 0, 8)}):Play()
    TweenService:Create(SidePanel.Frame, tweenInfo, {Size = SideSize, Position = SidePos}):Play()
    TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = SideSize, Position = SidePos + UDim2.new(0, 4, 0, 8)}):Play()
    minimized = false
end)

CloseButton.MouseButton1Click:Connect(function()
    if minimized then return end
    local targetPos = UDim2.new(1, -50, 0, 50)
    local targetSize = UDim2.fromScale(0.04, 0.04)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

    TweenService:Create(MainPanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
    TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0, 4, 0, 8)}):Play()
    TweenService:Create(SidePanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
    TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0, 4, 0, 8)}):Play()

    task.wait(0.3)
    MainPanel.Frame.Visible = false
    MainPanel.Shadow.Visible = false
    SidePanel.Frame.Visible = false
    SidePanel.Shadow.Visible = false

    MinimizedFrame.Visible = true
    MinimizedFrame:TweenSize(UDim2.fromOffset(60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
    minimized = true
end)

-- Helper to create styled element frame
local function CreateElementFrame(name, parent, size, zIndex)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size or UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.85
    frame.BorderSizePixel = 0
    frame.ZIndex = zIndex or 6
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    
    return frame
end

-- Helper to create accent button
local function CreateAccentButton(parent, text, size, zIndex)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(110, 45, 220)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.ZIndex = zIndex or 7
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.4
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn
    
    CreateGradient(btn)
    
    return btn
end

-- ===================================================================
-- LIBRARY API (All original functions preserved)
-- ===================================================================
local library = {}
local windows = {}

function library:AddWindow(title, options)
    title = tostring(title or "New Window")
    options = (typeof(options) == "table") and options or ui_options
    options.tween_time = 0.1
    
    Title.Text = title
    
    local window_data = {}
    local tabs = {}
    local currentTab = nil
    local dropdown_open = false
    
    -- Clear previous content
    for _, child in pairs(TabBar:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, child in pairs(TabContent:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, child in pairs(SideTabButtons:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    function window_data:AddTab(tab_name)
        local tab_data = {}
        tab_name = tostring(tab_name or "New Tab")
        
        -- Tab button in top bar
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "TabBtn_" .. tab_name
        tabBtn.Size = UDim2.new(0, gNameLen(Instance.new("TextLabel", nil)) + 20, 0, 32)
        tabBtn.Position = UDim2.new(0, 5, 0, 5)
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundTransparency = 0.9
        tabBtn.BorderSizePixel = 0
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Text = tab_name
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextSize = 13
        tabBtn.ZIndex = 7
        tabBtn.Parent = TabBar
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
        
        -- Side tab button
        local sideBtn = Instance.new("TextButton")
        sideBtn.Name = "SideBtn_" .. tab_name
        sideBtn.Size = UDim2.new(1, 0, 0, 36)
        sideBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sideBtn.BackgroundTransparency = 0.9
        sideBtn.BorderSizePixel = 0
        sideBtn.Font = Enum.Font.GothamSemibold
        sideBtn.Text = tab_name
        sideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        sideBtn.TextSize = 13
        sideBtn.ZIndex = 7
        sideBtn.Parent = SideTabButtons
        Instance.new("UICorner", sideBtn).CornerRadius = UDim.new(0, 10)
        Instance.new("UIStroke", sideBtn).Color = Color3.fromRGB(255, 255, 255)
        sideBtn.UIStroke.Transparency = 0.5
        
        -- Tab content container
        local tabFrame = Instance.new("Frame")
        tabFrame.Name = tab_name .. "_Content"
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.ZIndex = 5
        tabFrame.Parent = TabContent
        
        local tabScroll = Instance.new("ScrollingFrame")
        tabScroll.Name = "Scroll"
        tabScroll.Size = UDim2.new(1, 0, 1, 0)
        tabScroll.BackgroundTransparency = 1
        tabScroll.BorderSizePixel = 0
        tabScroll.ScrollBarThickness = 4
        tabScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        tabScroll.ScrollBarImageTransparency = 0.5
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabScroll.ZIndex = 5
        tabScroll.Parent = tabFrame
        
        local tabList = Instance.new("UIListLayout")
        tabList.Name = "List"
        tabList.SortOrder = Enum.SortOrder.LayoutOrder
        tabList.Padding = UDim.new(0, 6)
        tabList.Parent = tabScroll
        
        local function show()
            if dropdown_open then return end
            for _, f in pairs(TabContent:GetChildren()) do
                if f:IsA("Frame") then f.Visible = false end
            end
            for _, b in pairs(TabBar:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundTransparency = 0.9
                end
            end
            for _, b in pairs(SideTabButtons:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundTransparency = 0.9
                end
            end
            tabBtn.BackgroundTransparency = 0.75
            sideBtn.BackgroundTransparency = 0.7
            tabFrame.Visible = true
            currentTab = tabFrame
        end
        
        tabBtn.MouseButton1Click:Connect(show)
        sideBtn.MouseButton1Click:Connect(show)
        
        function tab_data:Show()
            show()
        end
        
        -- ===================================================================
        -- ORIGINAL ELEMENT FUNCTIONS (adapted for new UI)
        -- ===================================================================
        
        function tab_data:AddLabel(label_text)
            label_text = tostring(label_text or "New Label")
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -4, 0, 22)
            label.Position = UDim2.new(0, 4, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamSemibold
            label.Text = label_text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 7
            label.Parent = tabScroll
            return label
        end
        
        function tab_data:AddButton(button_text, callback)
            button_text = tostring(button_text or "New Button")
            callback = typeof(callback) == "function" and callback or function() end
            
            local btnFrame = CreateElementFrame("Btn_" .. button_text, tabScroll, UDim2.new(1, -4, 0, 36), 6)
            local btn = CreateAccentButton(btnFrame, button_text, UDim2.new(1, 0, 1, 0), 7)
            btn.BackgroundTransparency = 0.4
            
            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            return btn
        end
        
        function tab_data:AddSwitch(switch_text, callback)
            local switch_data = {}
            switch_text = tostring(switch_text or "New Switch")
            callback = typeof(callback) == "function" and callback or function() end
            
            local switchFrame = CreateElementFrame("Switch_" .. switch_text, tabScroll, UDim2.new(1, -4, 0, 40), 6)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.65, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamSemibold
            label.Text = switch_text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 7
            label.Parent = switchFrame
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 52, 0, 28)
            toggleBtn.Position = UDim2.new(1, -58, 0.5, -14)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleBtn.BackgroundTransparency = 0.85
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.Text = ""
            toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleBtn.TextSize = 16
            toggleBtn.ZIndex = 7
            toggleBtn.Parent = switchFrame
            Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 14)
            Instance.new("UIStroke", toggleBtn).Color = Color3.fromRGB(255, 255, 255)
            toggleBtn.UIStroke.Transparency = 0.4
            
            local toggled = false
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleBtn.Text = toggled and utf8.char(10003) or ""
                TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                    BackgroundTransparency = toggled and 0.5 or 0.85
                }):Play()
                pcall(callback, toggled)
            end)
            
            function switch_data:Set(bool)
                toggled = (typeof(bool) == "boolean") and bool or false
                toggleBtn.Text = toggled and utf8.char(10003) or ""
                toggleBtn.BackgroundTransparency = toggled and 0.5 or 0.85
                pcall(callback, toggled)
            end
            
            return switch_data, switchFrame
        end
        
        function tab_data:AddTextBox(textbox_text, callback, textbox_options)
            textbox_text = tostring(textbox_text or "New TextBox")
            callback = typeof(callback) == "function" and callback or function() end
            textbox_options = typeof(textbox_options) == "table" and textbox_options or {["clear"] = true}
            
            local tbFrame = CreateElementFrame("TB_" .. textbox_text, tabScroll, UDim2.new(1, -4, 0, 36), 6)
            
            local tb = Instance.new("TextBox")
            tb.Size = UDim2.new(1, -16, 1, 0)
            tb.Position = UDim2.new(0, 8, 0, 0)
            tb.BackgroundTransparency = 1
            tb.Font = Enum.Font.GothamSemibold
            tb.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
            tb.PlaceholderText = textbox_text
            tb.Text = ""
            tb.TextColor3 = Color3.fromRGB(255, 255, 255)
            tb.TextSize = 13
            tb.TextXAlignment = Enum.TextXAlignment.Left
            tb.ZIndex = 7
            tb.Parent = tbFrame
            
            tb.FocusLost:Connect(function(ep)
                if ep and #tb.Text > 0 then
                    pcall(callback, tb.Text)
                    if textbox_options.clear then tb.Text = "" end
                end
            end)
            
            return tb
        end
        
        function tab_data:AddSlider(slider_text, callback, slider_options)
            local slider_data = {}
            slider_text = tostring(slider_text or "New Slider")
            callback = typeof(callback) == "function" and callback or function() end
            slider_options = typeof(slider_options) == "table" and slider_options or {}
            slider_options = {
                ["min"] = slider_options.min or 0,
                ["max"] = slider_options.max or 100,
                ["readonly"] = slider_options.readonly or false,
            }
            
            local sliderFrame = CreateElementFrame("Slider_" .. slider_text, tabScroll, UDim2.new(1, -4, 0, 52), 6)
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -60, 0, 20)
            titleLabel.Position = UDim2.new(0, 8, 0, 2)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Font = Enum.Font.GothamSemibold
            titleLabel.Text = slider_text
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextSize = 12
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.ZIndex = 7
            titleLabel.Parent = sliderFrame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -54, 0, 2)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = tostring(slider_options.min)
            valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.ZIndex = 7
            valueLabel.Parent = sliderFrame
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -16, 0, 8)
            sliderBg.Position = UDim2.new(0, 8, 0, 28)
            sliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderBg.BackgroundTransparency = 0.75
            sliderBg.BorderSizePixel = 0
            sliderBg.ZIndex = 7
            sliderBg.Parent = sliderFrame
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 4)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderFill.BackgroundTransparency = 0.4
            sliderFill.BorderSizePixel = 0
            sliderFill.ZIndex = 8
            sliderFill.Parent = sliderBg
            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 4)
            CreateGradient(sliderFill)
            
            local function setSliderValue(val)
                val = math.clamp(val, slider_options.min, slider_options.max)
                local pct = (val - slider_options.min) / (slider_options.max - slider_options.min)
                Resize(sliderFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
                valueLabel.Text = tostring(math.floor(val))
                pcall(callback, math.floor(val))
            end
            
            local entered = false
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and entered and not slider_options.readonly then
                    local connection
                    connection = RS.Heartbeat:Connect(function()
                        if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            connection:Disconnect()
                            return
                        end
                        local mouseLoc = gMouse()
                        local relX = (mouseLoc.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                        local val = slider_options.min + (slider_options.max - slider_options.min) * math.clamp(relX, 0, 1)
                        setSliderValue(val)
                    end)
                end
            end)
            sliderBg.MouseEnter:Connect(function() entered = true end)
            sliderBg.MouseLeave:Connect(function() entered = false end)
            
            function slider_data:Set(new_value)
                setSliderValue(tonumber(new_value) or slider_options.min)
            end
            
            slider_data:Set(slider_options.min)
            return slider_data, sliderFrame
        end
        
        function tab_data:AddKeybind(keybind_name, callback, keybind_options)
            local keybind_data = {}
            keybind_name = tostring(keybind_name or "New Keybind")
            callback = typeof(callback) == "function" and callback or function() end
            keybind_options = typeof(keybind_options) == "table" and keybind_options or {}
            keybind_options = {
                ["standard"] = keybind_options.standard or Enum.KeyCode.RightShift,
            }
            
            local kbFrame = CreateElementFrame("KB_" .. keybind_name, tabScroll, UDim2.new(1, -4, 0, 40), 6)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.55, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamSemibold
            label.Text = keybind_name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 7
            label.Parent = kbFrame
            
            local inputBtn = Instance.new("TextButton")
            inputBtn.Size = UDim2.new(0, 85, 0, 28)
            inputBtn.Position = UDim2.new(1, -91, 0.5, -14)
            inputBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            inputBtn.BackgroundTransparency = 0.85
            inputBtn.BorderSizePixel = 0
            inputBtn.Font = Enum.Font.GothamSemibold
            inputBtn.Text = "..."
            inputBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            inputBtn.TextSize = 11
            inputBtn.ZIndex = 7
            inputBtn.Parent = kbFrame
            Instance.new("UICorner", inputBtn).CornerRadius = UDim.new(0, 10)
            Instance.new("UIStroke", inputBtn).Color = Color3.fromRGB(255, 255, 255)
            inputBtn.UIStroke.Transparency = 0.4
            
            local shortkeys = {
                RightControl = 'RightCtrl', LeftControl = 'LeftCtrl',
                LeftShift = 'LShift', RightShift = 'RShift',
                MouseButton1 = "Mouse1", MouseButton2 = "Mouse2"
            }
            
            local currentKey = keybind_options.standard
            
            function keybind_data:SetKeybind(Keybind)
                local key = shortkeys[Keybind.Name] or Keybind.Name
                inputBtn.Text = key
                currentKey = Keybind
            end
            
            UIS.InputBegan:Connect(function(a, b)
                if checks.binding then
                    spawn(function() wait() checks.binding = false end)
                    return
                end
                if a.KeyCode == currentKey and not b then
                    pcall(callback, currentKey)
                end
            end)
            
            keybind_data:SetKeybind(keybind_options.standard)
            
            inputBtn.MouseButton1Click:Connect(function()
                if checks.binding then return end
                inputBtn.Text = "..."
                checks.binding = true
                local a, b = UIS.InputBegan:Wait()
                keybind_data:SetKeybind(a.KeyCode)
            end)
            
            return keybind_data, kbFrame
        end
        
        function tab_data:AddDropdown(dropdown_name, callback)
            local dropdown_data = {}
            dropdown_name = tostring(dropdown_name or "New Dropdown")
            callback = typeof(callback) == "function" and callback or function() end
            
            local ddFrame = CreateElementFrame("DD_" .. dropdown_name, tabScroll, UDim2.new(1, -4, 0, 36), 6)
            ddFrame.ClipsDescendants = true
            
            local ddBtn = Instance.new("TextButton")
            ddBtn.Size = UDim2.new(1, 0, 0, 36)
            ddBtn.BackgroundTransparency = 1
            ddBtn.Font = Enum.Font.GothamSemibold
            ddBtn.Text = "  " .. dropdown_name .. "  ▼"
            ddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ddBtn.TextSize = 13
            ddBtn.TextXAlignment = Enum.TextXAlignment.Left
            ddBtn.ZIndex = 7
            ddBtn.Parent = ddFrame
            
            local itemsFrame = Instance.new("Frame")
            itemsFrame.Size = UDim2.new(1, -8, 0, 0)
            itemsFrame.Position = UDim2.new(0, 4, 1, 2)
            itemsFrame.BackgroundTransparency = 1
            itemsFrame.ZIndex = 8
            itemsFrame.Parent = ddFrame
            
            local itemsList = Instance.new("UIListLayout")
            itemsList.SortOrder = Enum.SortOrder.LayoutOrder
            itemsList.Parent = itemsFrame
            
            local open = false
            ddBtn.MouseButton1Click:Connect(function()
                open = not open
                local itemCount = 0
                for _, child in pairs(itemsFrame:GetChildren()) do
                    if child:IsA("TextButton") then itemCount = itemCount + 1 end
                end
                local len = itemCount * 30
                if open then
                    dropdown_open = true
                    Resize(ddFrame, {Size = UDim2.new(1, -4, 0, 40 + len)}, 0.2)
                    Resize(itemsFrame, {Size = UDim2.new(1, -8, 0, len)}, 0.2)
                else
                    dropdown_open = false
                    Resize(ddFrame, {Size = UDim2.new(1, -4, 0, 36)}, 0.2)
                    Resize(itemsFrame, {Size = UDim2.new(1, -8, 0, 0)}, 0.2)
                end
            end)
            
            function dropdown_data:Add(n)
                n = tostring(n or "New Object")
                local itemBtn = Instance.new("TextButton")
                itemBtn.Size = UDim2.new(1, 0, 0, 28)
                itemBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                itemBtn.BackgroundTransparency = 0.9
                itemBtn.BorderSizePixel = 0
                itemBtn.Font = Enum.Font.GothamSemibold
                itemBtn.Text = n
                itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                itemBtn.TextSize = 12
                itemBtn.TextXAlignment = Enum.TextXAlignment.Left
                itemBtn.ZIndex = 9
                itemBtn.Parent = itemsFrame
                Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 6)
                
                itemBtn.MouseButton1Click:Connect(function()
                    ddBtn.Text = "  [ " .. n .. " ]  ▼"
                    dropdown_open = false
                    open = false
                    Resize(ddFrame, {Size = UDim2.new(1, -4, 0, 36)}, 0.2)
                    Resize(itemsFrame, {Size = UDim2.new(1, -8, 0, 0)}, 0.2)
                    pcall(callback, n)
                end)
                
                if open then
                    local itemCount = 0
                    for _, child in pairs(itemsFrame:GetChildren()) do
                        if child:IsA("TextButton") then itemCount = itemCount + 1 end
                    end
                    local len = itemCount * 30
                    Resize(ddFrame, {Size = UDim2.new(1, -4, 0, 40 + len)}, 0.2)
                    Resize(itemsFrame, {Size = UDim2.new(1, -8, 0, len)}, 0.2)
                end
                
                local object_data = {}
                function object_data:Remove()
                    itemBtn:Destroy()
                    if open then
                        local itemCount = 0
                        for _, child in pairs(itemsFrame:GetChildren()) do
                            if child:IsA("TextButton") then itemCount = itemCount + 1 end
                        end
                        local len = itemCount * 30
                        Resize(ddFrame, {Size = UDim2.new(1, -4, 0, 40 + len)}, 0.2)
                        Resize(itemsFrame, {Size = UDim2.new(1, -8, 0, len)}, 0.2)
                    end
                end
                
                return itemBtn, object_data
            end
            
            return dropdown_data, ddFrame
        end
        
        function tab_data:AddColorPicker(callback)
            local color_picker_data = {}
            callback = typeof(callback) == "function" and callback or function() end
            
            local cpFrame = CreateElementFrame("ColorPicker", tabScroll, UDim2.new(1, -4, 0, 145), 6)
            
            -- Palette
            local palette = Instance.new("ImageLabel")
            palette.Name = "Palette"
            palette.Size = UDim2.new(0, 100, 0, 100)
            palette.Position = UDim2.new(0, 8, 0, 22)
            palette.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            palette.BackgroundTransparency = 0.3
            palette.Image = "rbxassetid://698052001"
            palette.ScaleType = Enum.ScaleType.Stretch
            palette.ZIndex = 7
            palette.Parent = cpFrame
            Instance.new("UICorner", palette).CornerRadius = UDim.new(0, 8)
            
            -- Saturation bar
            local saturationBar = Instance.new("ImageLabel")
            saturationBar.Name = "Saturation"
            saturationBar.Size = UDim2.new(0, 16, 0, 100)
            saturationBar.Position = UDim2.new(0, 118, 0, 22)
            saturationBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            saturationBar.Image = "rbxassetid://3641079629"
            saturationBar.ScaleType = Enum.ScaleType.Stretch
            saturationBar.ZIndex = 7
            saturationBar.Parent = cpFrame
            Instance.new("UICorner", saturationBar).CornerRadius = UDim.new(0, 4)
            
            -- Color sample
            local sample = Instance.new("Frame")
            sample.Name = "Sample"
            sample.Size = UDim2.new(0, 32, 0, 32)
            sample.Position = UDim2.new(0, 145, 0, 22)
            sample.BorderSizePixel = 0
            sample.ZIndex = 7
            sample.Parent = cpFrame
            Instance.new("UICorner", sample).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", sample).Color = Color3.fromRGB(255, 255, 255)
            sample.UIStroke.Transparency = 0.3
            
            local h, s, v = 0, 1, 1
            
            local function update()
                local color = Color3.fromHSV(h, s, v)
                sample.BackgroundColor3 = color
                saturationBar.ImageColor3 = Color3.fromHSV(h, 1, 1)
                pcall(callback, color)
            end
            
            -- Palette interaction
            palette.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local connection
                    connection = RS.Heartbeat:Connect(function()
                        if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            connection:Disconnect()
                            return
                        end
                        local mouseLoc = gMouse()
                        local relX = math.clamp((mouseLoc.X - palette.AbsolutePosition.X) / palette.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((mouseLoc.Y - palette.AbsolutePosition.Y) / palette.AbsoluteSize.Y, 0, 1)
                        h = relX
                        s = 1 - relY
                        update()
                    end)
                end
            end)
            
            -- Saturation interaction
            saturationBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local connection
                    connection = RS.Heartbeat:Connect(function()
                        if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            connection:Disconnect()
                            return
                        end
                        local mouseLoc = gMouse()
                        local relY = math.clamp((mouseLoc.Y - saturationBar.AbsolutePosition.Y) / saturationBar.AbsoluteSize.Y, 0, 1)
                        v = 1 - relY
                        update()
                    end)
                end
            end)
            
            function color_picker_data:Set(color)
                color = typeof(color) == "Color3" and color or Color3.new(1, 1, 1)
                h, s, v = rgbtohsv(color.r * 255, color.g * 255, color.b * 255)
                sample.BackgroundColor3 = color
                saturationBar.ImageColor3 = Color3.fromHSV(h, 1, 1)
                pcall(callback, color)
            end
            
            update()
            return color_picker_data, cpFrame
        end
        
        function tab_data:AddConsole(console_options)
            local console_data = {}
            console_options = typeof(console_options) == "table" and console_options or {}
            console_options = {
                ["y"] = tonumber(console_options.y) or 200,
                ["source"] = console_options.source or "Logs",
                ["readonly"] = ((console_options.readonly) == true),
            }
            
            local consoleFrame = CreateElementFrame("Console", tabScroll, UDim2.new(1, -4, 0, console_options.y), 6)
            
            local sf = Instance.new("ScrollingFrame")
            sf.Size = UDim2.new(1, -8, 1, -8)
            sf.Position = UDim2.new(0, 4, 0, 4)
            sf.BackgroundTransparency = 1
            sf.BorderSizePixel = 0
            sf.ScrollBarThickness = 4
            sf.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
            sf.ScrollBarImageTransparency = 0.5
            sf.CanvasSize = UDim2.new(0, 0, 0, 0)
            sf.ZIndex = 7
            sf.Parent = consoleFrame
            
            local source = Instance.new("TextBox")
            source.Name = "Source"
            source.Size = UDim2.new(1, 0, 0, 10000)
            source.BackgroundTransparency = 1
            source.Font = Enum.Font.Code
            source.MultiLine = true
            source.Text = ""
            source.TextColor3 = Color3.fromRGB(255, 255, 255)
            source.TextSize = 13
            source.TextXAlignment = Enum.TextXAlignment.Left
            source.TextYAlignment = Enum.TextYAlignment.Top
            source.TextEditable = not console_options.readonly
            source.ClearTextOnFocus = false
            source.ZIndex = 8
            source.Parent = sf
            
            source:GetPropertyChangedSignal("Text"):Connect(function()
                local lineCount = #source.Text:split("\n")
                sf.CanvasSize = UDim2.new(0, 0, 0, math.max(lineCount * 16, console_options.y))
            end)
            
            function console_data:Set(code)
                source.Text = tostring(code)
            end
            
            function console_data:Get()
                return source.Text
            end
            
            function console_data:Log(msg)
                source.Text = source.Text .. "[*] " .. tostring(msg) .. "\n"
                local lineCount = #source.Text:split("\n")
                sf.CanvasSize = UDim2.new(0, 0, 0, math.max(lineCount * 16, console_options.y))
                sf.CanvasPosition = Vector2.new(0, sf.CanvasSize.Y.Offset)
            end
            
            return console_data, consoleFrame
        end
        
        function tab_data:AddFolder(folder_name)
            local folder_data = {}
            folder_name = tostring(folder_name or "New Folder")
            
            local folderFrame = CreateElementFrame("Folder_" .. folder_name, tabScroll, UDim2.new(1, -4, 0, 40), 6)
            folderFrame.ClipsDescendants = true
            
            local headerBtn = Instance.new("TextButton")
            headerBtn.Size = UDim2.new(1, 0, 0, 40)
            headerBtn.BackgroundTransparency = 1
            headerBtn.Font = Enum.Font.GothamBold
            headerBtn.Text = "  ▶ " .. folder_name
            headerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            headerBtn.TextSize = 13
            headerBtn.TextXAlignment = Enum.TextXAlignment.Left
            headerBtn.ZIndex = 7
            headerBtn.Parent = folderFrame
            
            local contentFrame = Instance.new("Frame")
            contentFrame.Size = UDim2.new(1, -10, 0, 0)
            contentFrame.Position = UDim2.new(0, 8, 1, 2)
            contentFrame.BackgroundTransparency = 1
            contentFrame.ZIndex = 7
            contentFrame.Parent = folderFrame
            
            local contentList = Instance.new("UIListLayout")
            contentList.SortOrder = Enum.SortOrder.LayoutOrder
            contentList.Padding = UDim.new(0, 5)
            contentList.Parent = contentFrame
            
            local open = false
            headerBtn.MouseButton1Click:Connect(function()
                open = not open
                headerBtn.Text = (open and "  ▼ " or "  ▶ ") .. folder_name
                
                local len = 0
                for _, child in pairs(contentFrame:GetChildren()) do
                    if child:IsA("Frame") then len = len + child.AbsoluteSize.Y + 5 end
                end
                
                if open then
                    Resize(folderFrame, {Size = UDim2.new(1, -4, 0, 45 + len)}, 0.2)
                    Resize(contentFrame, {Size = UDim2.new(1, -10, 0, len)}, 0.2)
                else
                    Resize(folderFrame, {Size = UDim2.new(1, -4, 0, 40)}, 0.2)
                    Resize(contentFrame, {Size = UDim2.new(1, -10, 0, 0)}, 0.2)
                end
            end)
            
            -- Clone all tab_data functions but parent to contentFrame
            for funcName, func in pairs(tab_data) do
                if funcName ~= "Show" and typeof(func) == "function" then
                    folder_data[funcName] = function(...)
                        local results = {func(...)}
                        if #results >= 2 then
                            local data, object = results[1], results[2]
                            if object and object:IsA("Instance") then
                                object.Parent = contentFrame
                            end
                            return data, object
                        elseif #results == 1 and results[1] and results[1]:IsA("Instance") then
                            results[1].Parent = contentFrame
                            return results[1]
                        end
                        return unpack(results)
                    end
                end
            end
            
            return folder_data, folderFrame
        end
        
        function tab_data:AddHorizontalAlignment()
            local ha_data = {}
            
            local haFrame = CreateElementFrame("HALayout", tabScroll, UDim2.new(1, -4, 0, 40), 6)
            
            local haList = Instance.new("UIListLayout")
            haList.FillDirection = Enum.FillDirection.Horizontal
            haList.SortOrder = Enum.SortOrder.LayoutOrder
            haList.Padding = UDim.new(0, 8)
            haList.Parent = haFrame
            
            function ha_data:AddButton(...)
                local data, object
                local ret = {tab_data:AddButton(...)}
                if typeof(ret[1]) == "table" and ret[2] then
                    data = ret[1]
                    object = ret[2]
                    object.Parent = haFrame
                    object.Size = UDim2.new(0, 100, 1, 0)
                    return data, object
                elseif ret[1] then
                    object = ret[1]
                    object.Parent = haFrame
                    object.Size = UDim2.new(0, 100, 1, 0)
                    return object
                end
            end
            
            return ha_data, haFrame
        end
        
        -- Show first tab automatically
        if not currentTab then
            show()
        end
        
        table.insert(tabs, tabFrame)
        return tab_data, tabFrame
    end
    
    table.insert(windows, window_data)
    return window_data, MainPanel.Frame
end

function library:FormatWindows()
    -- No-op for this design
end

return library
