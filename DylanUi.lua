--[[
    Custom Styled UI Library - Complete Version with Scrolling
    Exact UI replication with all original functionality preserved
--]]

local ui_options = {
    main_color = Color3.fromRGB(41, 74, 122),
    min_size = Vector2.new(400, 300),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true,
}

do
    local imgui = game:GetService("CoreGui"):FindFirstChild("imgui")
    if imgui then imgui:Destroy() end
end

local imgui = Instance.new("ScreenGui")
local prefabs = Instance.new("Frame")

-- Create all original prefabs (kept for the Circle ripple effect)
local circle = Instance.new("ImageLabel")
local cloneref = cloneref and cloneref or function(...) return ... end
local CoreGui = cloneref(game:GetService("CoreGui"))

imgui.Name = "imgui"
imgui.Parent = gethui and gethui() or (CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui"))

prefabs.Name = "Prefabs"
prefabs.Parent = imgui
prefabs.BackgroundColor3 = Color3.new(1, 1, 1)
prefabs.Size = UDim2.new(0, 100, 0, 100)
prefabs.Visible = false

circle.Name = "Circle"
circle.Parent = prefabs
circle.BackgroundColor3 = Color3.new(1, 1, 1)
circle.BackgroundTransparency = 1
circle.Image = "rbxassetid://266543268"
circle.ImageTransparency = 0.5

--[[ Script ]]--
local root = imgui
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("RunService")
local ps = game:GetService("Players")
local p = ps.LocalPlayer
local mouse = p:GetMouse()
local Prefabs = prefabs
local Windows = Instance.new("Frame")
Windows.Name = "Windows"
Windows.BackgroundColor3 = Color3.new(1, 1, 1)
Windows.BackgroundTransparency = 1
Windows.Size = UDim2.new(1, 0, 1, 0)
Windows.Parent = imgui

local checks = {
    ["binding"] = false,
}

UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == ((typeof(ui_options.toggle_key) == "EnumItem") and ui_options.toggle_key or Enum.KeyCode.RightShift) then
        if root then
            if not checks.binding and root.Enabled ~= nil then
                root.Enabled = not root.Enabled
            end
        end
    end
end)

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
    if max == 0 then
        s = 0
    else
        s = d / max
    end
    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / d
            if g < b then
                h = h + 6
            end
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, v
end

local function hasprop(object, prop)
    local a, b = pcall(function()
        return object[tostring(prop)]
    end)
    if a then
        return b
    end
end

local function gNameLen(obj)
    return obj.TextBounds.X + 15
end

local function gMouse()
    return Vector2.new(UIS:GetMouseLocation().X + 1, UIS:GetMouseLocation().Y - 35)
end

local function ripple(button, x, y)
    spawn(function()
        button.ClipsDescendants = true
        local circle = prefabs:FindFirstChild("Circle"):Clone()
        circle.Parent = button
        circle.ZIndex = 1000
        local new_x = x - circle.AbsolutePosition.X
        local new_y = y - circle.AbsolutePosition.Y
        circle.Position = UDim2.new(0, new_x, 0, new_y)
        local size = 0
        if button.AbsoluteSize.X > button.AbsoluteSize.Y then
            size = button.AbsoluteSize.X * 1.5
        elseif button.AbsoluteSize.X < button.AbsoluteSize.Y then
            size = button.AbsoluteSize.Y * 1.5
        elseif button.AbsoluteSize.X == button.AbsoluteSize.Y then
            size = button.AbsoluteSize.X * 1.5
        end
        circle:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size / 2, 0.5, -size / 2), "Out", "Quad", 0.5, false, nil)
        Resize(circle, {ImageTransparency = 1}, 0.5)
        wait(0.5)
        circle:Destroy()
    end)
end

-- Helper function to create panels EXACTLY like your design
local function CreatePanel(name, anchorPos, size, cornerRadius, zIndex, parent)
    local panel = {}
    
    -- Shadow
    panel.Shadow = Instance.new("Frame")
    panel.Shadow.Name = name .. "Shadow"
    panel.Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Shadow.Position = anchorPos + UDim2.new(0, 0, 0, 8)
    panel.Shadow.Size = size
    panel.Shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    panel.Shadow.BackgroundTransparency = 0.5
    panel.Shadow.BorderSizePixel = 0
    panel.Shadow.ZIndex = zIndex or 0
    panel.Shadow.Parent = parent
    Instance.new("UICorner", panel.Shadow).CornerRadius = UDim.new(0, cornerRadius or 20)

    -- Main frame
    panel.Frame = Instance.new("Frame")
    panel.Frame.Name = name
    panel.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Frame.Position = anchorPos
    panel.Frame.Size = size
    panel.Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    panel.Frame.BackgroundTransparency = 0.15
    panel.Frame.BorderSizePixel = 0
    panel.Frame.ClipsDescendants = true -- Important for scrolling
    panel.Frame.Parent = parent
    Instance.new("UICorner", panel.Frame).CornerRadius = UDim.new(0, cornerRadius or 20)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = panel.Frame

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176,96,244)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236,198,255))
    }
    gradient.Parent = panel.Frame

    local marble = Instance.new("ImageLabel")
    marble.Name = "MarbleTexture"
    marble.Size = UDim2.fromScale(1,1)
    marble.BackgroundTransparency = 1
    marble.BorderSizePixel = 0
    marble.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
    marble.ImageTransparency = 0.6
    marble.ScaleType = Enum.ScaleType.Stretch
    marble.Parent = panel.Frame
    Instance.new("UICorner", marble).CornerRadius = UDim.new(0, cornerRadius or 20)

    return panel
end

local windows = 0
local library = {}

local function format_windows()
    -- Not needed for custom layout
end

function library:FormatWindows()
    format_windows()
end

function library:AddWindow(title, options)
    windows = windows + 1
    local dropdown_open = false
    title = tostring(title or "New Window")
    options = (typeof(options) == "table") and options or ui_options
    options.tween_time = 0.1
    
    -- LAYOUT PARAMETERS
    local MainWidth = 0.40
    local MainHeight = 0.75
    local SideWidth = 0.15
    local SideHeight = 0.75
    local Gap = 0.025
    
    -- Main panel (centre)
    local MainSize = UDim2.fromScale(MainWidth, MainHeight)
    local MainPos = UDim2.fromScale(0.5, 0.54)
    local MainPanel = CreatePanel("Main" .. windows, MainPos, MainSize, 20, 1, Windows)
    
    -- Side panel (left of Main)
    local SideX = (0.5 - MainWidth/2) - Gap - SideWidth/2
    local SidePos = UDim2.new(SideX, 0, 0.54, 0)
    local SideSize = UDim2.fromScale(SideWidth, SideHeight)
    local SidePanel = CreatePanel("Side" .. windows, SidePos, SideSize, 20, 1, Windows)
    
    -- HEADER (only on the main panel)
    local HeaderShadow = Instance.new("Frame")
    HeaderShadow.Name = "HeaderShadow"
    HeaderShadow.AnchorPoint = Vector2.new(0.5, 0)
    HeaderShadow.Position = UDim2.new(0.5, 2, -0.04, 4)
    HeaderShadow.Size = UDim2.fromScale(0.5, 0.09)
    HeaderShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    HeaderShadow.BackgroundTransparency = 0.4
    HeaderShadow.BorderSizePixel = 0
    HeaderShadow.ZIndex = 0
    HeaderShadow.Parent = MainPanel.Frame
    Instance.new("UICorner", HeaderShadow).CornerRadius = UDim.new(0, 18)
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.AnchorPoint = Vector2.new(0.5,0)
    Header.Position = UDim2.new(0.5,0,-0.04,0)
    Header.Size = UDim2.fromScale(0.5,0.09)
    Header.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Header.BorderSizePixel = 0
    Header.Parent = MainPanel.Frame
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0,18)
    
    local HeaderGradient = MainPanel.Frame:FindFirstChildWhichIsA("UIGradient"):Clone()
    HeaderGradient.Parent = Header
    
    local HeaderMarble = Instance.new("ImageLabel")
    HeaderMarble.Size = UDim2.fromScale(1,1)
    HeaderMarble.BackgroundTransparency = 1
    HeaderMarble.BorderSizePixel = 0
    HeaderMarble.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
    HeaderMarble.ImageTransparency = 0.6
    HeaderMarble.ScaleType = Enum.ScaleType.Stretch
    HeaderMarble.Parent = Header
    Instance.new("UICorner", HeaderMarble).CornerRadius = UDim.new(0, 18)
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.AnchorPoint = Vector2.new(0.5,0.5)
    Title.Position = UDim2.fromScale(0.5,0.5)
    Title.Size = UDim2.fromScale(0.7,0.8)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.Bangers
    Title.Text = title
    Title.TextScaled = true
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Parent = Header
    
    -- CLOSE/MINIMIZE BUTTON
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseButton.Position = UDim2.new(1, -5, 0, 0)
    CloseButton.Size = UDim2.fromOffset(56, 56)
    CloseButton.BackgroundTransparency = 1
    CloseButton.BorderSizePixel = 0
    CloseButton.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114840795551292&width=678&height=810&format=png"
    CloseButton.ScaleType = Enum.ScaleType.Fit
    CloseButton.ZIndex = 10
    CloseButton.Parent = MainPanel.Frame
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)
    
    CloseButton.MouseEnter:Connect(function()
        CloseButton:TweenSize(UDim2.fromOffset(62, 62), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)
    CloseButton.MouseLeave:Connect(function()
        CloseButton:TweenSize(UDim2.fromOffset(56, 56), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)
    
    -- MINIMIZED STATE
    local MinimizedFrame = Instance.new("ImageButton")
    MinimizedFrame.Name = "MinimizedFrame" .. windows
    MinimizedFrame.AnchorPoint = Vector2.new(1, 0)
    MinimizedFrame.Position = UDim2.new(1, -20, 0, 20)
    MinimizedFrame.Size = UDim2.fromOffset(60, 60)
    MinimizedFrame.BackgroundTransparency = 1
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Visible = false
    MinimizedFrame.ZIndex = 100
    MinimizedFrame.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=103591022804634&width=678&height=810&format=png"
    MinimizedFrame.ScaleType = Enum.ScaleType.Fit
    MinimizedFrame.Parent = imgui
    Instance.new("UICorner", MinimizedFrame).CornerRadius = UDim.new(1, 0)
    
    local MinimizedStroke = Instance.new("UIStroke")
    MinimizedStroke.Color = Color3.fromRGB(255,255,255)
    MinimizedStroke.Thickness = 2
    MinimizedStroke.Transparency = 0.3
    MinimizedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MinimizedStroke.Parent = MinimizedFrame
    
    -- SCROLLABLE MAIN CONTENT AREA
    local MainScrollFrame = Instance.new("ScrollingFrame")
    MainScrollFrame.Name = "MainScroll"
    MainScrollFrame.Size = UDim2.new(1, -20, 1, -50)
    MainScrollFrame.Position = UDim2.new(0, 10, 0, 40)
    MainScrollFrame.BackgroundTransparency = 1
    MainScrollFrame.BorderSizePixel = 0
    MainScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    MainScrollFrame.ScrollBarThickness = 4
    MainScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    MainScrollFrame.ScrollBarImageTransparency = 0.5
    MainScrollFrame.Parent = MainPanel.Frame
    
    -- Container for tabs inside scroll frame
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, 0, 0, 0) -- Will auto-size based on content
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.BorderSizePixel = 0
    TabsContainer.Parent = MainScrollFrame
    
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 0)
    TabsLayout.Parent = TabsContainer
    
    -- Auto-size the container and canvas
    TabsContainer.Changed:Connect(function()
        local totalHeight = 0
        for _, child in pairs(TabsContainer:GetChildren()) do
            if child:IsA("Frame") and child.Visible then
                totalHeight = totalHeight + child.AbsoluteSize.Y
            end
        end
        MainScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 10)
    end)
    
    -- SCROLLABLE SIDE PANEL FOR TABS
    local SideScrollFrame = Instance.new("ScrollingFrame")
    SideScrollFrame.Name = "SideScroll"
    SideScrollFrame.Size = UDim2.new(1, -10, 1, -20)
    SideScrollFrame.Position = UDim2.new(0, 5, 0, 10)
    SideScrollFrame.BackgroundTransparency = 1
    SideScrollFrame.BorderSizePixel = 0
    SideScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    SideScrollFrame.ScrollBarThickness = 4
    SideScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    SideScrollFrame.ScrollBarImageTransparency = 0.5
    SideScrollFrame.Parent = SidePanel.Frame
    
    local TabButtonsContainer = Instance.new("Frame")
    TabButtonsContainer.Name = "TabButtonsContainer"
    TabButtonsContainer.Size = UDim2.new(1, 0, 0, 0) -- Will auto-size
    TabButtonsContainer.BackgroundTransparency = 1
    TabButtonsContainer.BorderSizePixel = 0
    TabButtonsContainer.Parent = SideScrollFrame
    
    local TabButtonsList = Instance.new("UIListLayout")
    TabButtonsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsList.Padding = UDim.new(0, 8)
    TabButtonsList.Parent = TabButtonsContainer
    
    -- Auto-size the side container and canvas
    TabButtonsContainer.Changed:Connect(function()
        local totalHeight = 0
        for _, child in pairs(TabButtonsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                totalHeight = totalHeight + child.AbsoluteSize.Y + 8 -- Include padding
            end
        end
        TabButtonsContainer.Size = UDim2.new(1, 0, 0, totalHeight)
        SideScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 10)
    end)
    
    -- Minimize/Restore functionality
    local isMinimized = false
    
    MinimizedFrame.MouseButton1Click:Connect(function()
        MinimizedFrame.Visible = false
        MainPanel.Frame.Visible = true
        MainPanel.Shadow.Visible = true
        SidePanel.Frame.Visible = true
        SidePanel.Shadow.Visible = true
        
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(MainPanel.Frame, tweenInfo, {Size = MainSize, Position = MainPos}):Play()
        TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = MainSize, Position = MainPos + UDim2.new(0,0,0,8)}):Play()
        TweenService:Create(SidePanel.Frame, tweenInfo, {Size = SideSize, Position = SidePos}):Play()
        TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = SideSize, Position = SidePos + UDim2.new(0,0,0,8)}):Play()
        isMinimized = false
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        if not isMinimized then
            local targetPos = UDim2.new(1, -40, 0, 40)
            local targetSize = UDim2.fromScale(0.05, 0.05)
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            
            TweenService:Create(MainPanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
            TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0,0,0,8)}):Play()
            TweenService:Create(SidePanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0,0,0,0)}):Play()
            TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0,0,0,8)}):Play()
            
            task.wait(0.3)
            MainPanel.Frame.Visible = false
            MainPanel.Shadow.Visible = false
            SidePanel.Frame.Visible = false
            SidePanel.Shadow.Visible = false
            
            MinimizedFrame.Visible = true
            MinimizedFrame.Size = UDim2.fromOffset(0,0)
            MinimizedFrame:TweenSize(UDim2.fromOffset(60,60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
            isMinimized = true
        end
    end)
    
    local window_data = {}
    
    do -- UI Elements (ALL ORIGINAL LOGIC PRESERVED)
        do -- Add Tab
            function window_data:AddTab(tab_name)
                local tab_data = {}
                tab_name = tostring(tab_name or "New Tab")
                
                -- Create tab button in side panel
                local new_button = Instance.new("TextButton")
                new_button.Name = "TabButton_" .. tab_name
                new_button.Size = UDim2.new(1, 0, 0, 40)
                new_button.BackgroundTransparency = 0.85
                new_button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                new_button.BorderSizePixel = 0
                new_button.Font = Enum.Font.GothamBold
                new_button.Text = tab_name
                new_button.TextColor3 = Color3.fromRGB(255, 255, 255)
                new_button.TextSize = 13
                new_button.TextWrapped = true
                new_button.Parent = TabButtonsContainer
                Instance.new("UICorner", new_button).CornerRadius = UDim.new(0, 12)
                
                -- Create tab content in main panel (inside scrollable area)
                local new_tab = Instance.new("Frame")
                new_tab.Name = "Tab_" .. tab_name
                new_tab.Size = UDim2.new(1, 0, 0, 0) -- Will auto-size
                new_tab.BackgroundTransparency = 1
                new_tab.BorderSizePixel = 0
                new_tab.Visible = false
                new_tab.Parent = TabsContainer
                
                -- Container with UIListLayout for tab elements
                local tabContentLayout = Instance.new("UIListLayout")
                tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                tabContentLayout.Padding = UDim.new(0, 8)
                tabContentLayout.Parent = new_tab
                
                -- Auto-resize tab based on content
                local function updateTabSize()
                    local totalHeight = 0
                    for _, child in pairs(new_tab:GetChildren()) do
                        if not child:IsA("UIListLayout") then
                            totalHeight = totalHeight + child.AbsoluteSize.Y + 8
                        end
                    end
                    new_tab.Size = UDim2.new(1, 0, 0, totalHeight > 0 and totalHeight or 10)
                end
                
                new_tab.ChildAdded:Connect(updateTabSize)
                new_tab.ChildRemoved:Connect(function()
                    task.wait(0.1)
                    updateTabSize()
                end)
                
                local function show()
                    if dropdown_open then return end
                    for i, v in pairs(TabButtonsContainer:GetChildren()) do
                        if v:IsA("TextButton") then
                            v.BackgroundTransparency = 0.85
                        end
                    end
                    for i, v in pairs(TabsContainer:GetChildren()) do
                        if v:IsA("Frame") and v ~= new_tab then
                            v.Visible = false
                        end
                    end
                    new_button.BackgroundTransparency = 0.5
                    new_tab.Visible = true
                    updateTabSize()
                end
                
                new_button.MouseButton1Click:Connect(function()
                    show()
                end)
                
                function tab_data:Show()
                    show()
                end
                
                -- TAB ELEMENT FUNCTIONS
                function tab_data:AddLabel(label_text)
                    label_text = tostring(label_text or "New Label")
                    local label = Instance.new("TextLabel")
                    label.BackgroundColor3 = Color3.new(1, 1, 1)
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 0, 25)
                    label.Font = Enum.Font.GothamSemibold
                    label.Text = label_text
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.TextSize = 14
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Parent = new_tab
                    updateTabSize()
                    return label
                end
                
                function tab_data:AddButton(button_text, callback)
                    button_text = tostring(button_text or "New Button")
                    callback = typeof(callback) == "function" and callback or function()end
                    
                    local button = Instance.new("TextButton")
                    button.Size = UDim2.new(1, 0, 0, 35)
                    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    button.BackgroundTransparency = 0.8
                    button.BorderSizePixel = 0
                    button.Font = Enum.Font.GothamBold
                    button.Text = button_text
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    button.TextSize = 14
                    button.Parent = new_tab
                    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
                    
                    local btnGradient = Instance.new("UIGradient")
                    btnGradient.Rotation = 90
                    btnGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(176,96,244))
                    }
                    btnGradient.Parent = button
                    
                    button.MouseButton1Click:Connect(function()
                        ripple(button, mouse.X, mouse.Y)
                        pcall(callback)
                    end)
                    updateTabSize()
                    return button
                end
                
                function tab_data:AddSwitch(switch_text, callback)
                    local switch_data = {}
                    switch_text = tostring(switch_text or "New Switch")
                    callback = typeof(callback) == "function" and callback or function()end
                    
                    local switchFrame = Instance.new("Frame")
                    switchFrame.Size = UDim2.new(1, 0, 0, 35)
                    switchFrame.BackgroundTransparency = 1
                    switchFrame.BorderSizePixel = 0
                    switchFrame.Parent = new_tab
                    
                    local switchButton = Instance.new("TextButton")
                    switchButton.Size = UDim2.new(0, 30, 0, 30)
                    switchButton.Position = UDim2.new(0, 5, 0.5, -15)
                    switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    switchButton.BackgroundTransparency = 0.7
                    switchButton.BorderSizePixel = 0
                    switchButton.Font = Enum.Font.SourceSans
                    switchButton.Text = ""
                    switchButton.TextColor3 = Color3.new(1, 1, 1)
                    switchButton.TextSize = 18
                    switchButton.Parent = switchFrame
                    Instance.new("UICorner", switchButton).CornerRadius = UDim.new(0, 8)
                    
                    local switchGradient = Instance.new("UIGradient")
                    switchGradient.Rotation = 90
                    switchGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(176,96,244))
                    }
                    switchGradient.Transparency = NumberSequence.new(0.5)
                    switchGradient.Parent = switchButton
                    
                    local titleLabel = Instance.new("TextLabel")
                    titleLabel.Size = UDim2.new(1, -45, 1, 0)
                    titleLabel.Position = UDim2.new(0, 40, 0, 0)
                    titleLabel.BackgroundTransparency = 1
                    titleLabel.Font = Enum.Font.GothamSemibold
                    titleLabel.Text = switch_text
                    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    titleLabel.TextSize = 14
                    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                    titleLabel.Parent = switchFrame
                    
                    local toggled = false
                    switchButton.MouseButton1Click:Connect(function()
                        toggled = not toggled
                        switchButton.Text = toggled and utf8.char(10003) or ""
                        switchGradient.Transparency = toggled and NumberSequence.new(0) or NumberSequence.new(0.5)
                        pcall(callback, toggled)
                    end)
                    
                    function switch_data:Set(bool)
                        toggled = (typeof(bool) == "boolean") and bool or false
                        switchButton.Text = toggled and utf8.char(10003) or ""
                        switchGradient.Transparency = toggled and NumberSequence.new(0) or NumberSequence.new(0.5)
                        pcall(callback, toggled)
                    end
                    updateTabSize()
                    return switch_data, switchFrame
                end
                
                function tab_data:AddTextBox(textbox_text, callback, textbox_options)
                    textbox_text = tostring(textbox_text or "New TextBox")
                    callback = typeof(callback) == "function" and callback or function()end
                    textbox_options = typeof(textbox_options) == "table" and textbox_options or {["clear"] = true}
                    textbox_options = {
                        ["clear"] = ((textbox_options.clear) == true)
                    }
                    
                    local textbox = Instance.new("TextBox")
                    textbox.Size = UDim2.new(1, 0, 0, 35)
                    textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    textbox.BackgroundTransparency = 0.8
                    textbox.BorderSizePixel = 0
                    textbox.Font = Enum.Font.GothamSemibold
                    textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
                    textbox.PlaceholderText = textbox_text
                    textbox.Text = ""
                    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    textbox.TextSize = 14
                    textbox.Parent = new_tab
                    Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 10)
                    
                    textbox.FocusLost:Connect(function(ep)
                        if ep then
                            if #textbox.Text > 0 then
                                pcall(callback, textbox.Text)
                                if textbox_options.clear then
                                    textbox.Text = ""
                                end
                            end
                        end
                    end)
                    updateTabSize()
                    return textbox
                end
                
                function tab_data:AddSlider(slider_text, callback, slider_options)
                    local slider_data = {}
                    slider_text = tostring(slider_text or "New Slider")
                    callback = typeof(callback) == "function" and callback or function()end
                    slider_options = typeof(slider_options) == "table" and slider_options or {}
                    slider_options = {
                        ["min"] = slider_options.min or 0,
                        ["max"] = slider_options.max or 100,
                        ["readonly"] = slider_options.readonly or false,
                    }
                    
                    local slider = Instance.new("Frame")
                    slider.Size = UDim2.new(1, 0, 0, 50)
                    slider.BackgroundTransparency = 1
                    slider.BorderSizePixel = 0
                    slider.Parent = new_tab
                    
                    local title = Instance.new("TextLabel")
                    title.Size = UDim2.new(1, 0, 0, 15)
                    title.BackgroundTransparency = 1
                    title.Font = Enum.Font.GothamBold
                    title.Text = slider_text
                    title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    title.TextSize = 12
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    title.Parent = slider
                    
                    local sliderBg = Instance.new("Frame")
                    sliderBg.Size = UDim2.new(1, -50, 0, 15)
                    sliderBg.Position = UDim2.new(0, 0, 0, 20)
                    sliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    sliderBg.BackgroundTransparency = 0.8
                    sliderBg.BorderSizePixel = 0
                    sliderBg.Parent = slider
                    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 7)
                    
                    local indicator = Instance.new("Frame")
                    indicator.Size = UDim2.new(0, 0, 1, 0)
                    indicator.BackgroundColor3 = Color3.fromRGB(110,45,220)
                    indicator.BorderSizePixel = 0
                    indicator.Parent = sliderBg
                    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 7)
                    
                    local value = Instance.new("TextLabel")
                    value.Size = UDim2.new(0, 45, 0, 15)
                    value.Position = UDim2.new(1, -45, 0, 20)
                    value.BackgroundTransparency = 1
                    value.Font = Enum.Font.GothamBold
                    value.Text = "0"
                    value.TextColor3 = Color3.fromRGB(255, 255, 255)
                    value.TextSize = 12
                    value.Parent = slider
                    
                    do -- Slider Math (PRESERVED EXACTLY)
                        local Entered = false
                        sliderBg.MouseEnter:Connect(function()
                            Entered = true
                        end)
                        sliderBg.MouseLeave:Connect(function()
                            Entered = false
                        end)
                        local Held = false
                        UIS.InputBegan:Connect(function(inputObject)
                            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                                Held = true
                                spawn(function()
                                    if Entered and not slider_options.readonly then
                                        while Held and (not dropdown_open) do
                                            local mouse_location = gMouse()
                                            local x = (sliderBg.AbsoluteSize.X - (sliderBg.AbsoluteSize.X - ((mouse_location.X - sliderBg.AbsolutePosition.X)) + 1)) / sliderBg.AbsoluteSize.X
                                            local min = 0
                                            local max = 1
                                            local size = min
                                            if x >= min and x <= max then
                                                size = x
                                            elseif x < min then
                                                size = min
                                            elseif x > max then
                                                size = max
                                            end
                                            Resize(indicator, {Size = UDim2.new(size or min, 0, 1, 0)}, options.tween_time)
                                            local p = math.floor((size or min) * 100)
                                            local maxv = slider_options.max
                                            local minv = slider_options.min
                                            local diff = maxv - minv
                                            local sel_value = math.floor(((diff / 100) * p) + minv)
                                            value.Text = tostring(sel_value)
                                            pcall(callback, sel_value)
                                            RS.Heartbeat:Wait()
                                        end
                                    end
                                end)
                            end
                        end)
                        UIS.InputEnded:Connect(function(inputObject)
                            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                                Held = false
                            end
                        end)
                        function slider_data:Set(new_value)
                            new_value = tonumber(new_value) or 0
                            new_value = (((new_value >= 0 and new_value <= 100) and new_value) / 100)
                            Resize(indicator, {Size = UDim2.new(new_value or 0, 0, 1, 0)}, options.tween_time)
                            local p = math.floor((new_value or 0) * 100)
                            local maxv = slider_options.max
                            local minv = slider_options.min
                            local diff = maxv - minv
                            local sel_value = math.floor(((diff / 100) * p) + minv)
                            value.Text = tostring(sel_value)
                            pcall(callback, sel_value)
                        end
                        slider_data:Set(slider_options["min"])
                    end
                    updateTabSize()
                    return slider_data, slider
                end
                
                function tab_data:AddKeybind(keybind_name, callback, keybind_options)
                    local keybind_data = {}
                    keybind_name = tostring(keybind_name or "New Keybind")
                    callback = typeof(callback) == "function" and callback or function()end
                    keybind_options = typeof(keybind_options) == "table" and keybind_options or {}
                    keybind_options = {
                        ["standard"] = keybind_options.standard or Enum.KeyCode.RightShift,
                    }
                    
                    local keybindFrame = Instance.new("Frame")
                    keybindFrame.Size = UDim2.new(1, 0, 0, 35)
                    keybindFrame.BackgroundTransparency = 1
                    keybindFrame.BorderSizePixel = 0
                    keybindFrame.Parent = new_tab
                    
                    local title = Instance.new("TextLabel")
                    title.Size = UDim2.new(0.5, 0, 1, 0)
                    title.BackgroundTransparency = 1
                    title.Font = Enum.Font.GothamBold
                    title.Text = keybind_name
                    title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    title.TextSize = 14
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    title.Parent = keybindFrame
                    
                    local input = Instance.new("TextButton")
                    input.Size = UDim2.new(0, 80, 1, -4)
                    input.Position = UDim2.new(1, -85, 0, 2)
                    input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    input.BackgroundTransparency = 0.7
                    input.BorderSizePixel = 0
                    input.Font = Enum.Font.GothamSemibold
                    input.Text = "RShift"
                    input.TextColor3 = Color3.fromRGB(255, 255, 255)
                    input.TextSize = 12
                    input.Parent = keybindFrame
                    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)
                    
                    local shortkeys = {
                        RightControl = 'RightCtrl',
                        LeftControl = 'LeftCtrl',
                        LeftShift = 'LShift',
                        RightShift = 'RShift',
                        MouseButton1 = "Mouse1",
                        MouseButton2 = "Mouse2"
                    }
                    local keybind = keybind_options.standard
                    
                    function keybind_data:SetKeybind(Keybind)
                        local key = shortkeys[Keybind.Name] or Keybind.Name
                        input.Text = key
                        keybind = Keybind
                    end
                    
                    UIS.InputBegan:Connect(function(a, b)
                        if checks.binding then
                            spawn(function()
                                wait()
                                checks.binding = false
                            end)
                            return
                        end
                        if a.KeyCode == keybind and not b then
                            pcall(callback, keybind)
                        end
                    end)
                    
                    keybind_data:SetKeybind(keybind_options.standard)
                    
                    input.MouseButton1Click:Connect(function()
                        if checks.binding then return end
                        input.Text = "..."
                        checks.binding = true
                        local a, b = UIS.InputBegan:Wait()
                        keybind_data:SetKeybind(a.KeyCode)
                    end)
                    
                    updateTabSize()
                    return keybind_data, keybindFrame
                end
                
                function tab_data:AddDropdown(dropdown_name, callback)
                    local dropdown_data = {}
                    dropdown_name = tostring(dropdown_name or "New Dropdown")
                    callback = typeof(callback) == "function" and callback or function()end
                    
                    local dropdown = Instance.new("Frame")
                    dropdown.Size = UDim2.new(1, 0, 0, 0) -- Will auto-size
                    dropdown.BackgroundTransparency = 1
                    dropdown.BorderSizePixel = 0
                    dropdown.Parent = new_tab
                    
                    local dropdownButton = Instance.new("TextButton")
                    dropdownButton.Size = UDim2.new(1, 0, 0, 35)
                    dropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    dropdownButton.BackgroundTransparency = 0.8
                    dropdownButton.BorderSizePixel = 0
                    dropdownButton.Font = Enum.Font.GothamBold
                    dropdownButton.Text = " " .. dropdown_name
                    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    dropdownButton.TextSize = 14
                    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                    dropdownButton.Parent = dropdown
                    Instance.new("UICorner", dropdownButton).CornerRadius = UDim.new(0, 10)
                    
                    local indicator = Instance.new("TextLabel")
                    indicator.Size = UDim2.new(0, 20, 1, 0)
                    indicator.Position = UDim2.new(1, -25, 0, 0)
                    indicator.BackgroundTransparency = 1
                    indicator.Font = Enum.Font.GothamBold
                    indicator.Text = "▼"
                    indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
                    indicator.TextSize = 14
                    indicator.Parent = dropdownButton
                    
                    local box = Instance.new("Frame")
                    box.Size = UDim2.new(1, 0, 0, 0)
                    box.Position = UDim2.new(0, 0, 1, 5)
                    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    box.BackgroundTransparency = 0.9
                    box.BorderSizePixel = 0
                    box.ClipsDescendants = true
                    box.Parent = dropdown
                    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
                    
                    local objects = Instance.new("ScrollingFrame")
                    objects.Name = "Objects"
                    objects.Size = UDim2.new(1, 0, 1, 0)
                    objects.BackgroundTransparency = 1
                    objects.BorderSizePixel = 0
                    objects.CanvasSize = UDim2.new(0, 0, 0, 0)
                    objects.ScrollBarThickness = 4
                    objects.Parent = box
                    
                    local objectsLayout = Instance.new("UIListLayout")
                    objectsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    objectsLayout.Parent = objects
                    
                    local open = false
                    dropdownButton.MouseButton1Click:Connect(function()
                        open = not open
                        local len = (#objects:GetChildren() - 1) * 35
                        if #objects:GetChildren() - 1 >= 10 then
                            len = 10 * 35
                            objects.CanvasSize = UDim2.new(0, 0, 0, (#objects:GetChildren() - 1) * 35)
                        end
                        if open then
                            if dropdown_open then return end
                            dropdown_open = true
                            Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                            dropdown.Size = UDim2.new(1, 0, 0, 40 + len)
                            indicator.Text = "▲"
                        else
                            dropdown_open = false
                            Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                            dropdown.Size = UDim2.new(1, 0, 0, 35)
                            indicator.Text = "▼"
                        end
                        updateTabSize()
                    end)
                    
                    function dropdown_data:Add(n)
                        local object_data = {}
                        n = tostring(n or "New Object")
                        
                        local object = Instance.new("TextButton")
                        object.Size = UDim2.new(1, 0, 0, 35)
                        object.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        object.BackgroundTransparency = 0.9
                        object.BorderSizePixel = 0
                        object.Font = Enum.Font.GothamBold
                        object.Text = n
                        object.TextColor3 = Color3.fromRGB(255, 255, 255)
                        object.TextSize = 14
                        object.TextXAlignment = Enum.TextXAlignment.Left
                        object.Parent = objects
                        
                        object.MouseEnter:Connect(function()
                            object.BackgroundTransparency = 0.7
                        end)
                        object.MouseLeave:Connect(function()
                            object.BackgroundTransparency = 0.9
                        end)
                        
                        if open then
                            local len = (#objects:GetChildren() - 1) * 35
                            if #objects:GetChildren() - 1 >= 10 then
                                len = 10 * 35
                                objects.CanvasSize = UDim2.new(0, 0, 0, (#objects:GetChildren() - 1) * 35)
                            end
                            Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                            dropdown.Size = UDim2.new(1, 0, 0, 40 + len)
                        end
                        
                        object.MouseButton1Click:Connect(function()
                            if dropdown_open then
                                dropdownButton.Text = " [ " .. n .. " ]"
                                dropdown_open = false
                                open = false
                                Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                                dropdown.Size = UDim2.new(1, 0, 0, 35)
                                indicator.Text = "▼"
                                pcall(callback, n)
                                updateTabSize()
                            end
                        end)
                        
                        function object_data:Remove()
                            object:Destroy()
                            if open then
                                local len = (#objects:GetChildren() - 1) * 35
                                if #objects:GetChildren() - 1 >= 10 then
                                    len = 10 * 35
                                    objects.CanvasSize = UDim2.new(0, 0, 0, (#objects:GetChildren() - 1) * 35)
                                end
                                Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                                dropdown.Size = UDim2.new(1, 0, 0, 40 + len)
                            end
                            updateTabSize()
                        end
                        updateTabSize()
                        return object, object_data
                    end
                    updateTabSize()
                    return dropdown_data, dropdown
                end
                
                function tab_data:AddColorPicker(callback)
                    local color_picker_data = {}
                    callback = typeof(callback) == "function" and callback or function()end
                    
                    local color_picker = Instance.new("Frame")
                    color_picker.Size = UDim2.new(1, 0, 0, 110)
                    color_picker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    color_picker.BackgroundTransparency = 0.8
                    color_picker.BorderSizePixel = 0
                    color_picker.Parent = new_tab
                    Instance.new("UICorner", color_picker).CornerRadius = UDim.new(0, 10)
                    
                    local palette = Instance.new("ImageLabel")
                    palette.Name = "Palette"
                    palette.Size = UDim2.new(0, 100, 0, 100)
                    palette.Position = UDim2.new(0.05, 0, 0.05, 0)
                    palette.BackgroundColor3 = Color3.new(1, 1, 1)
                    palette.BackgroundTransparency = 1
                    palette.Image = "rbxassetid://698052001"
                    palette.ScaleType = Enum.ScaleType.Slice
                    palette.SliceCenter = Rect.new(4, 4, 4, 4)
                    palette.Parent = color_picker
                    
                    local palette_indicator = Instance.new("ImageLabel")
                    palette_indicator.Name = "Indicator"
                    palette_indicator.Size = UDim2.new(0, 5, 0, 5)
                    palette_indicator.BackgroundColor3 = Color3.new(1, 1, 1)
                    palette_indicator.BackgroundTransparency = 1
                    palette_indicator.ZIndex = 2
                    palette_indicator.Image = "rbxassetid://2851926732"
                    palette_indicator.ImageColor3 = Color3.new(0, 0, 0)
                    palette_indicator.ScaleType = Enum.ScaleType.Slice
                    palette_indicator.SliceCenter = Rect.new(12, 12, 12, 12)
                    palette_indicator.Parent = palette
                    
                    local sample = Instance.new("ImageLabel")
                    sample.Name = "Sample"
                    sample.Size = UDim2.new(0, 25, 0, 25)
                    sample.Position = UDim2.new(0.8, 0, 0.05, 0)
                    sample.BackgroundColor3 = Color3.new(1, 1, 1)
                    sample.BackgroundTransparency = 1
                    sample.Image = "rbxassetid://2851929490"
                    sample.ScaleType = Enum.ScaleType.Slice
                    sample.SliceCenter = Rect.new(4, 4, 4, 4)
                    sample.Parent = color_picker
                    
                    local saturation = Instance.new("ImageLabel")
                    saturation.Name = "Saturation"
                    saturation.Size = UDim2.new(0, 15, 0, 100)
                    saturation.Position = UDim2.new(0.65, 0, 0.05, 0)
                    saturation.BackgroundColor3 = Color3.new(1, 1, 1)
                    saturation.Image = "rbxassetid://3641079629"
                    saturation.Parent = color_picker
                    
                    local saturation_indicator = Instance.new("Frame")
                    saturation_indicator.Name = "Indicator"
                    saturation_indicator.Size = UDim2.new(0, 20, 0, 2)
                    saturation_indicator.BackgroundColor3 = Color3.new(1, 1, 1)
                    saturation_indicator.BorderSizePixel = 0
                    saturation_indicator.ZIndex = 2
                    saturation_indicator.Parent = saturation
                    
                    do -- Color Picker Math (PRESERVED EXACTLY)
                        local h = 0
                        local s = 1
                        local v = 1
                        local function update()
                            local color = Color3.fromHSV(h, s, v)
                            sample.ImageColor3 = color
                            saturation.ImageColor3 = Color3.fromHSV(h, 1, 1)
                            pcall(callback, color)
                        end
                        do
                            local color = Color3.fromHSV(h, s, v)
                            sample.ImageColor3 = color
                            saturation.ImageColor3 = Color3.fromHSV(h, 1, 1)
                        end
                        local Entered1, Entered2 = false, false
                        palette.MouseEnter:Connect(function()
                            Entered1 = true
                        end)
                        palette.MouseLeave:Connect(function()
                            Entered1 = false
                        end)
                        saturation.MouseEnter:Connect(function()
                            Entered2 = true
                        end)
                        saturation.MouseLeave:Connect(function()
                            Entered2 = false
                        end)
                        
                        local Held = false
                        UIS.InputBegan:Connect(function(inputObject)
                            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                                Held = true
                                spawn(function()
                                    while Held and Entered1 and (not dropdown_open) do
                                        local mouse_location = gMouse()
                                        local x = ((palette.AbsoluteSize.X - (mouse_location.X - palette.AbsolutePosition.X)) + 1)
                                        local y = ((palette.AbsoluteSize.Y - (mouse_location.Y - palette.AbsolutePosition.Y)) + 1.5)
                                        h = x / 100
                                        s = y / 100
                                        Resize(palette_indicator, {Position = UDim2.new(0, math.abs(x - 100) - (palette_indicator.AbsoluteSize.X / 2), 0, math.abs(y - 100) - (palette_indicator.AbsoluteSize.Y / 2))}, options.tween_time)
                                        update()
                                        RS.Heartbeat:Wait()
                                    end
                                    while Held and Entered2 and (not dropdown_open) do
                                        local mouse_location = gMouse()
                                        local y = ((palette.AbsoluteSize.Y - (mouse_location.Y - palette.AbsolutePosition.Y)) + 1.5)
                                        v = y / 100
                                        Resize(saturation_indicator, {Position = UDim2.new(0, 0, 0, math.abs(y - 100))}, options.tween_time)
                                        update()
                                        RS.Heartbeat:Wait()
                                    end
                                end)
                            end
                        end)
                        UIS.InputEnded:Connect(function(inputObject)
                            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                                Held = false
                            end
                        end)
                        function color_picker_data:Set(color)
                            color = typeof(color) == "Color3" and color or Color3.new(1, 1, 1)
                            local h2, s2, v2 = rgbtohsv(color.r * 255, color.g * 255, color.b * 255)
                            sample.ImageColor3 = color
                            saturation.ImageColor3 = Color3.fromHSV(h2, 1, 1)
                            pcall(callback, color)
                        end
                    end
                    updateTabSize()
                    return color_picker_data, color_picker
                end
                
                function tab_data:AddConsole(console_options)
                    local console_data = {}
                    console_options = typeof(console_options) == "table" and console_options or {["readonly"] = true,["full"] = false,}
                    console_options = {
                        ["y"] = tonumber(console_options.y) or 200,
                        ["source"] = console_options.source or "Logs",
                        ["readonly"] = ((console_options.readonly) == true),
                        ["full"] = ((console_options.full) == true),
                    }
                    
                    local console = Instance.new("Frame")
                    console.Size = UDim2.new(1, 0, 0, console_options.y)
                    console.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    console.BackgroundTransparency = 0.8
                    console.BorderSizePixel = 0
                    console.Parent = new_tab
                    Instance.new("UICorner", console).CornerRadius = UDim.new(0, 10)
                    
                    local sf = Instance.new("ScrollingFrame")
                    sf.Size = UDim2.new(1, 0, 1, 0)
                    sf.BackgroundTransparency = 1
                    sf.BorderSizePixel = 0
                    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
                    sf.ScrollBarThickness = 4
                    sf.Parent = console
                    
                    local Source = Instance.new("TextBox")
                    Source.Name = "Source"
                    Source.Size = UDim2.new(1, -40, 1, 0)
                    Source.Position = UDim2.new(0, 40, 0, 0)
                    Source.BackgroundTransparency = 1
                    Source.ClearTextOnFocus = false
                    Source.Font = Enum.Font.Code
                    Source.MultiLine = true
                    Source.Text = ""
                    Source.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Source.TextSize = 15
                    Source.TextXAlignment = Enum.TextXAlignment.Left
                    Source.TextYAlignment = Enum.TextYAlignment.Top
                    Source.Parent = sf
                    
                    local Lines = Instance.new("TextLabel")
                    Lines.Name = "Lines"
                    Lines.Size = UDim2.new(0, 40, 1, 0)
                    Lines.BackgroundTransparency = 1
                    Lines.BorderSizePixel = 0
                    Lines.Font = Enum.Font.Code
                    Lines.Text = "1\n"
                    Lines.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Lines.TextSize = 15
                    Lines.TextYAlignment = Enum.TextYAlignment.Top
                    Lines.Parent = sf
                    
                    Source.TextEditable = not console_options.readonly
                    
                    function console_data:Set(code)
                        Source.Text = tostring(code)
                    end
                    function console_data:Get()
                        return Source.Text
                    end
                    function console_data:Log(msg)
                        Source.Text = Source.Text .. "[*] " .. tostring(msg) .. "\n"
                    end
                    updateTabSize()
                    return console_data, console
                end
                
                function tab_data:AddHorizontalAlignment()
                    local ha_data = {}
                    local ha = Instance.new("Frame")
                    ha.Size = UDim2.new(1, 0, 0, 35)
                    ha.BackgroundTransparency = 1
                    ha.BorderSizePixel = 0
                    ha.Parent = new_tab
                    
                    local haLayout = Instance.new("UIListLayout")
                    haLayout.FillDirection = Enum.FillDirection.Horizontal
                    haLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    haLayout.Padding = UDim.new(0, 8)
                    haLayout.Parent = ha
                    
                    function ha_data:AddButton(...)
                        local data, object
                        local ret = {tab_data:AddButton(...)}
                        if typeof(ret[1]) == "table" then
                            data = ret[1]
                            object = ret[2]
                            object.Size = UDim2.new(0, 100, 0, 35)
                            object.Parent = ha
                            return data, object
                        else
                            object = ret[1]
                            object.Size = UDim2.new(0, 100, 0, 35)
                            object.Parent = ha
                            return object
                        end
                    end
                    updateTabSize()
                    return ha_data, ha
                end
                
                function tab_data:AddFolder(folder_name)
                    local folder_data = {}
                    folder_name = tostring(folder_name or "New Folder")
                    
                    local folder = Instance.new("Frame")
                    folder.Size = UDim2.new(1, 0, 0, 35)
                    folder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    folder.BackgroundTransparency = 0.8
                    folder.BorderSizePixel = 0
                    folder.Parent = new_tab
                    Instance.new("UICorner", folder).CornerRadius = UDim.new(0, 10)
                    
                    local button = Instance.new("TextButton")
                    button.Size = UDim2.new(1, 0, 0, 35)
                    button.BackgroundTransparency = 1
                    button.BorderSizePixel = 0
                    button.Font = Enum.Font.GothamSemibold
                    button.Text = "▼ " .. folder_name
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    button.TextSize = 14
                    button.TextXAlignment = Enum.TextXAlignment.Left
                    button.Parent = folder
                    
                    local objects = Instance.new("Frame")
                    objects.Name = "Objects"
                    objects.Size = UDim2.new(1, -10, 1, -35)
                    objects.Position = UDim2.new(0, 10, 0, 40)
                    objects.BackgroundTransparency = 1
                    objects.BorderSizePixel = 0
                    objects.Visible = false
                    objects.Parent = folder
                    
                    local objectsLayout = Instance.new("UIListLayout")
                    objectsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    objectsLayout.Padding = UDim.new(0, 5)
                    objectsLayout.Parent = objects
                    
                    local function gFolderLen()
                        local n = 40
                        for i,v in pairs(objects:GetChildren()) do
                            if not (v:IsA("UIListLayout")) then
                                n = n + v.AbsoluteSize.Y + 5
                            end
                        end
                        return n
                    end
                    
                    local open = false
                    button.MouseButton1Click:Connect(function()
                        if open then
                            button.Text = "▼ " .. folder_name
                            objects.Visible = false
                        else
                            button.Text = "▲ " .. folder_name
                            objects.Visible = true
                        end
                        open = not open
                        spawn(function()
                            while true do
                                Resize(folder, {Size = UDim2.new(1, 0, 0, (open and gFolderLen() or 35))}, options.tween_time)
                                updateTabSize()
                                wait()
                            end
                        end)
                        updateTabSize()
                    end)
                    
                    for i,v in pairs(tab_data) do
                        folder_data[i] = function(...)
                            local data, object
                            local ret = {v(...)}
                            if typeof(ret[1]) == "table" then
                                data = ret[1]
                                object = ret[2]
                                object.Parent = objects
                                updateTabSize()
                                return data, object
                            else
                                object = ret[1]
                                object.Parent = objects
                                updateTabSize()
                                return object
                            end
                        end
                    end
                    updateTabSize()
                    return folder_data, folder
                end
                
                updateTabSize()
                return tab_data, new_tab
            end
        end
    end
    
    return window_data, MainPanel.Frame
end

return library
