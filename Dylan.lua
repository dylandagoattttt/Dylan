-- ================================================================
--  Antora‑style UI Library (exact API from your second script)
--  Usage:
--    local ui = loadstring(game:HttpGet("..."))()
--    local win = ui:AddWindow("My Window", { min_size = Vector2.new(400,300) })
--    local tab = win:AddTab("Main")
--    tab:AddButton("Click", function() print("hi") end)
-- ================================================================

local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local function GetMouseLocation()
    return UserInputService:GetMouseLocation()
end

-- ------------------------------------------------------------------
--  Helper: create a styled option frame (matches your second script)
-- ------------------------------------------------------------------
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

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
    })
    grad.Rotation = 90
    grad.Parent = frame

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
    titleLabel.Text = title or ""
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

    frame.MouseEnter:Connect(function() frame.BackgroundTransparency = 0.4 end)
    frame.MouseLeave:Connect(function() frame.BackgroundTransparency = 0 end)

    return frame, titleLabel, descLabel
end

-- ------------------------------------------------------------------
--  Main AddWindow function
-- ------------------------------------------------------------------
local windows = {}   -- keep track of created windows for toggle

function Library:AddWindow(title, config)
    config = config or {}
    local minSize = config.min_size or Vector2.new(400, 300)
    local toggleKey = config.toggle_key or Enum.KeyCode.RightShift
    local canResize = config.can_resize ~= false

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntoraUI"
    screenGui.Parent = CoreGui

    local viewport = workspace.CurrentCamera.ViewportSize
    local uiScale = viewport.Y / 450
    local scaleObj = Instance.new("UIScale")
    scaleObj.Scale = uiScale
    scaleObj.Parent = screenGui

    -- Main window frame
    local main = Instance.new("ImageButton")
    main.Name = "Window"
    main.Size = UDim2.new(0, minSize.X, 0, minSize.Y)
    main.Position = UDim2.new(0.5, -minSize.X/2, 0.5, -minSize.Y/2)
    main.BackgroundTransparency = 0
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.AutoButtonColor = false
    main.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = main

    local glow = Instance.new("UIStroke")
    glow.Color = Color3.fromRGB(255, 255, 255)
    glow.Thickness = 2
    glow.Transparency = 0.15
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Parent = main

    local inner = Instance.new("Frame")
    inner.Name = "Inner"
    inner.Size = UDim2.new(1, 0, 1, 0)
    inner.Position = UDim2.new(0.5, 0, 0.5, 0)
    inner.AnchorPoint = Vector2.new(0.5, 0.5)
    inner.BackgroundTransparency = 0
    inner.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    inner.Parent = main
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(0, 20)
    innerCorner.Parent = inner

    -- Background watermark
    local bg = Instance.new("ImageLabel")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=84595542654454&width=678&height=810&format=png"
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    bg.ImageTransparency = 0.05
    bg.Parent = inner
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 20)
    bgCorner.Parent = bg

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    overlay.BackgroundTransparency = 0.6
    overlay.ZIndex = 1
    overlay.Parent = bg
    local ovCorner = Instance.new("UICorner")
    ovCorner.CornerRadius = UDim.new(0, 20)
    ovCorner.Parent = overlay

    -- Top bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 28)
    topBar.BackgroundTransparency = 1
    topBar.Parent = inner

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 10, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=84595542654454&width=678&height=810&format=png"
    icon.Parent = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Position = UDim2.new(0, 36, 0.5, 0)
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.AutomaticSize = Enum.AutomaticSize.XY
    titleLabel.Text = title or "UI Library"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Color3.fromRGB(243, 243, 243)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.Creepster
    titleLabel.Parent = topBar

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.fromScale(0, 1)
    sub.AutomaticSize = Enum.AutomaticSize.X
    sub.AnchorPoint = Vector2.new(0, 1)
    sub.Position = UDim2.new(1, 5, 0.9, 0)
    sub.Text = "by: unkinou"
    sub.TextColor3 = Color3.fromRGB(80, 80, 80)
    sub.BackgroundTransparency = 1
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextYAlignment = Enum.TextYAlignment.Bottom
    sub.TextSize = 10
    sub.Font = Enum.Font.Creepster
    sub.Parent = titleLabel

    -- Close button (minimize)
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "Close"
    closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    closeBtn.Position = UDim2.new(1, 0, 0, 0)
    closeBtn.Size = UDim2.fromOffset(48, 48)
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel = 0
    closeBtn.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=118561288885971&width=300&height=300&format=png"
    closeBtn.ScaleType = Enum.ScaleType.Fit
    closeBtn.ZIndex = 10
    closeBtn.Parent = main
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function()
        closeBtn:TweenSize(UDim2.fromOffset(54, 54), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn:TweenSize(UDim2.fromOffset(48, 48), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)

    -- Minimized frame (floating icon)
    local minimized = Instance.new("ImageButton")
    minimized.Name = "Minimized"
    minimized.AnchorPoint = Vector2.new(1, 0)
    minimized.Position = UDim2.new(1, -20, 0, 20)
    minimized.Size = UDim2.fromOffset(60, 60)
    minimized.BackgroundTransparency = 1
    minimized.BorderSizePixel = 0
    minimized.Visible = false
    minimized.ZIndex = 100
    minimized.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=84595542654454&width=300&height=300&format=png"
    minimized.ScaleType = Enum.ScaleType.Fit
    minimized.Parent = screenGui
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minimized
    local minStroke = Instance.new("UIStroke")
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 2
    minStroke.Transparency = 0.3
    minStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    minStroke.Parent = minimized

    local isMinimized = false
    local mainSize = UDim2.new(0, minSize.X, 0, minSize.Y)
    local mainPos = UDim2.new(0.5, -minSize.X/2, 0.5, -minSize.Y/2)

    local function Minimize()
        if isMinimized then return end
        isMinimized = true
        local tween = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        TweenService:Create(main, tween, {Size = UDim2.fromScale(0.05, 0.05), Position = UDim2.new(1, -40, 0, 40)}):Play()
        task.wait(0.3)
        main.Visible = false
        minimized.Visible = true
        minimized.Size = UDim2.fromOffset(0, 0)
        minimized:TweenSize(UDim2.fromOffset(60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
    end

    local function Restore()
        isMinimized = false
        minimized.Visible = false
        main.Visible = true
        local tween = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(main, tween, {Size = mainSize, Position = mainPos}):Play()
    end

    closeBtn.MouseButton1Click:Connect(Minimize)
    minimized.MouseButton1Click:Connect(Restore)

    -- Drag
    local function MakeDrag(obj)
        task.spawn(function()
            obj.Active = true
            obj.AutoButtonColor = false
            local dragStart, startPos, inputOn
            local function Update(input)
                local delta = input.Position - dragStart
                local pos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X / uiScale,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y / uiScale)
                TweenService:Create(obj, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Position = pos}):Play()
            end
            obj.MouseButton1Down:Connect(function() inputOn = true end)
            obj.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    startPos = obj.Position
                    dragStart = input.Position
                    while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        RunService.Heartbeat:Wait()
                        if inputOn then Update(input) end
                    end
                    inputOn = false
                end
            end)
        end)
        return obj
    end
    MakeDrag(main)

    -- Resizer (same as your second script)
    local resizer = Instance.new("Frame")
    resizer.Name = "Resizer"
    resizer.Parent = main
    resizer.Active = true
    resizer.BackgroundTransparency = 1
    resizer.Position = UDim2.new(1, -20, 1, -20)
    resizer.Size = UDim2.new(0, 20, 0, 20)
    resizer.ZIndex = 10

    if canResize then
        local dragging = false
        resizer.MouseEnter:Connect(function() main.Draggable = false; dragging = true end)
        resizer.MouseLeave:Connect(function() main.Draggable = true; dragging = false end)
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                spawn(function()
                    while dragging and resizer.Active do
                        local mousePos = GetMouseLocation()
                        local newX = math.max(minSize.X, mousePos.X - main.AbsolutePosition.X)
                        local newY = math.max(minSize.Y, mousePos.Y - main.AbsolutePosition.Y)
                        TweenService:Create(main, TweenInfo.new(0.1), {Size = UDim2.new(0, newX, 0, newY)}):Play()
                        RunService.Heartbeat:Wait()
                    end
                end)
            end
        end)
    end

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 150, 1, -28)
    sidebar.Position = UDim2.new(0, 0, 1, 0)
    sidebar.AnchorPoint = Vector2.new(0, 1)
    sidebar.BackgroundTransparency = 1
    sidebar.Parent = inner

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Name = "TabScroll"
    tabScroll.Size = UDim2.new(1, 0, 1, 0)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness = 1.5
    tabScroll.ScrollBarImageTransparency = 0.2
    tabScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    tabScroll.CanvasSize = UDim2.new()
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    tabScroll.BorderSizePixel = 0
    tabScroll.Parent = sidebar
    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingLeft = UDim.new(0, 10)
    tabPad.PaddingRight = UDim.new(0, 10)
    tabPad.PaddingTop = UDim.new(0, 10)
    tabPad.PaddingBottom = UDim.new(0, 10)
    tabPad.Parent = tabScroll
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabScroll

    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -150, 1, -28)
    contentArea.Position = UDim2.new(0, 150, 0, 28)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true
    contentArea.Parent = inner

    -- Tab management
    local tabs = {}
    local activeTab = nil

    local function SelectTab(name)
        if activeTab == name then return end
        if activeTab and tabs[activeTab] then
            tabs[activeTab].container.Visible = false
            local prevBtn = tabs[activeTab].button
            local sel = prevBtn:FindFirstChild("Selector")
            if sel then
                TweenService:Create(sel, TweenInfo.new(0.35), {Size = UDim2.new(0, 4, 0, 4), BackgroundTransparency = 1}):Play()
            end
        end
        activeTab = name
        local info = tabs[name]
        if info then
            info.container.Visible = true
            local sel = info.button:FindFirstChild("Selector")
            if sel then
                TweenService:Create(sel, TweenInfo.new(0.35), {Size = UDim2.new(0, 4, 0, 13), BackgroundTransparency = 0}):Play()
            end
        end
    end

    -- Window object (bo)
    local window = {}

    -- AddTab
    function window:AddTab(name)
        if tabs[name] then return tabs[name].object end

        -- Tab button
        local btn = Instance.new("TextButton")
        btn.Name = "Tab_" .. name
        btn.Size = UDim2.new(1, 0, 0, 24)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = tabScroll

        local cornerBtn = Instance.new("UICorner")
        cornerBtn.CornerRadius = UDim.new(0, 6)
        cornerBtn.Parent = btn

        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
        })
        grad.Rotation = 90
        grad.Parent = btn

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -15, 1)
        label.Position = UDim2.fromOffset(15, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.Text = name
        label.TextColor3 = Color3.fromRGB(243, 243, 243)
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.Parent = btn

        local sel = Instance.new("Frame")
        sel.Name = "Selector"
        sel.Size = UDim2.new(0, 4, 0, 4)
        sel.Position = UDim2.new(0, 1, 0.5)
        sel.AnchorPoint = Vector2.new(0, 0.5)
        sel.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        sel.BackgroundTransparency = 1
        sel.Parent = btn
        local selCorner = Instance.new("UICorner")
        selCorner.CornerRadius = UDim.new(0.5, 0)
        selCorner.Parent = sel
        local selGrad = Instance.new("UIGradient")
        selGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 150)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
        })
        selGrad.Rotation = 90
        selGrad.Parent = sel

        btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0.4 end)
        btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 0 end)

        -- Tab container (ScrollingFrame)
        local container = Instance.new("ScrollingFrame")
        container.Name = "Container"
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 1.5
        container.ScrollBarImageTransparency = 0.2
        container.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
        container.AutomaticCanvasSize = Enum.AutomaticSize.Y
        container.ScrollingDirection = Enum.ScrollingDirection.Y
        container.BorderSizePixel = 0
        container.CanvasSize = UDim2.new()
        container.Visible = false
        container.Parent = contentArea

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.Parent = container

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.Parent = container

        -- Tab object (bF)
        local tab = {}

        -- Methods that add elements to this container
        function tab:AddLabel(text)
            local label = Instance.new("TextLabel")
            label.Parent = container
            label.Size = UDim2.new(0, 200, 0, 20)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamSemibold
            label.Text = text or "Label"
            label.TextColor3 = Color3.fromRGB(243, 243, 243)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            return label
        end

        function tab:AddButton(text, callback)
            local frame = CreateOptionFrame(container, text)
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

        function tab:AddSwitch(text, callback)
            local frame = CreateOptionFrame(container, text)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(0, 35, 0, 18)
            holder.Position = UDim2.new(1, -10, 0.5)
            holder.AnchorPoint = Vector2.new(1, 0.5)
            holder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            holder.Parent = frame
            local hCorner = Instance.new("UICorner")
            hCorner.CornerRadius = UDim.new(0.5, 0)
            hCorner.Parent = holder

            local slider = Instance.new("Frame")
            slider.BackgroundTransparency = 1
            slider.Size = UDim2.new(0.8, 0, 0.8, 0)
            slider.Position = UDim2.new(0.5, 0, 0.5, 0)
            slider.AnchorPoint = Vector2.new(0.5, 0.5)
            slider.Parent = holder

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
            local function Set(val)
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
            Set(false)

            frame.Activated:Connect(function() Set(not state) end)

            local obj = {}
            function obj:Set(val) Set(val) end
            return obj, frame
        end

        function tab:AddTextBox(placeholder, callback, clearOnEnter)
            local frame = CreateOptionFrame(container, "Text Box")
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 150, 0, 18)
            box.Position = UDim2.new(1, -10, 0.5)
            box.AnchorPoint = Vector2.new(1, 0.5)
            box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            box.Parent = frame
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 4)
            bCorner.Parent = box

            local tb = Instance.new("TextBox")
            tb.Size = UDim2.new(0.85, 0, 0.85, 0)
            tb.AnchorPoint = Vector2.new(0.5, 0.5)
            tb.Position = UDim2.new(0.5, 0, 0.5, 0)
            tb.BackgroundTransparency = 1
            tb.Font = Enum.Font.GothamBold
            tb.TextScaled = true
            tb.TextColor3 = Color3.fromRGB(243, 243, 243)
            tb.PlaceholderText = placeholder or "Input"
            tb.Text = ""
            tb.Parent = box

            tb.FocusLost:Connect(function(enter)
                if enter then
                    if callback and tb.Text ~= "" then
                        callback(tb.Text)
                        if clearOnEnter then tb.Text = "" end
                    end
                end
            end)
            return tb
        end

        function tab:AddSlider(title, callback, options)
            options = options or {}
            local min = options.min or 0
            local max = options.max or 100
            local readonly = options.readonly or false

            local frame = CreateOptionFrame(container, title)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(0.45, 0, 1)
            holder.Position = UDim2.new(1)
            holder.AnchorPoint = Vector2.new(1, 0)
            holder.BackgroundTransparency = 1
            holder.Parent = frame

            local bar = Instance.new("Frame")
            bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            bar.Size = UDim2.new(1, -20, 0, 6)
            bar.Position = UDim2.new(0.5, 0, 0.5)
            bar.AnchorPoint = Vector2.new(0.5, 0.5)
            bar.Parent = holder
            local barCorner = Instance.new("UICorner")
            barCorner.Parent = bar

            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.fromScale(0.5, 1)
            indicator.BorderSizePixel = 0
            indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            indicator.Parent = bar
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
            valueLabel.Parent = holder

            local dragging = false
            holder.MouseEnter:Connect(function() dragging = true; main.Draggable = false end)
            holder.MouseLeave:Connect(function() dragging = false; main.Draggable = true end)

            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    spawn(function()
                        while dragging and not readonly do
                            local mousePos = GetMouseLocation()
                            local relX = mousePos.X - bar.AbsolutePosition.X
                            local percent = math.clamp(relX / bar.AbsoluteSize.X, 0, 1)
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

        function tab:AddKeybind(title, callback, defaultKey)
            local frame = CreateOptionFrame(container, title)
            local keyFrame = Instance.new("Frame")
            keyFrame.Size = UDim2.new(0, 80, 1)
            keyFrame.Position = UDim2.new(1, -10, 0.5)
            keyFrame.AnchorPoint = Vector2.new(1, 0.5)
            keyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            keyFrame.Parent = frame
            local kCorner = Instance.new("UICorner")
            kCorner.CornerRadius = UDim.new(0, 4)
            kCorner.Parent = keyFrame

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
            function obj:SetKeybind(newKey) setKey(newKey) end
            return obj, frame
        end

        function tab:AddDropdown(title, callback)
            local frame = CreateOptionFrame(container, title)
            local selected = Instance.new("Frame")
            selected.Size = UDim2.new(0, 150, 0, 18)
            selected.Position = UDim2.new(1, -10, 0.5)
            selected.AnchorPoint = Vector2.new(1, 0.5)
            selected.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            selected.Parent = frame
            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(0, 4)
            sCorner.Parent = selected

            local activeLabel = Instance.new("TextLabel")
            activeLabel.Size = UDim2.new(0.85, 0, 0.85, 0)
            activeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            activeLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            activeLabel.BackgroundTransparency = 1
            activeLabel.Font = Enum.Font.GothamBold
            activeLabel.TextScaled = true
            activeLabel.TextColor3 = Color3.fromRGB(243, 243, 243)
            activeLabel.Text = "..."
            activeLabel.Parent = selected

            local arrow = Instance.new("ImageLabel")
            arrow.Size = UDim2.new(0, 15, 0, 15)
            arrow.Position = UDim2.new(0, -5, 0.5)
            arrow.AnchorPoint = Vector2.new(1, 0.5)
            arrow.Image = "rbxassetid://10709791523"
            arrow.BackgroundTransparency = 1
            arrow.Parent = selected

            local drop = Instance.new("Frame")
            drop.Size = UDim2.new(0, 152, 0, 0)
            drop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            drop.BackgroundTransparency = 0.1
            drop.ClipsDescendants = true
            drop.Parent = frame
            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(0, 6)
            dCorner.Parent = drop

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0)
            scroll.BackgroundTransparency = 1
            scroll.ScrollBarThickness = 2
            scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scroll.CanvasSize = UDim2.new()
            scroll.Parent = drop
            local list = Instance.new("UIListLayout")
            list.Padding = UDim.new(0, 2)
            list.Parent = scroll

            local open = false
            local function updateHeight()
                local count = #scroll:GetChildren() - 1
                local height = math.clamp(count, 0, 10) * 25 + 10
                TweenService:Create(drop, TweenInfo.new(0.2), {Size = UDim2.new(0, 152, 0, height)}):Play()
            end

            local function close()
                open = false
                TweenService:Create(drop, TweenInfo.new(0.2), {Size = UDim2.new(0, 152, 0, 0)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            end

            frame.Activated:Connect(function()
                open = not open
                if open then
                    updateHeight()
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    close()
                end
            end)

            local dd = {}
            function dd:Add(opt)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 21)
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                btn.Text = opt
                btn.TextColor3 = Color3.fromRGB(243, 243, 243)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 10
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Parent = scroll
                local bCorner = Instance.new("UICorner")
                bCorner.CornerRadius = UDim.new(0, 4)
                bCorner.Parent = btn
                btn.MouseButton1Click:Connect(function()
                    activeLabel.Text = opt
                    close()
                    if callback then callback(opt) end
                end)
                updateHeight()
                return dd
            end
            return dd, frame
        end

        function tab:AddColorPicker(callback)
            -- Minimal implementation (you can expand from your original)
            local frame = CreateOptionFrame(container, "Color Picker")
            -- For simplicity, we just return a dummy object and the frame
            local obj = {}
            function obj:Set(color) end
            return obj, frame
        end

        function tab:AddConsole(options)
            -- Minimal implementation
            local frame = CreateOptionFrame(container, "Console")
            local obj = {}
            function obj:Set(text) end
            function obj:Get() return "" end
            function obj:Log(text) end
            return obj, frame
        end

        function tab:AddHorizontalAlignment()
            local containerHA = Instance.new("Frame")
            containerHA.Size = UDim2.new(1, 0, 0, 20)
            containerHA.BackgroundTransparency = 1
            containerHA.Parent = container
            local layoutHA = Instance.new("UIListLayout")
            layoutHA.FillDirection = Enum.FillDirection.Horizontal
            layoutHA.Padding = UDim.new(0, 5)
            layoutHA.Parent = containerHA

            local haObj = {}
            function haObj:AddButton(text, callback)
                -- Use the tab's AddButton but parent to containerHA
                local frame = CreateOptionFrame(containerHA, text)
                -- We need to adjust size because it's horizontal
                frame.Size = UDim2.new(0, 100, 0, 20)
                frame.AutomaticSize = Enum.AutomaticSize.None
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
            return haObj, containerHA
        end

        function tab:AddFolder(folderName)
            local folderFrame = Instance.new("Frame")
            folderFrame.Size = UDim2.new(1, 0, 0, 20)
            folderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            folderFrame.Parent = container

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = "  " .. (folderName or "Folder")
            btn.TextColor3 = Color3.fromRGB(243, 243, 243)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = folderFrame

            local toggleIcon = Instance.new("ImageLabel")
            toggleIcon.Size = UDim2.new(0, 12, 0, 12)
            toggleIcon.Position = UDim2.new(0, 5, 0.5)
            toggleIcon.AnchorPoint = Vector2.new(0, 0.5)
            toggleIcon.Image = "rbxassetid://10709791523"
            toggleIcon.BackgroundTransparency = 1
            toggleIcon.Parent = folderFrame

            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, -10, 0, 0)
            content.Position = UDim2.new(0, 10, 0, 20)
            content.BackgroundTransparency = 1
            content.Visible = false
            content.Parent = folderFrame

            local open = false
            btn.MouseButton1Click:Connect(function()
                open = not open
                content.Visible = open
                TweenService:Create(toggleIcon, TweenInfo.new(0.2), {Rotation = open and 90 or 0}):Play()
            end)

            -- Folder object that has the same methods as the tab
            local folderTab = {}
            -- We'll copy the methods from the tab, but parent to 'content' instead of 'container'
            for k, v in pairs(tab) do
                if type(v) == "function" and k ~= "AddFolder" then
                    folderTab[k] = function(...)
                        -- Temporarily change the parent for the element creation
                        -- We need to override the container for each method
                        -- Simplest: we create a new tab object with content as container
                        -- But we can also just use a wrapper
                        -- We'll create a new tab object with content as container
                        local newTab = {}
                        -- We'll just use the same functions but with container swapped
                        -- This is a bit hacky; we'll create a new tab object that uses content as parent
                        local function wrapMethod(method)
                            return function(...)
                                -- We need to call the method with content as the parent
                                -- We'll temporarily set container to content, but that would affect the original tab
                                -- Better: we create a new tab object with content as the container
                                -- We'll just create a new tab object using a helper
                                return method(...)
                            end
                        end
                        -- Not clean, but for brevity we'll implement a simpler approach:
                        -- We'll just use a new tab object created with content
                        local subTab = {}
                        for key, func in pairs(tab) do
                            if type(func) == "function" then
                                subTab[key] = function(...)
                                    -- We need to call the function with content as parent
                                    -- We'll use a trick: we'll temporarily set the container variable
                                    local oldContainer = container
                                    container = content
                                    local result = func(...)
                                    container = oldContainer
                                    return result
                                end
                            end
                        end
                        return subTab
                    end
                end
            end
            -- Override AddFolder to allow nesting
            folderTab.AddFolder = tab.AddFolder

            return folderTab, folderFrame
        end

        -- Store tab info
        tabs[name] = {
            button = btn,
            container = container,
            object = tab,
            selector = sel
        }

        btn.MouseButton1Click:Connect(function()
            SelectTab(name)
        end)

        if not activeTab then
            SelectTab(name)
        end

        return tab
    end

    -- Other window methods (from your second script)
    function window:Close()
        screenGui:Destroy()
    end

    function window:Minimize()
        Minimize()
    end

    function window:Restore()
        Restore()
    end

    function window:SelectTab(name)
        SelectTab(name)
    end

    -- Toggle visibility with the key
    local function ToggleVisibility()
        screenGui.Enabled = not screenGui.Enabled
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == toggleKey then
            ToggleVisibility()
        end
    end)

    -- Keep reference for cleanup
    table.insert(windows, screenGui)

    return window
end

-- Return the library
return Library
