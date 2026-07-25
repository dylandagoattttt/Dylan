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
}

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
            if g < b then h = h + 6 end
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, v
end

local function gNameLen(obj)
    return obj.TextBounds.X + 15
end

local function gMouse()
    return Vector2.new(UserInputService:GetMouseLocation().X + 1, UserInputService:GetMouseLocation().Y - 35)
end

local function ripple(button, x, y)
    spawn(function()
        button.ClipsDescendants = true
        local circle = Instance.new("ImageLabel")
        circle.Name = "Circle"
        circle.BackgroundColor3 = Color3.new(1,1,1)
        circle.BackgroundTransparency = 1
        circle.Image = "rbxassetid://266543268"
        circle.ImageTransparency = 0.5
        circle.ZIndex = 1000
        circle.Parent = button
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
        circle:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), "Out", "Quad", 0.5, false, nil)
        local tween = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(circle, tween, {ImageTransparency = 1}):Play()
        wait(0.5)
        circle:Destroy()
    end)
end

-- ------------------------------------------------------------------
--  Create a new window (Antora visual style)
-- ------------------------------------------------------------------
local windows = 0
local library = {}

function Library:AddWindow(title, config)
    config = config or {}
    local minSize = config.min_size or Vector2.new(400, 300)
    local toggleKey = config.toggle_key or Enum.KeyCode.RightShift
    local canResize = config.can_resize ~= false

    windows = windows + 1
    local dropdown_open = false

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntoraUI"
    screenGui.Parent = CoreGui

    local viewport = workspace.CurrentCamera.ViewportSize
    local uiScale = viewport.Y / 450
    local scaleObj = Instance.new("UIScale")
    scaleObj.Scale = uiScale
    scaleObj.Parent = screenGui

    -- Main window frame (Antora style)
    local mainFrame = Instance.new("ImageButton")
    mainFrame.Name = "Window"
    mainFrame.Size = UDim2.new(0, minSize.X, 0, minSize.Y)
    mainFrame.Position = UDim2.new(0.5, -minSize.X/2, 0.5, -minSize.Y/2)
    mainFrame.BackgroundTransparency = 0
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.AutoButtonColor = false
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame

    local glow = Instance.new("UIStroke")
    glow.Color = Color3.fromRGB(255, 255, 255)
    glow.Thickness = 2
    glow.Transparency = 0.15
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Parent = mainFrame

    -- Inner frame (dark background)
    local inner = Instance.new("Frame")
    inner.Name = "Inner"
    inner.Size = UDim2.new(1, 0, 1, 0)
    inner.Position = UDim2.new(0.5, 0, 0.5, 0)
    inner.AnchorPoint = Vector2.new(0.5, 0.5)
    inner.BackgroundTransparency = 0
    inner.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    inner.Parent = mainFrame
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(0, 20)
    innerCorner.Parent = inner

    -- Background image (watermark)
    local bgImage = Instance.new("ImageLabel")
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114929713504311&width=678&height=810&format=png"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
    bgImage.ImageTransparency = 0.05
    bgImage.Parent = inner
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 20)
    bgCorner.Parent = bgImage

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    overlay.BackgroundTransparency = 0.6
    overlay.ZIndex = 1
    overlay.Parent = bgImage
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
    icon.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114929713504311&width=678&height=810&format=png"
    icon.Parent = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Position = UDim2.new(0, 36, 0.5, 0)
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.AutomaticSize = Enum.AutomaticSize.XY
    titleLabel.Text = title or "Antora Library"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Color3.fromRGB(243, 243, 243)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.Creepster
    titleLabel.Parent = topBar

    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.fromScale(0, 1)
    subTitle.AutomaticSize = Enum.AutomaticSize.X
    subTitle.AnchorPoint = Vector2.new(0, 1)
    subTitle.Position = UDim2.new(1, 5, 0.9, 0)
    subTitle.Text = "by: unkinou"
    subTitle.TextColor3 = Color3.fromRGB(80, 80, 80)
    subTitle.BackgroundTransparency = 1
    subTitle.TextXAlignment = Enum.TextXAlignment.Left
    subTitle.TextYAlignment = Enum.TextYAlignment.Bottom
    subTitle.TextSize = 10
    subTitle.Font = Enum.Font.Creepster
    subTitle.Parent = titleLabel

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
    closeBtn.Parent = mainFrame
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
    minimized.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114929713504311&width=300&height=300&format=png"
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
        TweenService:Create(mainFrame, tween, {Size = UDim2.fromScale(0.05, 0.05), Position = UDim2.new(1, -40, 0, 40)}):Play()
        task.wait(0.3)
        mainFrame.Visible = false
        minimized.Visible = true
        minimized.Size = UDim2.fromOffset(0, 0)
        minimized:TweenSize(UDim2.fromOffset(60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
    end

    local function Restore()
        isMinimized = false
        minimized.Visible = false
        mainFrame.Visible = true
        local tween = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(mainFrame, tween, {Size = mainSize, Position = mainPos}):Play()
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
    MakeDrag(mainFrame)

    -- Resizer (optional)
    local resizer = Instance.new("Frame")
    resizer.Name = "Resizer"
    resizer.Parent = mainFrame
    resizer.Active = true
    resizer.BackgroundTransparency = 1
    resizer.Position = UDim2.new(1, -20, 1, -20)
    resizer.Size = UDim2.new(0, 20, 0, 20)
    resizer.ZIndex = 10

    if canResize then
        local dragging = false
        resizer.MouseEnter:Connect(function() mainFrame.Draggable = false; dragging = true end)
        resizer.MouseLeave:Connect(function() mainFrame.Draggable = true; dragging = false end)
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                spawn(function()
                    while dragging and resizer.Active do
                        local mousePos = GetMouseLocation()
                        local newX = math.max(minSize.X, mousePos.X - mainFrame.AbsolutePosition.X)
                        local newY = math.max(minSize.Y, mousePos.Y - mainFrame.AbsolutePosition.Y)
                        TweenService:Create(mainFrame, TweenInfo.new(0.1), {Size = UDim2.new(0, newX, 0, newY)}):Play()
                        RunService.Heartbeat:Wait()
                    end
                end)
            end
        end)
    end

    -- Sidebar (tabs)
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

    -- Window object
    local window = {}

    -- AddTab (creates a tab button and a container)
    function window:AddTab(name)
        if tabs[name] then return tabs[name].object end

        -- Tab button (styled like Antora)
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

        -- Content container (scrolling)
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
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container

        -- Tab object
        local tab = {}
        local elementCounter = 0

        local function assignLayoutOrder(obj)
            elementCounter = elementCounter + 1
            obj.LayoutOrder = elementCounter
        end

        -- Helper to create a floating dropdown popup
        local function createFloatingDropdown(button, options, callback)
            -- Button is the dropdown button itself (the main button)
            -- options is a table of strings
            -- callback is called when an option is selected
            local popup = Instance.new("Frame")
            popup.Name = "DropdownPopup"
            popup.Size = UDim2.new(0, 200, 0, 0)
            popup.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            popup.BackgroundTransparency = 0
            popup.BorderSizePixel = 0
            popup.ClipsDescendants = true
            popup.ZIndex = 1000
            popup.Parent = screenGui  -- top-level

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = popup

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(60, 60, 60)
            stroke.Thickness = 1
            stroke.Transparency = 0.5
            stroke.Parent = popup

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel = 0
            scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            scroll.ScrollBarThickness = 4
            scroll.ZIndex = 1001
            scroll.Parent = popup

            local list = Instance.new("UIListLayout")
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Padding = UDim.new(0, 2)
            list.Parent = scroll

            -- Add options
            local optionButtons = {}
            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                optBtn.BackgroundTransparency = 0
                optBtn.BorderSizePixel = 0
                optBtn.Font = Enum.Font.GothamSemibold
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optBtn.TextSize = 14
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.ZIndex = 1002
                optBtn.Parent = scroll
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 4)
                optCorner.Parent = optBtn
                optBtn.MouseEnter:Connect(function()
                    optBtn.BackgroundTransparency = 0.5
                end)
                optBtn.MouseLeave:Connect(function()
                    optBtn.BackgroundTransparency = 0
                end)
                optBtn.MouseButton1Click:Connect(function()
                    if callback then callback(opt) end
                    popup:Destroy()
                end)
                table.insert(optionButtons, optBtn)
            end

            -- Update canvas and height
            local function updateSize()
                local count = #scroll:GetChildren() - 1
                local height = math.clamp(count, 0, 10) * 32 + 5
                popup.Size = UDim2.new(0, 200, 0, height)
                scroll.CanvasSize = UDim2.new(0, 0, 0, count * 32 + 5)
            end
            updateSize()

            -- Position popup near the button
            local buttonPos = button.AbsolutePosition
            local buttonSize = button.AbsoluteSize
            local popupPos = UDim2.new(0, buttonPos.X, 0, buttonPos.Y + buttonSize.Y)
            -- Check if it fits below, else place above
            local screenSize = screenGui.AbsoluteSize
            if buttonPos.Y + buttonSize.Y + popup.Size.Y.Offset > screenSize.Y then
                popupPos = UDim2.new(0, buttonPos.X, 0, buttonPos.Y - popup.Size.Y.Offset)
            end
            popup.Position = popupPos

            -- Close popup when clicking outside
            local function closePopup()
                popup:Destroy()
            end
            -- We'll use a temporary connection on UserInputService
            local mouseDownConnection
            mouseDownConnection = UserInputService.InputBegan:Connect(function(input, processed)
                if processed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Check if click is inside popup or button
                    local mousePos = input.Position
                    if popup and popup.Parent then
                        local popupAbs = popup.AbsolutePosition
                        local popupSize = popup.AbsoluteSize
                        if mousePos.X >= popupAbs.X and mousePos.X <= popupAbs.X + popupSize.X and
                           mousePos.Y >= popupAbs.Y and mousePos.Y <= popupAbs.Y + popupSize.Y then
                            return -- click inside popup, ignore
                        end
                        -- Also check if click is on the button itself (to prevent closing when clicking the button again)
                        local btnAbs = button.AbsolutePosition
                        local btnSize = button.AbsoluteSize
                        if mousePos.X >= btnAbs.X and mousePos.X <= btnAbs.X + btnSize.X and
                           mousePos.Y >= btnAbs.Y and mousePos.Y <= btnAbs.Y + btnSize.Y then
                            return -- click on the button, ignore (the button will handle toggling)
                        end
                        -- Otherwise close
                        if popup then popup:Destroy() end
                        if mouseDownConnection then mouseDownConnection:Disconnect() end
                    end
                end
            end)

            -- Also close when parent window is minimized or closed
            local cleanupConnections = {}
            table.insert(cleanupConnections, mainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
                if not mainFrame.Visible then
                    if popup then popup:Destroy() end
                end
            end))

            -- Return a function to manually destroy
            return popup
        end

        -- === TAB METHODS ===

        function tab:AddLabel(text)
            local label = Instance.new("TextLabel")
            label.Parent = container
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamSemibold
            label.Text = text or "Label"
            label.TextColor3 = Color3.fromRGB(243, 243, 243)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            label.TextStrokeTransparency = 0
            assignLayoutOrder(label)
            return label
        end

        function tab:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(110, 45, 220)
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.GothamBold
            btn.Text = text or "Button"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 14
            btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            btn.TextStrokeTransparency = 0
            btn.Parent = container
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = btn
            local grad = Instance.new("UIGradient")
            grad.Rotation = 90
            grad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(176,96,244))
            }
            grad.Parent = btn
            btn.MouseButton1Click:Connect(function()
                ripple(btn, Mouse.X, Mouse.Y)
                if callback then callback() end
            end)
            assignLayoutOrder(btn)
            return btn
        end

        function tab:AddSwitch(text, callback)
            local data = {}
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 35)
            frame.BackgroundTransparency = 1
            frame.Parent = container

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 30, 0, 30)
            btn.Position = UDim2.new(0, 5, 0, 2)
            btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
            btn.BackgroundTransparency = 0.7
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.SourceSans
            btn.Text = ""
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextSize = 18
            btn.Parent = frame
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = btn

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -45, 1, 0)
            label.Position = UDim2.new(0, 40, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamSemibold
            label.Text = text or "Switch"
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            label.TextStrokeTransparency = 0
            label.Parent = frame

            local state = false
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = state and utf8.char(10003) or ""
                btn.BackgroundTransparency = state and 0.3 or 0.7
                if callback then callback(state) end
            end)

            function data:Set(val)
                state = val
                btn.Text = state and utf8.char(10003) or ""
                btn.BackgroundTransparency = state and 0.3 or 0.7
                if callback then callback(state) end
            end
            assignLayoutOrder(frame)
            return data, frame
        end

        function tab:AddTextBox(placeholder, callback, clearOnEnter)
            local tb = Instance.new("TextBox")
            tb.Size = UDim2.new(1, 0, 0, 35)
            tb.BackgroundColor3 = Color3.fromRGB(255,255,255)
            tb.BackgroundTransparency = 0.8
            tb.BorderSizePixel = 0
            tb.Font = Enum.Font.GothamSemibold
            tb.PlaceholderColor3 = Color3.fromRGB(200,200,200)
            tb.PlaceholderText = placeholder or "Input"
            tb.Text = ""
            tb.TextColor3 = Color3.fromRGB(255,255,255)
            tb.TextSize = 14
            tb.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            tb.TextStrokeTransparency = 0
            tb.Parent = container
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = tb

            tb.FocusLost:Connect(function(enter)
                if enter then
                    if callback and tb.Text ~= "" then
                        callback(tb.Text)
                        if clearOnEnter then tb.Text = "" end
                    end
                end
            end)
            assignLayoutOrder(tb)
            return tb
        end

        function tab:AddSlider(title, callback, options)
            options = options or {}
            local min = options.min or 0
            local max = options.max or 100
            local readonly = options.readonly or false

            local data = {}
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 40)
            frame.BackgroundTransparency = 1
            frame.Parent = container

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 15)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = title or "Slider"
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            label.TextStrokeTransparency = 0
            label.Parent = frame

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(1, -50, 0, 15)
            bg.Position = UDim2.new(0, 0, 0, 20)
            bg.BackgroundColor3 = Color3.fromRGB(255,255,255)
            bg.BackgroundTransparency = 0.8
            bg.BorderSizePixel = 0
            bg.Parent = frame
            local bgCorner = Instance.new("UICorner")
            bgCorner.CornerRadius = UDim.new(0, 7)
            bgCorner.Parent = bg

            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 0, 1, 0)
            indicator.BackgroundColor3 = Color3.fromRGB(110,45,220)
            indicator.BorderSizePixel = 0
            indicator.Parent = bg
            local indCorner = Instance.new("UICorner")
            indCorner.CornerRadius = UDim.new(0, 7)
            indCorner.Parent = indicator

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 45, 0, 15)
            valueLabel.Position = UDim2.new(1, -45, 0, 20)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = "0"
            valueLabel.TextColor3 = Color3.fromRGB(255,255,255)
            valueLabel.TextSize = 12
            valueLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            valueLabel.TextStrokeTransparency = 0
            valueLabel.Parent = frame

            local dragging = false
            local function updateSlider(input)
                local mousePos = GetMouseLocation()
                local relX = mousePos.X - bg.AbsolutePosition.X
                local percent = math.clamp(relX / bg.AbsoluteSize.X, 0, 1)
                TweenService:Create(indicator, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                local val = math.floor((max - min) * percent + min)
                valueLabel.Text = tostring(val)
                if callback then callback(val) end
            end

            bg.MouseEnter:Connect(function() dragging = true; mainFrame.Draggable = false end)
            bg.MouseLeave:Connect(function() dragging = false; mainFrame.Draggable = true end)

            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    spawn(function()
                        while dragging and not readonly do
                            updateSlider(input)
                            RunService.Heartbeat:Wait()
                        end
                    end)
                end
            end)

            function data:Set(val)
                val = tonumber(val) or 0
                val = math.clamp((val - min) / (max - min), 0, 1)
                TweenService:Create(indicator, TweenInfo.new(0.2), {Size = UDim2.new(val, 0, 1, 0)}):Play()
                local realVal = math.floor((max - min) * val + min)
                valueLabel.Text = tostring(realVal)
                if callback then callback(realVal) end
            end
            data:Set(min)
            assignLayoutOrder(frame)
            return data, frame
        end

        function tab:AddKeybind(title, callback, defaultKey)
            local data = {}
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 35)
            frame.BackgroundTransparency = 1
            frame.Parent = container

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = title or "Keybind"
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            label.TextStrokeTransparency = 0
            label.Parent = frame

            local input = Instance.new("TextButton")
            input.Size = UDim2.new(0, 80, 1, -4)
            input.Position = UDim2.new(1, -85, 0, 2)
            input.BackgroundColor3 = Color3.fromRGB(255,255,255)
            input.BackgroundTransparency = 0.7
            input.BorderSizePixel = 0
            input.Font = Enum.Font.GothamSemibold
            input.Text = "RShift"
            input.TextColor3 = Color3.fromRGB(255,255,255)
            input.TextSize = 12
            input.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            input.TextStrokeTransparency = 0
            input.Parent = frame
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 8)
            inputCorner.Parent = input

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
                input.Text = keyNames[newKey.Name] or newKey.Name
            end

            UserInputService.InputBegan:Connect(function(inputObj, processed)
                if binding then return end
                if inputObj.KeyCode == currentKey and not processed then
                    if callback then callback(currentKey) end
                end
            end)

            input.MouseButton1Click:Connect(function()
                if binding then return end
                binding = true
                input.Text = "..."
                local newInput = UserInputService.InputBegan:Wait()
                setKey(newInput.KeyCode)
                binding = false
            end)

            setKey(defaultKey or Enum.KeyCode.RightShift)
            function data:SetKeybind(newKey) setKey(newKey) end
            assignLayoutOrder(frame)
            return data, frame
        end

        function tab:AddDropdown(title, callback)
            local data = {}
            local dropdown = Instance.new("TextButton")
            dropdown.Size = UDim2.new(1, 0, 0, 35)
            dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
            dropdown.BackgroundTransparency = 0.8
            dropdown.BorderSizePixel = 0
            dropdown.Font = Enum.Font.GothamBold
            dropdown.Text = " " .. (title or "Dropdown")
            dropdown.TextColor3 = Color3.fromRGB(255,255,255)
            dropdown.TextSize = 14
            dropdown.TextXAlignment = Enum.TextXAlignment.Left
            dropdown.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            dropdown.TextStrokeTransparency = 0
            dropdown.Parent = container
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = dropdown

            local currentOptions = {}
            local popup = nil

            local function openPopup()
                if popup then popup:Destroy() end
                if #currentOptions == 0 then return end
                popup = createFloatingDropdown(dropdown, currentOptions, function(selected)
                    dropdown.Text = " [ " .. selected .. " ]"
                    if callback then callback(selected) end
                end)
            end

            dropdown.MouseButton1Click:Connect(function()
                openPopup()
            end)

            function data:Add(option)
                table.insert(currentOptions, option)
                return data
            end

            assignLayoutOrder(dropdown)
            return data, dropdown
        end

        function tab:AddColorPicker(callback)
            local data = {}
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 110)
            frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
            frame.BackgroundTransparency = 0.8
            frame.BorderSizePixel = 0
            frame.Parent = container
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame

            local palette = Instance.new("ImageLabel")
            palette.Size = UDim2.new(0, 100, 0, 100)
            palette.Position = UDim2.new(0.05, 0, 0.05, 0)
            palette.BackgroundColor3 = Color3.new(1,1,1)
            palette.BackgroundTransparency = 1
            palette.Image = "rbxassetid://698052001"
            palette.ScaleType = Enum.ScaleType.Slice
            palette.SliceCenter = Rect.new(4,4,4,4)
            palette.Parent = frame

            local palIndicator = Instance.new("ImageLabel")
            palIndicator.Size = UDim2.new(0,5,0,5)
            palIndicator.BackgroundTransparency = 1
            palIndicator.ZIndex = 2
            palIndicator.Image = "rbxassetid://2851926732"
            palIndicator.ImageColor3 = Color3.new(0,0,0)
            palIndicator.ScaleType = Enum.ScaleType.Slice
            palIndicator.SliceCenter = Rect.new(12,12,12,12)
            palIndicator.Parent = palette

            local sample = Instance.new("ImageLabel")
            sample.Size = UDim2.new(0,25,0,25)
            sample.Position = UDim2.new(0.8,0,0.05,0)
            sample.BackgroundTransparency = 1
            sample.Image = "rbxassetid://2851929490"
            sample.ScaleType = Enum.ScaleType.Slice
            sample.SliceCenter = Rect.new(4,4,4,4)
            sample.Parent = frame

            local saturation = Instance.new("ImageLabel")
            saturation.Size = UDim2.new(0,15,0,100)
            saturation.Position = UDim2.new(0.65,0,0.05,0)
            saturation.BackgroundColor3 = Color3.new(1,1,1)
            saturation.Image = "rbxassetid://3641079629"
            saturation.Parent = frame

            local satIndicator = Instance.new("Frame")
            satIndicator.Size = UDim2.new(0,20,0,2)
            satIndicator.BackgroundColor3 = Color3.new(1,1,1)
            satIndicator.BorderSizePixel = 0
            satIndicator.ZIndex = 2
            satIndicator.Parent = saturation

            local h, s, v = 0, 1, 1
            local function update()
                local color = Color3.fromHSV(h, s, v)
                sample.ImageColor3 = color
                saturation.ImageColor3 = Color3.fromHSV(h, 1, 1)
                if callback then callback(color) end
            end
            update()

            local function onPalette()
                local mousePos = GetMouseLocation()
                local x = math.clamp((mousePos.X - palette.AbsolutePosition.X) / palette.AbsoluteSize.X, 0, 1)
                local y = math.clamp(1 - (mousePos.Y - palette.AbsolutePosition.Y) / palette.AbsoluteSize.Y, 0, 1)
                h = x
                s = y
                TweenService:Create(palIndicator, TweenInfo.new(0.1), {Position = UDim2.new(x, -palIndicator.Size.X.Offset/2, y, -palIndicator.Size.Y.Offset/2)}):Play()
                update()
            end

            local function onSaturation()
                local mousePos = GetMouseLocation()
                local y = math.clamp(1 - (mousePos.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y, 0, 1)
                v = y
                TweenService:Create(satIndicator, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, y, -satIndicator.Size.Y.Offset/2)}):Play()
                update()
            end

            local draggingPalette, draggingSaturation = false, false
            palette.MouseEnter:Connect(function() draggingPalette = true; mainFrame.Draggable = false end)
            palette.MouseLeave:Connect(function() draggingPalette = false; mainFrame.Draggable = true end)
            saturation.MouseEnter:Connect(function() draggingSaturation = true; mainFrame.Draggable = false end)
            saturation.MouseLeave:Connect(function() draggingSaturation = false; mainFrame.Draggable = true end)

            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    spawn(function()
                        while draggingPalette do
                            onPalette()
                            RunService.Heartbeat:Wait()
                        end
                    end)
                    spawn(function()
                        while draggingSaturation do
                            onSaturation()
                            RunService.Heartbeat:Wait()
                        end
                    end)
                end
            end)

            function data:Set(color)
                local r, g, b = color.r * 255, color.g * 255, color.b * 255
                local h2, s2, v2 = rgbtohsv(r, g, b)
                h, s, v = h2, s2, v2
                sample.ImageColor3 = color
                saturation.ImageColor3 = Color3.fromHSV(h, 1, 1)
                if callback then callback(color) end
            end
            assignLayoutOrder(frame)
            return data, frame
        end

        function tab:AddConsole(options)
            options = options or {}
            local full = options.full or false
            local height = options.y or 200
            local readonly = options.readonly or false
            local sourceType = options.source or "Logs"

            local data = {}
            local console = Instance.new("Frame")
            console.Size = UDim2.new(1, 0, full and 1 or 0, height)
            console.BackgroundColor3 = Color3.fromRGB(255,255,255)
            console.BackgroundTransparency = 0.8
            console.BorderSizePixel = 0
            console.Parent = container
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = console

            local sf = Instance.new("ScrollingFrame")
            sf.Size = UDim2.new(1, 0, 1, 0)
            sf.BackgroundTransparency = 1
            sf.BorderSizePixel = 0
            sf.CanvasSize = UDim2.new(0, 0, 0, 0)
            sf.ScrollBarThickness = 4
            sf.Parent = console

            local source = Instance.new("TextBox")
            source.Size = UDim2.new(1, -40, 1, 0)
            source.Position = UDim2.new(0, 40, 0, 0)
            source.BackgroundTransparency = 1
            source.ClearTextOnFocus = false
            source.Font = Enum.Font.Code
            source.MultiLine = true
            source.Text = ""
            source.TextColor3 = Color3.fromRGB(255,255,255)
            source.TextSize = 15
            source.TextXAlignment = Enum.TextXAlignment.Left
            source.TextYAlignment = Enum.TextYAlignment.Top
            source.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            source.TextStrokeTransparency = 0
            source.Parent = sf
            source.TextEditable = not readonly

            local lines = Instance.new("TextLabel")
            lines.Size = UDim2.new(0, 40, 1, 0)
            lines.BackgroundTransparency = 1
            lines.BorderSizePixel = 0
            lines.Font = Enum.Font.Code
            lines.Text = "1\n"
            lines.TextColor3 = Color3.fromRGB(255,255,255)
            lines.TextSize = 15
            lines.TextYAlignment = Enum.TextYAlignment.Top
            lines.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            lines.TextStrokeTransparency = 0
            lines.Parent = sf

            function data:Set(text)
                source.Text = tostring(text)
            end
            function data:Get()
                return source.Text
            end
            function data:Log(msg)
                source.Text = source.Text .. "[*] " .. tostring(msg) .. "\n"
            end
            assignLayoutOrder(console)
            return data, console
        end

        function tab:AddHorizontalAlignment()
            local data = {}
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 20)
            frame.BackgroundTransparency = 1
            frame.Parent = container
            local layout = Instance.new("UIListLayout")
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.Padding = UDim.new(0, 5)
            layout.Parent = frame

            function data:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0, 100, 0, 20)
                btn.BackgroundColor3 = Color3.fromRGB(110,45,220)
                btn.BorderSizePixel = 0
                btn.Font = Enum.Font.GothamBold
                btn.Text = text or "Button"
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.TextSize = 12
                btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                btn.TextStrokeTransparency = 0
                btn.Parent = frame
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = btn
                btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                return btn
            end
            assignLayoutOrder(frame)
            return data, frame
        end

        function tab:AddFolder(name)
            local data = {}
            local folder = Instance.new("Frame")
            folder.Size = UDim2.new(1, 0, 0, 35)
            folder.BackgroundColor3 = Color3.fromRGB(255,255,255)
            folder.BackgroundTransparency = 0.8
            folder.BorderSizePixel = 0
            folder.Parent = container
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = folder

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.BackgroundTransparency = 1
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.GothamSemibold
            btn.Text = "▼ " .. (name or "Folder")
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.TextSize = 14
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            btn.TextStrokeTransparency = 0
            btn.Parent = folder

            local objects = Instance.new("Frame")
            objects.Size = UDim2.new(1, -10, 1, -35)
            objects.Position = UDim2.new(0, 10, 0, 40)
            objects.BackgroundTransparency = 1
            objects.Visible = false
            objects.Parent = folder
            local objLayout = Instance.new("UIListLayout")
            objLayout.Padding = UDim.new(0, 5)
            objLayout.Parent = objects

            local open = false
            btn.MouseButton1Click:Connect(function()
                open = not open
                objects.Visible = open
                btn.Text = (open and "▲ " or "▼ ") .. (name or "Folder")
                local function updateHeight()
                    local count = #objects:GetChildren()
                    local height = 35
                    if open then
                        for _, child in ipairs(objects:GetChildren()) do
                            if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextBox") then
                                height = height + child.Size.Y.Offset + 5
                            end
                        end
                    end
                    TweenService:Create(folder, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, height)}):Play()
                end
                updateHeight()
                objects.ChildAdded:Connect(updateHeight)
                objects.ChildRemoved:Connect(updateHeight)
            end)

            for method, func in pairs(tab) do
                if type(func) == "function" and method ~= "AddFolder" then
                    data[method] = function(...)
                        local result = func(...)
                        if typeof(result) == "table" then
                            local obj, elem = result[1], result[2]
                            if elem then elem.Parent = objects end
                            return obj, elem
                        else
                            result.Parent = objects
                            return result
                        end
                    end
                end
            end
            data.AddFolder = tab.AddFolder

            assignLayoutOrder(folder)
            return data, folder
        end

        -- Store tab data
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

    -- Additional window methods
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

    -- Toggle visibility with key
    local function ToggleVisibility()
        screenGui.Enabled = not screenGui.Enabled
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == toggleKey then
            ToggleVisibility()
        end
    end)

    return window
end

return Library
