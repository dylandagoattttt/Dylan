-- ================================================================
-- YOUR UI – EXACTLY AS SENT (no changes)
-- ================================================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local ViewportSize = workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 450

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Antora Library"
ScreenGui.Parent = CoreGui

local Scale = Instance.new("UIScale")
Scale.Scale = UIScale
Scale.Parent = ScreenGui

-- Main Window
local UISizeX, UISizeY = 540, 350
local MainFrame = Instance.new("ImageButton")
MainFrame.Name = "Hub"
MainFrame.Size = UDim2.fromOffset(UISizeX, UISizeY)
MainFrame.Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2)
MainFrame.BackgroundTransparency = 0
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.AutoButtonColor = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

-- Glow stroke
local GlowStroke = Instance.new("UIStroke")
GlowStroke.Color = Color3.fromRGB(255, 255, 255)
GlowStroke.Thickness = 2
GlowStroke.Transparency = 0.15
GlowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GlowStroke.Parent = MainFrame

-- Inner Frame
local InnerFrame = Instance.new("Frame")
InnerFrame.Name = "InnerFrame"
InnerFrame.Size = UDim2.new(1, 0, 1, 0)
InnerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
InnerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
InnerFrame.BackgroundTransparency = 0
InnerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
InnerFrame.Parent = MainFrame

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(0, 20)
InnerCorner.Parent = InnerFrame

-- Background Image (Antora Logo)
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=84595542654454&width=678&height=810&format=png"
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
BackgroundImage.ImageTransparency = 0.05
BackgroundImage.Parent = InnerFrame

local BgCorner = Instance.new("UICorner")
BgCorner.CornerRadius = UDim.new(0, 20)
BgCorner.Parent = BackgroundImage

-- Overlay
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Overlay.BackgroundTransparency = 0.6
Overlay.ZIndex = 1
Overlay.Parent = BackgroundImage

local OverlayCorner = Instance.new("UICorner")
OverlayCorner.CornerRadius = UDim.new(0, 20)
OverlayCorner.Parent = Overlay

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "Top Bar"
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundTransparency = 1
TopBar.Parent = InnerFrame

-- Icon
local Icon = Instance.new("ImageLabel")
Icon.Size = UDim2.new(0, 20, 0, 20)
Icon.Position = UDim2.new(0, 10, 0.5, 0)
Icon.AnchorPoint = Vector2.new(0, 0.5)
Icon.BackgroundTransparency = 1
Icon.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=84595542654454&width=678&height=810&format=png"
Icon.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 36, 0.5, 0)
Title.AnchorPoint = Vector2.new(0, 0.5)
Title.AutomaticSize = Enum.AutomaticSize.XY
Title.Text = "Antora Library"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(243, 243, 243)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Creepster
Title.Name = "Title"
Title.Parent = TopBar

-- Subtitle
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.fromScale(0, 1)
SubTitle.AutomaticSize = Enum.AutomaticSize.X
SubTitle.AnchorPoint = Vector2.new(0, 1)
SubTitle.Position = UDim2.new(1, 5, 0.9, 0)
SubTitle.Text = "by: unkinou"
SubTitle.TextColor3 = Color3.fromRGB(80, 80, 80)
SubTitle.BackgroundTransparency = 1
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.TextYAlignment = Enum.TextYAlignment.Bottom
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Creepster
SubTitle.Name = "SubTitle"
SubTitle.Parent = Title

-- CLOSE/MINIMIZE BUTTON (Top right - X)
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.Position = UDim2.new(1, 0, 0, 0)
CloseButton.Size = UDim2.fromOffset(48, 48)
CloseButton.BackgroundTransparency = 1
CloseButton.BorderSizePixel = 0
CloseButton.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=118561288885971&width=300&height=300&format=png"
CloseButton.ScaleType = Enum.ScaleType.Fit
CloseButton.ZIndex = 10
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Close button hover effects
CloseButton.MouseEnter:Connect(function()
    CloseButton:TweenSize(UDim2.fromOffset(54, 54), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton:TweenSize(UDim2.fromOffset(48, 48), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
end)

-- MINIMIZED FRAME (floating icon when minimized)
local MinimizedFrame = Instance.new("ImageButton")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.AnchorPoint = Vector2.new(1, 0)
MinimizedFrame.Position = UDim2.new(1, -20, 0, 20)
MinimizedFrame.Size = UDim2.fromOffset(60, 60)
MinimizedFrame.BackgroundTransparency = 1
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.ZIndex = 100
MinimizedFrame.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=84595542654454&width=300&height=300&format=png"
MinimizedFrame.ScaleType = Enum.ScaleType.Fit
MinimizedFrame.Parent = ScreenGui

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizedFrame

local MinimizedStroke = Instance.new("UIStroke")
MinimizedStroke.Color = Color3.fromRGB(255, 255, 255)
MinimizedStroke.Thickness = 2
MinimizedStroke.Transparency = 0.3
MinimizedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MinimizedStroke.Parent = MinimizedFrame

-- STATE
local isMinimized = false
local MainSize = UDim2.fromOffset(UISizeX, UISizeY)
local MainPos = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2)

-- MINIMIZE FUNCTION
local function MinimizeUI()
    if isMinimized then return end
    isMinimized = true
    
    local targetPos = UDim2.new(1, -40, 0, 40)
    local targetSize = UDim2.fromScale(0.05, 0.05)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    
    TweenService:Create(MainFrame, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
    
    task.wait(0.3)
    MainFrame.Visible = false
    
    MinimizedFrame.Visible = true
    MinimizedFrame.Size = UDim2.fromOffset(0, 0)
    MinimizedFrame:TweenSize(UDim2.fromOffset(60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
end

-- RESTORE FUNCTION
local function RestoreUI()
    isMinimized = false
    MinimizedFrame.Visible = false
    MainFrame.Visible = true
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, tweenInfo, {Size = MainSize, Position = MainPos}):Play()
end

-- CONNECT BUTTONS
CloseButton.MouseButton1Click:Connect(MinimizeUI)
MinimizedFrame.MouseButton1Click:Connect(RestoreUI)

-- DRAG FUNCTION
local function MakeDrag(Instance)
    task.spawn(function()
        Instance.Active = true
        Instance.AutoButtonColor = false
        
        local DragStart, StartPos, InputOn
        
        local function Update(Input)
            local delta = Input.Position - DragStart
            local Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X / UIScale, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y / UIScale)
            local Tween = TweenService:Create(Instance, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Position = Position})
            Tween:Play()
        end
        
        Instance.MouseButton1Down:Connect(function()
            InputOn = true
        end)
        
        Instance.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                StartPos = Instance.Position
                DragStart = Input.Position
                
                while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    RunService.Heartbeat:Wait()
                    if InputOn then
                        Update(Input)
                    end
                end
                InputOn = false
            end
        end)
    end)
    return Instance
end

MakeDrag(MainFrame)

-- Empty Tabs (Sidebar)
local Components = Instance.new("Folder")
Components.Name = "Components"
Components.Parent = InnerFrame

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Name = "Tab Scroll"
TabScroll.Size = UDim2.new(0, 150, 1, -28)
TabScroll.Position = UDim2.new(0, 0, 1, 0)
TabScroll.AnchorPoint = Vector2.new(0, 1)
TabScroll.ScrollBarThickness = 1.5
TabScroll.BackgroundTransparency = 1
TabScroll.ScrollBarImageTransparency = 0.2
TabScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
TabScroll.CanvasSize = UDim2.new()
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
TabScroll.BorderSizePixel = 0
TabScroll.Parent = Components

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingBottom = UDim.new(0, 10)
TabPadding.Parent = TabScroll

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 5)
TabList.Parent = TabScroll

-- Sample Tabs (Empty)
local tabs = {"Home", "Settings"}

for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "Tab_" .. tabName
    TabButton.Size = UDim2.new(1, 0, 0, 24)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabButton.BackgroundTransparency = 0
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = TabScroll
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    local TabGradient = Instance.new("UIGradient")
    TabGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
    })
    TabGradient.Rotation = 90
    TabGradient.Parent = TabButton
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -15, 1)
    TabLabel.Position = UDim2.fromOffset(15, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.Text = tabName
    TabLabel.TextColor3 = Color3.fromRGB(243, 243, 243)
    TabLabel.TextSize = 10
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TabLabel.Parent = TabButton
    
    -- Selected indicator for first tab
    if i == 1 then
        local Selected = Instance.new("Frame")
        Selected.Size = UDim2.new(0, 4, 0, 13)
        Selected.Position = UDim2.new(0, 1, 0.5)
        Selected.AnchorPoint = Vector2.new(0, 0.5)
        Selected.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        Selected.BackgroundTransparency = 0
        Selected.Parent = TabButton
        
        local SelCorner = Instance.new("UICorner")
        SelCorner.CornerRadius = UDim.new(0.5, 0)
        SelCorner.Parent = Selected
        
        local SelGradient = Instance.new("UIGradient")
        SelGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 150)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
        })
        SelGradient.Rotation = 90
        SelGradient.Parent = Selected
    end
    
    TabButton.MouseEnter:Connect(function()
        TabButton.BackgroundTransparency = 0.4
    end)
    TabButton.MouseLeave:Connect(function()
        TabButton.BackgroundTransparency = 0
    end)
end

-- Empty Content Container
local Containers = Instance.new("Frame")
Containers.Name = "Containers"
Containers.Size = UDim2.new(1, -150, 1, -28)
Containers.AnchorPoint = Vector2.new(1, 1)
Containers.Position = UDim2.new(1, 0, 1, 0)
Containers.BackgroundTransparency = 1
Containers.ClipsDescendants = true
Containers.Parent = Components

-- Empty Container
local ContainerScroll = Instance.new("ScrollingFrame")
ContainerScroll.Name = "Container"
ContainerScroll.Size = UDim2.new(1, 0, 1, 0)
ContainerScroll.Position = UDim2.new(0, 0, 1, 0)
ContainerScroll.AnchorPoint = Vector2.new(0, 1)
ContainerScroll.ScrollBarThickness = 1.5
ContainerScroll.BackgroundTransparency = 1
ContainerScroll.ScrollBarImageTransparency = 0.2
ContainerScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
ContainerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContainerScroll.ScrollingDirection = Enum.ScrollingDirection.Y
ContainerScroll.BorderSizePixel = 0
ContainerScroll.CanvasSize = UDim2.new()
ContainerScroll.Parent = Containers

local ContainerPad = Instance.new("UIPadding")
ContainerPad.PaddingLeft = UDim.new(0, 10)
ContainerPad.PaddingRight = UDim.new(0, 10)
ContainerPad.PaddingTop = UDim.new(0, 10)
ContainerPad.PaddingBottom = UDim.new(0, 10)
ContainerPad.Parent = ContainerScroll

local ContainerList = Instance.new("UIListLayout")
ContainerList.Padding = UDim.new(0, 5)
ContainerList.Parent = ContainerScroll

-- Empty message
local EmptyLabel = Instance.new("TextLabel")
EmptyLabel.Size = UDim2.new(1, 0, 1, 0)
EmptyLabel.BackgroundTransparency = 1
EmptyLabel.Font = Enum.Font.GothamMedium
EmptyLabel.Text = "Empty Tab\nAdd your content here"
EmptyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
EmptyLabel.TextSize = 20
EmptyLabel.TextScaled = true
EmptyLabel.TextYAlignment = Enum.TextYAlignment.Center
EmptyLabel.Parent = ContainerScroll


-- ================================================================
--  ADDED FUNCTIONALITY – GLOBAL FUNCTIONS
--  These work on the existing ContainerScroll – no UI changes.
-- ================================================================

-- Helper to create a styled option frame (from your second script)
local function CreateOptionFrame(parent, title, desc)
    local frame = Instance.new("TextButton")
    frame.Name = "Option"
    frame.Size = UDim2.new(1, 0, 0, 25)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0
    frame.Text = ""
    frame.AutoButtonColor = false
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
    })
    gradient.Rotation = 90
    gradient.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextColor3 = Color3.fromRGB(243, 243, 243)
    titleLabel.Size = UDim2.new(1, -20, 0, 12)
    titleLabel.AutomaticSize = Enum.AutomaticSize.Y
    titleLabel.Position = UDim2.new(0, 10, 0.5)
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.TextSize = 10
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.RichText = true
    titleLabel.Parent = frame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.Size = UDim2.new(1, -20, 0, 8)
    descLabel.AutomaticSize = Enum.AutomaticSize.Y
    descLabel.Position = UDim2.new(0, 12, 0, 15)
    descLabel.BackgroundTransparency = 1
    descLabel.TextWrapped = true
    descLabel.TextSize = 8
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Text = desc or ""
    descLabel.RichText = true
    descLabel.Parent = frame
    
    frame.MouseEnter:Connect(function()
        frame.BackgroundTransparency = 0.4
    end)
    frame.MouseLeave:Connect(function()
        frame.BackgroundTransparency = 0
    end)
    
    return frame, titleLabel, descLabel
end

-- Add a label
function AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Parent = ContainerScroll
    label.Size = UDim2.new(0, 200, 0, 20)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(243, 243, 243)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

-- Add a button
function AddButton(text, callback)
    local frame, titleLabel = CreateOptionFrame(ContainerScroll, text)
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 14, 0, 14)
    icon.Position = UDim2.new(1, -10, 0.5)
    icon.AnchorPoint = Vector2.new(1, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://10709791437"
    icon.Parent = frame
    frame.Activated:Connect(function()
        if callback then callback() end
    end)
    return frame
end

-- Add a toggle
function AddToggle(text, callback)
    local frame, titleLabel = CreateOptionFrame(ContainerScroll, text)
    local toggleHolder = Instance.new("Frame")
    toggleHolder.Size = UDim2.new(0, 35, 0, 18)
    toggleHolder.Position = UDim2.new(1, -10, 0.5)
    toggleHolder.AnchorPoint = Vector2.new(1, 0.5)
    toggleHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleHolder.Parent = frame
    local togCorner = Instance.new("UICorner")
    togCorner.CornerRadius = UDim.new(0.5, 0)
    togCorner.Parent = toggleHolder
    
    local slider = Instance.new("Frame")
    slider.BackgroundTransparency = 1
    slider.Size = UDim2.new(0.8, 0, 0.8, 0)
    slider.Position = UDim2.new(0.5, 0, 0.5, 0)
    slider.AnchorPoint = Vector2.new(0.5, 0.5)
    slider.Parent = toggleHolder
    
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 12, 0, 12)
    toggle.Position = UDim2.new(0, 0, 0.5)
    toggle.AnchorPoint = Vector2.new(0, 0.5)
    toggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    toggle.BackgroundTransparency = 0.8
    toggle.Parent = slider
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0.5, 0)
    tCorner.Parent = toggle
    
    local state = false
    local function setToggle(val)
        state = val
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.25), {Position = UDim2.new(1, 0, 0.5), BackgroundTransparency = 0}):Play()
            TweenService:Create(toggle, TweenInfo.new(0.25), {AnchorPoint = Vector2.new(1, 0.5)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.25), {Position = UDim2.new(0, 0, 0.5), BackgroundTransparency = 0.8}):Play()
            TweenService:Create(toggle, TweenInfo.new(0.25), {AnchorPoint = Vector2.new(0, 0.5)}):Play()
        end
        if callback then callback(state) end
    end
    setToggle(false)
    
    frame.Activated:Connect(function()
        setToggle(not state)
    end)
    
    local obj = {}
    function obj:Set(val)
        setToggle(val)
    end
    return obj, frame
end

-- Add a text box
function AddTextBox(placeholder, callback, clearOnEnter)
    local frame, titleLabel = CreateOptionFrame(ContainerScroll, "Text Box")
    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(0, 150, 0, 18)
    boxFrame.Position = UDim2.new(1, -10, 0.5)
    boxFrame.AnchorPoint = Vector2.new(1, 0.5)
    boxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    boxFrame.Parent = frame
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = boxFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.85, 0, 0.85, 0)
    textBox.AnchorPoint = Vector2.new(0.5, 0.5)
    textBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    textBox.BackgroundTransparency = 1
    textBox.Font = Enum.Font.GothamBold
    textBox.TextScaled = true
    textBox.TextColor3 = Color3.fromRGB(243, 243, 243)
    textBox.PlaceholderText = placeholder or "Input"
    textBox.Text = ""
    textBox.Parent = boxFrame
    
    textBox.FocusLost:Connect(function(enter)
        if enter then
            if callback and textBox.Text ~= "" then
                callback(textBox.Text)
                if clearOnEnter then textBox.Text = "" end
            end
        end
    end)
    return textBox
end

-- Add a slider
function AddSlider(title, callback, options)
    options = options or {}
    local min = options.min or 0
    local max = options.max or 100
    local readonly = options.readonly or false
    
    local frame, titleLabel = CreateOptionFrame(ContainerScroll, title)
    local sliderHolder = Instance.new("Frame")
    sliderHolder.Size = UDim2.new(0.45, 0, 1)
    sliderHolder.Position = UDim2.new(1)
    sliderHolder.AnchorPoint = Vector2.new(1, 0)
    sliderHolder.BackgroundTransparency = 1
    sliderHolder.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0.5, 0, 0.5)
    sliderBar.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderBar.Parent = sliderHolder
    local barCorner = Instance.new("UICorner")
    barCorner.Parent = sliderBar
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.fromScale(0.5, 1)
    indicator.BorderSizePixel = 0
    indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    indicator.Parent = sliderBar
    local indCorner = Instance.new("UICorner")
    indCorner.Parent = indicator
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 14, 0, 14)
    valueLabel.AnchorPoint = Vector2.new(1, 0.5)
    valueLabel.Position = UDim2.new(0, 0, 0.5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(243, 243, 243)
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.TextSize = 12
    valueLabel.Parent = sliderHolder
    
    local dragging = false
    sliderHolder.MouseEnter:Connect(function()
        dragging = true
        MainFrame.Draggable = false
    end)
    sliderHolder.MouseLeave:Connect(function()
        dragging = false
        MainFrame.Draggable = true
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            spawn(function()
                while dragging and not readonly do
                    local mousePos = UserInputService:GetMouseLocation()
                    local relX = mousePos.X - sliderBar.AbsolutePosition.X
                    local percent = math.clamp(relX / sliderBar.AbsoluteSize.X, 0, 1)
                    TweenService:Create(indicator, TweenInfo.new(0.1), {Size = UDim2.fromScale(percent, 1)}):Play()
                    local val = math.floor((max - min) * percent + min)
                    valueLabel.Text = tostring(val)
                    if callback then callback(val) end
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end)
    
    local obj = {}
    function obj:Set(val)
        val = tonumber(val) or 0
        val = math.clamp((val - min) / (max - min), 0, 1)
        TweenService:Create(indicator, TweenInfo.new(0.2), {Size = UDim2.fromScale(val, 1)}):Play()
        local realVal = math.floor((max - min) * val + min)
        valueLabel.Text = tostring(realVal)
        if callback then callback(realVal) end
    end
    obj:Set(min)
    return obj, frame
end

-- Add a keybind
function AddKeybind(title, callback, defaultKey)
    local frame, titleLabel = CreateOptionFrame(ContainerScroll, title)
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 80, 1)
    keyFrame.Position = UDim2.new(1, -10, 0.5)
    keyFrame.AnchorPoint = Vector2.new(1, 0.5)
    keyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    keyFrame.Parent = frame
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 4)
    keyCorner.Parent = keyFrame
    
    local keyLabel = Instance.new("TextButton")
    keyLabel.Size = UDim2.new(1, -2, 1, -2)
    keyLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    keyLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.TextScaled = true
    keyLabel.TextColor3 = Color3.fromRGB(243, 243, 243)
    keyLabel.Text = "RShift"
    keyLabel.Parent = keyFrame
    
    local keyNames = {
        RightControl = 'RightCtrl',
        LeftControl = 'LeftCtrl',
        LeftShift = 'LShift',
        RightShift = 'RShift',
        MouseButton1 = "Mouse1",
        MouseButton2 = "Mouse2"
    }
    local currentKey = defaultKey or Enum.KeyCode.RightShift
    local binding = false
    
    local function setKey(newKey)
        currentKey = newKey
        keyLabel.Text = keyNames[newKey.Name] or newKey.Name
    end
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if binding then return end
        if input.KeyCode == currentKey and not processed then
            if callback then callback(currentKey) end
        end
    end)
    
    keyLabel.MouseButton1Click:Connect(function()
        if binding then return end
        binding = true
        keyLabel.Text = "..."
        local input = UserInputService.InputBegan:Wait()
        setKey(input.KeyCode)
        binding = false
    end)
    
    setKey(defaultKey or Enum.KeyCode.RightShift)
    local obj = {}
    function obj:SetKeybind(newKey)
        setKey(newKey)
    end
    return obj, frame
end

-- Add a dropdown
function AddDropdown(title, callback)
    local frame, titleLabel = CreateOptionFrame(ContainerScroll, title)
    local selectedFrame = Instance.new("Frame")
    selectedFrame.Size = UDim2.new(0, 150, 0, 18)
    selectedFrame.Position = UDim2.new(1, -10, 0.5)
    selectedFrame.AnchorPoint = Vector2.new(1, 0.5)
    selectedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    selectedFrame.Parent = frame
    local selCorner = Instance.new("UICorner")
    selCorner.CornerRadius = UDim.new(0, 4)
    selCorner.Parent = selectedFrame
    
    local activeLabel = Instance.new("TextLabel")
    activeLabel.Size = UDim2.new(0.85, 0, 0.85, 0)
    activeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    activeLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    activeLabel.BackgroundTransparency = 1
    activeLabel.Font = Enum.Font.GothamBold
    activeLabel.TextScaled = true
    activeLabel.TextColor3 = Color3.fromRGB(243, 243, 243)
    activeLabel.Text = "..."
    activeLabel.Parent = selectedFrame
    
    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 15, 0, 15)
    arrow.Position = UDim2.new(0, -5, 0.5)
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.Image = "rbxassetid://10709791523"
    arrow.BackgroundTransparency = 1
    arrow.Parent = selectedFrame
    
    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(0, 152, 0, 0)
    dropFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dropFrame.BackgroundTransparency = 0.1
    dropFrame.ClipsDescendants = true
    dropFrame.Parent = frame
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 6)
    dropCorner.Parent = dropFrame
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new()
    scroll.Parent = dropFrame
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = scroll
    
    local open = false
    local function updateDropdownHeight()
        local count = #scroll:GetChildren() - 1
        local height = math.clamp(count, 0, 10) * 25 + 10
        TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 152, 0, height)}):Play()
    end
    
    local function closeDropdown()
        open = false
        TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 152, 0, 0)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
    end
    
    frame.Activated:Connect(function()
        open = not open
        if open then
            updateDropdownHeight()
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            closeDropdown()
        end
    end)
    
    local dropdownObj = {}
    function dropdownObj:Add(optionText)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 21)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.Text = optionText
        btn.TextColor3 = Color3.fromRGB(243, 243, 243)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = scroll
        local cornerBtn = Instance.new("UICorner")
        cornerBtn.CornerRadius = UDim.new(0, 4)
        cornerBtn.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            activeLabel.Text = optionText
            closeDropdown()
            if callback then callback(optionText) end
        end)
        updateDropdownHeight()
        return dropdownObj
    end
    
    return dropdownObj, frame
end

-- Clear all elements from the container
function ClearElements()
    for _, child in ipairs(ContainerScroll:GetChildren()) do
        if child ~= ContainerPad and child ~= ContainerList and child ~= EmptyLabel then
            child:Destroy()
        end
    end
end

print("UI ready – use AddButton(), AddToggle(), etc. to add elements.")
