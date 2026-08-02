local ui_options = {
    main_color = Color3.fromRGB(150, 80, 255),
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
local circle = Instance.new("ImageLabel")
local uiListLayout3 = Instance.new("UIListLayout")
local windowsFrame = Instance.new("Frame")

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

uiListLayout3.Parent = prefabs
uiListLayout3.FillDirection = Enum.FillDirection.Horizontal
uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout3.Padding = UDim.new(0, 20)

windowsFrame.Name = "Windows"
windowsFrame.Parent = imgui
windowsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
windowsFrame.BackgroundTransparency = 1
windowsFrame.Position = UDim2.new(0, 20, 0, 20)
windowsFrame.Size = UDim2.new(1, 20, 1, -20)

--[[ Script ]]--
local root = imgui
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("RunService")
local ps = game:GetService("Players")
local p = ps.LocalPlayer
local mouse = p:GetMouse()
local Prefabs = prefabs
local Windows = windowsFrame

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

local function gMouse()
    return Vector2.new(UIS:GetMouseLocation().X + 1, UIS:GetMouseLocation().Y - 35)
end

local function ripple(button, x, y)
    task.spawn(function()
        button.ClipsDescendants = true
        local circleClone = prefabs:FindFirstChild("Circle"):Clone()
        circleClone.Parent = button
        circleClone.ZIndex = 1000
        local new_x = x - circleClone.AbsolutePosition.X
        local new_y = y - circleClone.AbsolutePosition.Y
        circleClone.Position = UDim2.new(0, new_x, 0, new_y)
        local size = 0
        if button.AbsoluteSize.X > button.AbsoluteSize.Y then
            size = button.AbsoluteSize.X * 1.5
        elseif button.AbsoluteSize.X < button.AbsoluteSize.Y then
            size = button.AbsoluteSize.Y * 1.5
        elseif button.AbsoluteSize.X == button.AbsoluteSize.Y then
            size = button.AbsoluteSize.X * 1.5
        end
        circleClone:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size / 2, 0.5, -size / 2), "Out", "Quad", 0.5, false, nil)
        Resize(circleClone, {ImageTransparency = 1}, 0.5)
        task.wait(0.5)
        circleClone:Destroy()
    end)
end

local windows = 0
local library = {}

local function format_windows()
    local ull = prefabs:FindFirstChild("UIListLayout"):Clone()
    ull.Parent = windowsFrame
    local data = {}
    for i, v in pairs(windowsFrame:GetChildren()) do
        if not (v:IsA("UIListLayout")) then
            data[v] = v.AbsolutePosition
        end
    end
    ull:Destroy()
    for i, v in pairs(data) do
        i.Position = UDim2.new(0, v.X, 0, v.Y)
    end
end

function library:FormatWindows()
    format_windows()
end

-- Helper function to create panels with new background
local function CreatePanel(name, anchorPos, size, cornerRadius, zIndex, parent)
    local panel = {}

    panel.Shadow = Instance.new("Frame")
    panel.Shadow.Name = name .. "Shadow"
    panel.Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Shadow.Position = anchorPos + UDim2.new(0, 0, 0, 8)
    panel.Shadow.Size = size
    panel.Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panel.Shadow.BackgroundTransparency = 0.5
    panel.Shadow.BorderSizePixel = 0
    panel.Shadow.ZIndex = zIndex or 0
    panel.Shadow.Parent = parent or windowsFrame
    Instance.new("UICorner", panel.Shadow).CornerRadius = UDim.new(0, cornerRadius or 20)

    panel.Frame = Instance.new("Frame")
    panel.Frame.Name = name
    panel.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Frame.Position = anchorPos
    panel.Frame.Size = size
    panel.Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    panel.Frame.BackgroundTransparency = 0
    panel.Frame.BorderSizePixel = 0
    panel.Frame.Parent = parent or windowsFrame
    Instance.new("UICorner", panel.Frame).CornerRadius = UDim.new(0, cornerRadius or 20)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = panel.Frame

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(150, 80, 255)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(200, 130, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236, 198, 255))
    }
    gradient.Parent = panel.Frame

    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.fromScale(1, 1)
    bgImage.BackgroundTransparency = 1
    bgImage.BorderSizePixel = 0
    bgImage.Image = "rbxassetid://16736132788"
    bgImage.ImageTransparency = 0
    bgImage.ScaleType = Enum.ScaleType.Stretch
    bgImage.Parent = panel.Frame
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, cornerRadius or 20)

    return panel
end

function library:AddWindow(title, options)
    windows = windows + 1
    local dropdown_open = false
    title = tostring(title or "New Window")
    options = (typeof(options) == "table") and options or ui_options
    options.tween_time = 0.1

    -- LAYOUT PARAMETERS
    local MainWidth = 0.43
    local MainHeight = 0.90
    local SideWidth = 0.14
    local SideHeight = 0.90
    local Gap = 0.025

    -- Main panel (perfectly centered)
    local MainSize = UDim2.fromScale(MainWidth, MainHeight)
    local MainPos = UDim2.fromScale(0.5, 0.5)
    local MainPanel = CreatePanel("Main_" .. windows, MainPos, MainSize, 20, 1, windowsFrame)

    -- Side panel
    local SideX = (0.5 - MainWidth / 2) - Gap - SideWidth / 2
    local SidePos = UDim2.new(SideX, 0, 0.5, 0)
    local SideSize = UDim2.fromScale(SideWidth, SideHeight)
    local SidePanel = CreatePanel("Side_" .. windows, SidePos, SideSize, 20, 1, windowsFrame)

    -- HEADER - HIGHER (10% overlap with main panel)
    local HeaderShadow = Instance.new("Frame")
    HeaderShadow.Name = "HeaderShadow"
    HeaderShadow.AnchorPoint = Vector2.new(0.5, 0)
    HeaderShadow.Position = UDim2.new(0.5, 2, -0.06, 4)      -- higher (was -0.07)
    HeaderShadow.Size = UDim2.fromScale(0.43, 0.16)           -- match main width
    HeaderShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    HeaderShadow.BackgroundTransparency = 0.4
    HeaderShadow.BorderSizePixel = 0
    HeaderShadow.ZIndex = 0
    HeaderShadow.Parent = MainPanel.Frame
    Instance.new("UICorner", HeaderShadow).CornerRadius = UDim.new(0, 18)

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.AnchorPoint = Vector2.new(0.5, 0)
    Header.Position = UDim2.new(0.5, 0, -0.06, 0)            -- higher (was -0.07)
    Header.Size = UDim2.fromScale(0.43, 0.16)                 -- match main width
    Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Header.BackgroundTransparency = 0.15
    Header.BorderSizePixel = 0
    Header.Parent = MainPanel.Frame
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

    local HeaderGradient = MainPanel.Frame:FindFirstChildWhichIsA("UIGradient"):Clone()
    HeaderGradient.Parent = Header

    local HeaderBg = Instance.new("ImageLabel")
    HeaderBg.Size = UDim2.fromScale(1, 1)
    HeaderBg.BackgroundTransparency = 1
    HeaderBg.BorderSizePixel = 0
    HeaderBg.Image = "rbxassetid://16736132788"
    HeaderBg.ImageTransparency = 0
    HeaderBg.ScaleType = Enum.ScaleType.Stretch
    HeaderBg.Parent = Header
    Instance.new("UICorner", HeaderBg).CornerRadius = UDim.new(0, 18)

    -- Header title with auto-matched drop shadow
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.fromScale(0.85, 0.8)
    titleContainer.Position = UDim2.fromScale(0.05, 0.1)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = Header

    local titleShadow = Instance.new("TextLabel")
    titleShadow.Name = "TitleShadow"
    titleShadow.Size = UDim2.fromScale(1, 1)
    titleShadow.Position = UDim2.new(0.005, 0, 0.005, 0)
    titleShadow.BackgroundTransparency = 1
    titleShadow.Font = Enum.Font.GothamBlack
    titleShadow.Text = title
    titleShadow.TextScaled = true
    titleShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
    titleShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleShadow.TextStrokeTransparency = 0.5
    titleShadow.Parent = titleContainer

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.fromScale(1, 1)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.Text = title
    TitleLabel.TextScaled = true
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TitleLabel.TextStrokeTransparency = 0.3
    TitleLabel.Parent = titleContainer

    -- CLOSE BUTTON - ORIGINAL POSITION (top-right of main panel, no offset)
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseButton.Position = UDim2.new(1, 0, 0, 0)   -- original position
    CloseButton.Size = UDim2.fromOffset(56, 56)
    CloseButton.BackgroundTransparency = 1
    CloseButton.BorderSizePixel = 0
    CloseButton.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114840795551292&width=678&height=810&format=png"
    CloseButton.ScaleType = Enum.ScaleType.Fit
    CloseButton.ZIndex = 10
    CloseButton.Parent = MainPanel.Frame
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

    CloseButton.MouseEnter:Connect(function()
        CloseButton:TweenSize(UDim2.fromOffset(60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)
    CloseButton.MouseLeave:Connect(function()
        CloseButton:TweenSize(UDim2.fromOffset(56, 56), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)

    -- MINIMIZED STATE (restore button) with PORTAL IMAGE + ANIMATION
    local MinimizedFrame = Instance.new("ImageButton")
    MinimizedFrame.Name = "MinimizedFrame_" .. windows
    MinimizedFrame.AnchorPoint = Vector2.new(1, 0)
    MinimizedFrame.Position = UDim2.new(1, -50, 0, 20)
    MinimizedFrame.Size = UDim2.fromOffset(60, 60)
    MinimizedFrame.BackgroundTransparency = 1
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Visible = false
    MinimizedFrame.ZIndex = 100
    MinimizedFrame.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=108067574147759&width=678&height=810&format=png"
    MinimizedFrame.ScaleType = Enum.ScaleType.Fit
    MinimizedFrame.Parent = windowsFrame
    Instance.new("UICorner", MinimizedFrame).CornerRadius = UDim.new(1, 0)

    local MinimizedStroke = Instance.new("UIStroke")
    MinimizedStroke.Color = Color3.fromRGB(0, 200, 80)
    MinimizedStroke.Thickness = 2
    MinimizedStroke.Transparency = 0.3
    MinimizedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MinimizedStroke.Parent = MinimizedFrame

    local portalConnection = nil
    local portalAngle = 0

    local function startPortalAnimation()
        if portalConnection then return end
        portalAngle = 0
        portalConnection = RS.Heartbeat:Connect(function(dt)
            portalAngle = portalAngle + dt * 45
            MinimizedFrame.Rotation = portalAngle
            local pulse = 1 + 0.05 * math.sin(tick() * 1.0)
            MinimizedFrame.Size = UDim2.fromOffset(60 * pulse, 60 * pulse)
        end)
    end

    local function stopPortalAnimation()
        if portalConnection then
            portalConnection:Disconnect()
            portalConnection = nil
        end
        MinimizedFrame.Rotation = 0
        MinimizedFrame.Size = UDim2.fromOffset(60, 60)
    end

    local isMinimized = false
    CloseButton.MouseButton1Click:Connect(function()
        if not isMinimized then
            local targetPos = UDim2.new(1, -40, 0, 40)
            local targetSize = UDim2.fromScale(0.05, 0.05)
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

            TweenService:Create(MainPanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
            TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0, 0, 0, 8)}):Play()
            TweenService:Create(SidePanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0, 0, 0, 0)}):Play()
            TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0, 0, 0, 8)}):Play()

            task.wait(0.3)
            MainPanel.Frame.Visible = false
            MainPanel.Shadow.Visible = false
            SidePanel.Frame.Visible = false
            SidePanel.Shadow.Visible = false

            MinimizedFrame.Visible = true
            MinimizedFrame.Size = UDim2.fromOffset(0, 0)
            MinimizedFrame:TweenSize(UDim2.fromOffset(60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
            task.wait(0.35)
            startPortalAnimation()
            isMinimized = true
        end
    end)

    MinimizedFrame.MouseButton1Click:Connect(function()
        stopPortalAnimation()
        MinimizedFrame.Visible = false
        MainPanel.Frame.Visible = true
        MainPanel.Shadow.Visible = true
        SidePanel.Frame.Visible = true
        SidePanel.Shadow.Visible = true

        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(MainPanel.Frame, tweenInfo, {Size = MainSize, Position = MainPos}):Play()
        TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = MainSize, Position = MainPos + UDim2.new(0, 0, 0, 8)}):Play()
        TweenService:Create(SidePanel.Frame, tweenInfo, {Size = SideSize, Position = SidePos}):Play()
        TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = SideSize, Position = SidePos + UDim2.new(0, 0, 0, 8)}):Play()
        isMinimized = false
    end)

    -- Store references
    local window_data = {}
    local Window = MainPanel.Frame
    local Tabs = Instance.new("Frame")
    Tabs.Name = "Tabs"
    Tabs.Size = UDim2.new(1, -20, 1, -40)
    Tabs.Position = UDim2.new(0, 10, 0, 30)
    Tabs.BackgroundTransparency = 1
    Tabs.BorderSizePixel = 0
    Tabs.Parent = MainPanel.Frame

    -- TabButtons with drop shadow
    local TabButtonsShadow = Instance.new("Frame")
    TabButtonsShadow.Name = "TabButtonsShadow"
    TabButtonsShadow.Size = UDim2.new(1, -10, 1, -20)
    TabButtonsShadow.Position = UDim2.new(0, 5, 0, 10)
    TabButtonsShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonsShadow.BackgroundTransparency = 0.5
    TabButtonsShadow.BorderSizePixel = 0
    TabButtonsShadow.ZIndex = 0
    TabButtonsShadow.Parent = SidePanel.Frame
    Instance.new("UICorner", TabButtonsShadow).CornerRadius = UDim.new(0, 10)

    local TabButtons = Instance.new("ScrollingFrame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, -10, 1, -20)
    TabButtons.Position = UDim2.new(0, 5, 0, 10)
    TabButtons.BackgroundTransparency = 1
    TabButtons.BorderSizePixel = 0
    TabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtons.ScrollBarThickness = 4
    TabButtons.ZIndex = 1
    TabButtons.Parent = SidePanel.Frame

    local TabButtonsList = Instance.new("UIListLayout")
    TabButtonsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsList.Padding = UDim.new(0, 5)
    TabButtonsList.Parent = TabButtons

    do -- Add Tab
        function window_data:AddTab(tab_name)
            local tab_data = {}
            tab_name = tostring(tab_name or "New Tab")

            -- Tab button with background image
            local new_button = Instance.new("ImageButton")
            new_button.Name = "TabButton_" .. tab_name
            new_button.Size = UDim2.new(1, 0, 0, 35)
            new_button.BackgroundTransparency = 1
            new_button.BorderSizePixel = 0
            new_button.Image = "rbxassetid://16736132788"
            new_button.ImageTransparency = 0.3
            new_button.ScaleType = Enum.ScaleType.Stretch
            new_button.Parent = TabButtons
            Instance.new("UICorner", new_button).CornerRadius = UDim.new(0, 10)

            -- Tab button label - Gotham Black with auto-matched drop shadow
            local buttonContainer = Instance.new("Frame")
            buttonContainer.Size = UDim2.new(1, 0, 1, 0)
            buttonContainer.BackgroundTransparency = 1
            buttonContainer.Parent = new_button

            local buttonShadow = Instance.new("TextLabel")
            buttonShadow.Name = "ButtonShadow"
            buttonShadow.Size = UDim2.new(1, 0, 1, 0)
            buttonShadow.Position = UDim2.new(0.005, 0, 0.005, 0)
            buttonShadow.BackgroundTransparency = 1
            buttonShadow.Font = Enum.Font.GothamBlack
            buttonShadow.Text = tab_name
            buttonShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
            buttonShadow.TextScaled = true
            buttonShadow.TextSize = 14
            buttonShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            buttonShadow.TextStrokeTransparency = 0.5
            buttonShadow.Parent = buttonContainer

            local buttonLabel = Instance.new("TextLabel")
            buttonLabel.Name = "ButtonLabel"
            buttonLabel.Size = UDim2.new(1, 0, 1, 0)
            buttonLabel.Position = UDim2.new(0, 0, 0, 0)
            buttonLabel.BackgroundTransparency = 1
            buttonLabel.Font = Enum.Font.GothamBlack
            buttonLabel.Text = tab_name
            buttonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            buttonLabel.TextScaled = true
            buttonLabel.TextSize = 14
            buttonLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            buttonLabel.TextStrokeTransparency = 0.3
            buttonLabel.Parent = buttonContainer

            -- Update canvas size
            TabButtons.CanvasSize = UDim2.new(0, 0, 0, (#TabButtons:GetChildren() - 1) * 40)

            -- Tab content container (transparent)
            local tabContainer = Instance.new("ScrollingFrame")
            tabContainer.Name = "TabContainer_" .. tab_name
            tabContainer.Size = UDim2.new(1, 0, 1, 0)
            tabContainer.BackgroundTransparency = 1
            tabContainer.BorderSizePixel = 0
            tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            tabContainer.ScrollBarThickness = 4
            tabContainer.Visible = false
            tabContainer.Parent = Tabs

            local tabLayout = Instance.new("UIListLayout")
            tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            tabLayout.Padding = UDim.new(0, 5)
            tabLayout.Parent = tabContainer

            tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
            end)
            task.delay(0.1, function()
                tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
            end)

            -- Highlight indicator
            local selectedIndicator = Instance.new("Frame")
            selectedIndicator.Name = "SelectedIndicator"
            selectedIndicator.Size = UDim2.new(0, 4, 0, 4)
            selectedIndicator.Position = UDim2.new(0, 1, 0.5)
            selectedIndicator.AnchorPoint = Vector2.new(0, 0.5)
            selectedIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectedIndicator.BackgroundTransparency = 1
            selectedIndicator.BorderSizePixel = 0
            selectedIndicator.Parent = new_button
            Instance.new("UICorner", selectedIndicator).CornerRadius = UDim.new(0.5, 0)

            local function show()
                if dropdown_open then return end
                for i, v in pairs(TabButtons:GetChildren()) do
                    if v:IsA("ImageButton") then
                        v.ImageTransparency = 0.3
                        local ind = v:FindFirstChild("SelectedIndicator")
                        if ind then
                            ind.Size = UDim2.new(0, 4, 0, 4)
                            ind.BackgroundTransparency = 1
                        end
                    end
                end
                for i, v in pairs(Tabs:GetChildren()) do
                    if v:IsA("ScrollingFrame") and v ~= tabContainer then
                        v.Visible = false
                    end
                end
                new_button.ImageTransparency = 0
                if selectedIndicator then
                    selectedIndicator.Size = UDim2.new(0, 4, 0, 16)
                    selectedIndicator.BackgroundTransparency = 0
                end
                tabContainer.Visible = true
                task.delay(0.05, function()
                    tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
                end)
            end

            new_button.MouseButton1Click:Connect(function()
                show()
            end)

            function tab_data:Show()
                show()
            end

            -- LABEL - NO DROP SHADOW (just TextStroke)
            function tab_data:AddLabel(label_text)
                label_text = tostring(label_text or "New Label")
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 20)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamBlack
                label.Text = label_text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                label.TextStrokeTransparency = 0.3
                label.Parent = tabContainer
                return label
            end

            function tab_data:AddButton(button_text, callback)
                button_text = tostring(button_text or "New Button")
                callback = typeof(callback) == "function" and callback or function() end

                local buttonFrame = Instance.new("Frame")
                buttonFrame.Size = UDim2.new(1, 0, 0, 35)
                buttonFrame.BackgroundTransparency = 1
                buttonFrame.BorderSizePixel = 0
                buttonFrame.Parent = tabContainer

                local shadow = Instance.new("Frame")
                shadow.Size = UDim2.new(1, 0, 1, 0)
                shadow.Position = UDim2.new(0, 0, 0, 4)
                shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                shadow.BackgroundTransparency = 0.4
                shadow.BorderSizePixel = 0
                shadow.Parent = buttonFrame
                Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 10)

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 1, 0)
                button.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
                button.BorderSizePixel = 0
                button.Font = Enum.Font.GothamBlack
                button.Text = button_text
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 14
                button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                button.TextStrokeTransparency = 0.3
                button.Parent = buttonFrame
                Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

                local offsetX, offsetY = math.floor(14*0.15), math.floor(14*0.15)
                local textShadow = Instance.new("TextLabel")
                textShadow.Size = UDim2.new(1, 0, 1, 0)
                textShadow.Position = UDim2.new(0, offsetX, 0, offsetY)
                textShadow.BackgroundTransparency = 1
                textShadow.Font = Enum.Font.GothamBlack
                textShadow.Text = button_text
                textShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                textShadow.TextSize = 14
                textShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                textShadow.TextStrokeTransparency = 0.5
                textShadow.Parent = button
                textShadow.ZIndex = 0

                button.Text = button_text
                button.ZIndex = 1

                local btnGradient = Instance.new("UIGradient")
                btnGradient.Rotation = 90
                btnGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(150, 80, 255)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 130, 255))
                }
                btnGradient.Parent = button

                button.MouseButton1Click:Connect(function()
                    ripple(button, mouse.X, mouse.Y)
                    pcall(callback)
                end)
                return button
            end

            function tab_data:AddSwitch(switch_text, callback)
                local switch_data = {}
                switch_text = tostring(switch_text or "New Switch")
                callback = typeof(callback) == "function" and callback or function() end

                local switchFrame = Instance.new("Frame")
                switchFrame.Size = UDim2.new(1, 0, 0, 35)
                switchFrame.BackgroundTransparency = 1
                switchFrame.BorderSizePixel = 0
                switchFrame.Parent = tabContainer

                local labelContainer = Instance.new("Frame")
                labelContainer.Size = UDim2.new(1, -70, 1, 0)
                labelContainer.Position = UDim2.new(0, 0, 0, 0)
                labelContainer.BackgroundTransparency = 1
                labelContainer.Parent = switchFrame

                local offsetX, offsetY = 2, 2
                local labelShadow = Instance.new("TextLabel")
                labelShadow.Size = UDim2.new(1, 0, 1, 0)
                labelShadow.Position = UDim2.new(0, offsetX, 0, offsetY)
                labelShadow.BackgroundTransparency = 1
                labelShadow.Font = Enum.Font.GothamBlack
                labelShadow.Text = switch_text
                labelShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                labelShadow.TextSize = 14
                labelShadow.TextXAlignment = Enum.TextXAlignment.Left
                labelShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                labelShadow.TextStrokeTransparency = 0.5
                labelShadow.Parent = labelContainer

                local titleLabel = Instance.new("TextLabel")
                titleLabel.Size = UDim2.new(1, 0, 1, 0)
                titleLabel.Position = UDim2.new(0, 0, 0, 0)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Font = Enum.Font.GothamBlack
                titleLabel.Text = switch_text
                titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                titleLabel.TextSize = 14
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                titleLabel.TextStrokeTransparency = 0.3
                titleLabel.Parent = labelContainer

                local toggleContainer = Instance.new("Frame")
                toggleContainer.Size = UDim2.new(0, 55, 1, 0)
                toggleContainer.Position = UDim2.new(1, -60, 0, 0)
                toggleContainer.BackgroundTransparency = 1
                toggleContainer.Parent = switchFrame

                local toggleShadow = Instance.new("Frame")
                toggleShadow.Size = UDim2.new(1, 0, 1, 0)
                toggleShadow.Position = UDim2.new(0, 0, 0, 3)
                toggleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                toggleShadow.BackgroundTransparency = 0.4
                toggleShadow.BorderSizePixel = 0
                toggleShadow.Parent = toggleContainer
                Instance.new("UICorner", toggleShadow).CornerRadius = UDim.new(1, 0)

                local toggleButton = Instance.new("TextButton")
                toggleButton.Size = UDim2.new(1, 0, 1, 0)
                toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                toggleButton.BorderSizePixel = 0
                toggleButton.Font = Enum.Font.GothamBlack
                toggleButton.Text = "OFF"
                toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleButton.TextSize = 12
                toggleButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                toggleButton.TextStrokeTransparency = 0.3
                toggleButton.Parent = toggleContainer
                Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(1, 0)

                local offX, offY = math.floor(12*0.15), math.floor(12*0.15)
                local toggleTextShadow = Instance.new("TextLabel")
                toggleTextShadow.Size = UDim2.new(1, 0, 1, 0)
                toggleTextShadow.Position = UDim2.new(0, offX, 0, offY)
                toggleTextShadow.BackgroundTransparency = 1
                toggleTextShadow.Font = Enum.Font.GothamBlack
                toggleTextShadow.Text = "OFF"
                toggleTextShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                toggleTextShadow.TextSize = 12
                toggleTextShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                toggleTextShadow.TextStrokeTransparency = 0.5
                toggleTextShadow.Parent = toggleButton
                toggleTextShadow.ZIndex = 0

                toggleButton.ZIndex = 1

                local toggled = false

                local function updateToggle(state)
                    toggled = state
                    local targetColor = toggled and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
                    toggleButton.Text = toggled and "ON" or "OFF"
                    toggleTextShadow.Text = toggled and "ON" or "OFF"
                    TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
                    pcall(callback, toggled)
                end

                toggleButton.MouseButton1Click:Connect(function()
                    updateToggle(not toggled)
                end)

                function switch_data:Set(bool)
                    updateToggle((typeof(bool) == "boolean") and bool or false)
                end

                return switch_data, switchFrame
            end

            function tab_data:AddTextBox(textbox_text, callback, textbox_options)
                textbox_text = tostring(textbox_text or "New TextBox")
                callback = typeof(callback) == "function" and callback or function() end
                textbox_options = typeof(textbox_options) == "table" and textbox_options or {["clear"] = true}
                textbox_options = {
                    ["clear"] = ((textbox_options.clear) == true)
                }

                local textbox = Instance.new("TextBox")
                textbox.Size = UDim2.new(1, 0, 0, 35)
                textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textbox.BackgroundTransparency = 0.8
                textbox.BorderSizePixel = 0
                textbox.Font = Enum.Font.GothamBlack
                textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
                textbox.PlaceholderText = textbox_text
                textbox.Text = ""
                textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                textbox.TextSize = 14
                textbox.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                textbox.TextStrokeTransparency = 0.3
                textbox.Parent = tabContainer
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
                return textbox
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

                local slider = Instance.new("Frame")
                slider.Size = UDim2.new(1, 0, 0, 40)
                slider.BackgroundTransparency = 1
                slider.BorderSizePixel = 0
                slider.Parent = tabContainer

                local titleContainer = Instance.new("Frame")
                titleContainer.Size = UDim2.new(1, 0, 0, 15)
                titleContainer.BackgroundTransparency = 1
                titleContainer.Parent = slider

                local offX, offY = 2, 2
                local titleShadow = Instance.new("TextLabel")
                titleShadow.Size = UDim2.new(1, 0, 1, 0)
                titleShadow.Position = UDim2.new(0, offX, 0, offY)
                titleShadow.BackgroundTransparency = 1
                titleShadow.Font = Enum.Font.GothamBlack
                titleShadow.Text = slider_text
                titleShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                titleShadow.TextSize = 12
                titleShadow.TextXAlignment = Enum.TextXAlignment.Left
                titleShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                titleShadow.TextStrokeTransparency = 0.5
                titleShadow.Parent = titleContainer

                local title = Instance.new("TextLabel")
                title.Size = UDim2.new(1, 0, 1, 0)
                title.Position = UDim2.new(0, 0, 0, 0)
                title.BackgroundTransparency = 1
                title.Font = Enum.Font.GothamBlack
                title.Text = slider_text
                title.TextColor3 = Color3.fromRGB(255, 255, 255)
                title.TextSize = 12
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                title.TextStrokeTransparency = 0.3
                title.Parent = titleContainer

                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, -55, 0, 15)
                sliderBg.Position = UDim2.new(0, 0, 0, 20)
                sliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderBg.BackgroundTransparency = 0.8
                sliderBg.BorderSizePixel = 0
                sliderBg.Parent = slider
                Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 7)

                local indicator = Instance.new("Frame")
                indicator.Size = UDim2.new(0, 0, 1, 0)
                indicator.BackgroundColor3 = options.main_color or Color3.fromRGB(150, 80, 255)
                indicator.BorderSizePixel = 0
                indicator.Parent = sliderBg
                Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 7)

                local valueContainer = Instance.new("Frame")
                valueContainer.Size = UDim2.new(0, 45, 0, 20)
                valueContainer.Position = UDim2.new(1, -50, 0, 17)
                valueContainer.BackgroundTransparency = 1
                valueContainer.Parent = slider

                local valueShadow = Instance.new("Frame")
                valueShadow.Size = UDim2.new(1, 0, 1, 0)
                valueShadow.Position = UDim2.new(0, 0, 0, 3)
                valueShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                valueShadow.BackgroundTransparency = 0.4
                valueShadow.BorderSizePixel = 0
                valueShadow.Parent = valueContainer
                Instance.new("UICorner", valueShadow).CornerRadius = UDim.new(1, 0)

                local vOffX, vOffY = math.floor(12*0.15), math.floor(12*0.15)
                local valueTextShadow = Instance.new("TextLabel")
                valueTextShadow.Size = UDim2.new(1, 0, 1, 0)
                valueTextShadow.Position = UDim2.new(0, vOffX, 0, vOffY)
                valueTextShadow.BackgroundTransparency = 1
                valueTextShadow.Font = Enum.Font.GothamBlack
                valueTextShadow.Text = "0"
                valueTextShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                valueTextShadow.TextSize = 12
                valueTextShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                valueTextShadow.TextStrokeTransparency = 0.5
                valueTextShadow.Parent = valueContainer
                valueTextShadow.ZIndex = 0

                local value = Instance.new("TextLabel")
                value.Size = UDim2.new(1, 0, 1, 0)
                value.Position = UDim2.new(0, 0, 0, 0)
                value.BackgroundColor3 = options.main_color or Color3.fromRGB(150, 80, 255)
                value.BorderSizePixel = 0
                value.Font = Enum.Font.GothamBlack
                value.Text = "0"
                value.TextColor3 = Color3.fromRGB(255, 255, 255)
                value.TextSize = 12
                value.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                value.TextStrokeTransparency = 0.3
                value.Parent = valueContainer
                value.ZIndex = 1
                Instance.new("UICorner", value).CornerRadius = UDim.new(1, 0)

                do
                    local dragging = false
                    local dragConn

                    local function updateFromMouse()
                        local mouse_location = gMouse()
                        local x = (sliderBg.AbsoluteSize.X - (sliderBg.AbsoluteSize.X - ((mouse_location.X - sliderBg.AbsolutePosition.X)) + 1)) / sliderBg.AbsoluteSize.X
                        local min, max = 0, 1
                        local size = math.clamp(x, min, max)
                        Resize(indicator, {Size = UDim2.new(size, 0, 1, 0)}, options.tween_time)
                        local pct = math.floor(size * 100)
                        local maxv, minv = slider_options.max, slider_options.min
                        local diff = maxv - minv
                        local sel_value = math.floor(((diff / 100) * pct) + minv)
                        value.Text = tostring(sel_value)
                        valueTextShadow.Text = tostring(sel_value)
                        pcall(callback, sel_value)
                    end

                    sliderBg.InputBegan:Connect(function(inputObject)
                        if slider_options.readonly then return end
                        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            updateFromMouse()
                            if dragConn then dragConn:Disconnect() end
                            dragConn = RS.Heartbeat:Connect(function()
                                if dragging and not dropdown_open then
                                    updateFromMouse()
                                end
                            end)
                        end
                    end)

                    UIS.InputEnded:Connect(function(inputObject)
                        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                            if dragConn then
                                dragConn:Disconnect()
                                dragConn = nil
                            end
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
                        valueTextShadow.Text = tostring(sel_value)
                        pcall(callback, sel_value)
                    end
                    slider_data:Set(slider_options["min"])
                end
                return slider_data, slider
            end

            function tab_data:AddKeybind(keybind_name, callback, keybind_options)
                local keybind_data = {}
                keybind_name = tostring(keybind_name or "New Keybind")
                callback = typeof(callback) == "function" and callback or function() end
                keybind_options = typeof(keybind_options) == "table" and keybind_options or {}
                keybind_options = {
                    ["standard"] = keybind_options.standard or Enum.KeyCode.RightShift,
                }

                local keybindFrame = Instance.new("Frame")
                keybindFrame.Size = UDim2.new(1, 0, 0, 35)
                keybindFrame.BackgroundTransparency = 1
                keybindFrame.BorderSizePixel = 0
                keybindFrame.Parent = tabContainer

                local titleContainer = Instance.new("Frame")
                titleContainer.Size = UDim2.new(0.5, 0, 1, 0)
                titleContainer.BackgroundTransparency = 1
                titleContainer.Parent = keybindFrame

                local offX, offY = 2, 2
                local titleShadow = Instance.new("TextLabel")
                titleShadow.Size = UDim2.new(1, 0, 1, 0)
                titleShadow.Position = UDim2.new(0, offX, 0, offY)
                titleShadow.BackgroundTransparency = 1
                titleShadow.Font = Enum.Font.GothamBlack
                titleShadow.Text = keybind_name
                titleShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                titleShadow.TextSize = 14
                titleShadow.TextXAlignment = Enum.TextXAlignment.Left
                titleShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                titleShadow.TextStrokeTransparency = 0.5
                titleShadow.Parent = titleContainer

                local title = Instance.new("TextLabel")
                title.Size = UDim2.new(1, 0, 1, 0)
                title.Position = UDim2.new(0, 0, 0, 0)
                title.BackgroundTransparency = 1
                title.Font = Enum.Font.GothamBlack
                title.Text = keybind_name
                title.TextColor3 = Color3.fromRGB(255, 255, 255)
                title.TextSize = 14
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                title.TextStrokeTransparency = 0.3
                title.Parent = titleContainer

                local input = Instance.new("TextButton")
                input.Size = UDim2.new(0, 80, 1, -4)
                input.Position = UDim2.new(1, -85, 0, 2)
                input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                input.BackgroundTransparency = 0.7
                input.BorderSizePixel = 0
                input.Font = Enum.Font.GothamBlack
                input.Text = "RShift"
                input.TextColor3 = Color3.fromRGB(255, 255, 255)
                input.TextSize = 12
                input.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                input.TextStrokeTransparency = 0.3
                input.Parent = keybindFrame
                Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

                local inpOffX, inpOffY = math.floor(12*0.15), math.floor(12*0.15)
                local inputTextShadow = Instance.new("TextLabel")
                inputTextShadow.Size = UDim2.new(1, 0, 1, 0)
                inputTextShadow.Position = UDim2.new(0, inpOffX, 0, inpOffY)
                inputTextShadow.BackgroundTransparency = 1
                inputTextShadow.Font = Enum.Font.GothamBlack
                inputTextShadow.Text = "RShift"
                inputTextShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                inputTextShadow.TextSize = 12
                inputTextShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                inputTextShadow.TextStrokeTransparency = 0.5
                inputTextShadow.Parent = input
                inputTextShadow.ZIndex = 0

                input.ZIndex = 1

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
                    inputTextShadow.Text = key
                    keybind = Keybind
                end

                UIS.InputBegan:Connect(function(a, b)
                    if checks.binding then
                        task.spawn(function()
                            task.wait()
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
                    inputTextShadow.Text = "..."
                    checks.binding = true
                    local a, b = UIS.InputBegan:Wait()
                    keybind_data:SetKeybind(a.KeyCode)
                end)

                return keybind_data, keybindFrame
            end

            function tab_data:AddDropdown(dropdown_name, callback)
                local dropdown_data = {}
                dropdown_name = tostring(dropdown_name or "New Dropdown")
                callback = typeof(callback) == "function" and callback or function() end

                local dropdown = Instance.new("TextButton")
                dropdown.Size = UDim2.new(1, 0, 0, 35)
                dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dropdown.BackgroundTransparency = 0.8
                dropdown.BorderSizePixel = 0
                dropdown.Font = Enum.Font.GothamBlack
                dropdown.Text = " " .. dropdown_name
                dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdown.TextSize = 14
                dropdown.TextXAlignment = Enum.TextXAlignment.Left
                dropdown.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                dropdown.TextStrokeTransparency = 0.3
                dropdown.Parent = tabContainer
                dropdown.ZIndex = 10
                Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 10)

                local offX, offY = 2, 2
                local dropdownTextShadow = Instance.new("TextLabel")
                dropdownTextShadow.Size = UDim2.new(1, 0, 1, 0)
                dropdownTextShadow.Position = UDim2.new(0, offX, 0, offY)
                dropdownTextShadow.BackgroundTransparency = 1
                dropdownTextShadow.Font = Enum.Font.GothamBlack
                dropdownTextShadow.Text = " " .. dropdown_name
                dropdownTextShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                dropdownTextShadow.TextSize = 14
                dropdownTextShadow.TextXAlignment = Enum.TextXAlignment.Left
                dropdownTextShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                dropdownTextShadow.TextStrokeTransparency = 0.5
                dropdownTextShadow.Parent = dropdown
                dropdownTextShadow.ZIndex = 0

                dropdown.ZIndex = 1

                local indicator = Instance.new("TextLabel")
                indicator.Size = UDim2.new(0, 20, 1, 0)
                indicator.Position = UDim2.new(1, -25, 0, 0)
                indicator.BackgroundTransparency = 1
                indicator.Font = Enum.Font.GothamBlack
                indicator.Text = "▼"
                indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
                indicator.TextSize = 14
                indicator.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                indicator.TextStrokeTransparency = 0.3
                indicator.Parent = dropdown

                local box = Instance.new("Frame")
                box.Size = UDim2.new(1, 0, 0, 0)
                box.Position = UDim2.new(0, 0, 1, 5)
                box.BackgroundColor3 = Color3.fromRGB(40, 15, 80)
                box.BackgroundTransparency = 0
                box.BorderSizePixel = 0
                box.ClipsDescendants = true
                box.ZIndex = 50
                box.Parent = dropdown

                local boxGradient = Instance.new("UIGradient")
                boxGradient.Rotation = 90
                boxGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 15, 80)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(80, 40, 150))
                }
                boxGradient.Parent = box

                local objects = Instance.new("ScrollingFrame")
                objects.Name = "Objects"
                objects.Size = UDim2.new(1, 0, 1, 0)
                objects.BackgroundTransparency = 1
                objects.BorderSizePixel = 0
                objects.CanvasSize = UDim2.new(0, 0, 0, 0)
                objects.ScrollBarThickness = 4
                objects.ZIndex = 51
                objects.Parent = box

                local objectsLayout = Instance.new("UIListLayout")
                objectsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                objectsLayout.Parent = objects

                local open = false
                dropdown.MouseButton1Click:Connect(function()
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
                        indicator.Text = "▲"
                    else
                        dropdown_open = false
                        Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                        indicator.Text = "▼"
                    end
                end)

                function dropdown_data:Add(n)
                    local object_data = {}
                    n = tostring(n or "New Object")

                    local object = Instance.new("TextButton")
                    object.Size = UDim2.new(1, 0, 0, 35)
                    object.BackgroundColor3 = Color3.fromRGB(60, 30, 110)
                    object.BackgroundTransparency = 0
                    object.BorderSizePixel = 0
                    object.Font = Enum.Font.GothamBlack
                    object.Text = n
                    object.TextColor3 = Color3.fromRGB(255, 255, 255)
                    object.TextSize = 14
                    object.TextXAlignment = Enum.TextXAlignment.Left
                    object.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    object.TextStrokeTransparency = 0.3
                    object.ZIndex = 52
                    object.Parent = objects

                    -- No extra shadow labels, just use TextStroke

                    object.MouseEnter:Connect(function()
                        object.BackgroundColor3 = Color3.fromRGB(90, 50, 160)
                    end)
                    object.MouseLeave:Connect(function()
                        object.BackgroundColor3 = Color3.fromRGB(60, 30, 110)
                    end)

                    if open then
                        local len = (#objects:GetChildren() - 1) * 35
                        if #objects:GetChildren() - 1 >= 10 then
                            len = 10 * 35
                            objects.CanvasSize = UDim2.new(0, 0, 0, (#objects:GetChildren() - 1) * 35)
                        end
                        Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                    end

                    object.MouseButton1Click:Connect(function()
                        if dropdown_open then
                            dropdown.Text = " [ " .. n .. " ]"
                            dropdownTextShadow.Text = " [ " .. n .. " ]"
                            dropdown_open = false
                            open = false
                            Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                            indicator.Text = "▼"
                            pcall(callback, n)
                        end
                    end)

                    function object_data:Remove()
                        object:Destroy()
                    end
                    return object, object_data
                end
                return dropdown_data, dropdown
            end

            function tab_data:AddColorPicker(callback)
                local color_picker_data = {}
                callback = typeof(callback) == "function" and callback or function() end

                local color_picker = Instance.new("Frame")
                color_picker.Size = UDim2.new(1, 0, 0, 110)
                color_picker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                color_picker.BackgroundTransparency = 0.8
                color_picker.BorderSizePixel = 0
                color_picker.Parent = tabContainer
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

                do
                    local h, s, v = 0, 1, 1
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

                    local paletteDragging, saturationDragging = false, false
                    local paletteConn, saturationConn

                    local function updatePalette()
                        local mouse_location = gMouse()
                        local x = ((palette.AbsoluteSize.X - (mouse_location.X - palette.AbsolutePosition.X)) + 1)
                        local y = ((palette.AbsoluteSize.Y - (mouse_location.Y - palette.AbsolutePosition.Y)) + 1.5)
                        h = x / 100
                        s = y / 100
                        Resize(palette_indicator, {Position = UDim2.new(0, math.abs(x - 100) - (palette_indicator.AbsoluteSize.X / 2), 0, math.abs(y - 100) - (palette_indicator.AbsoluteSize.Y / 2))}, options.tween_time)
                        update()
                    end

                    local function updateSaturation()
                        local mouse_location = gMouse()
                        local y = ((palette.AbsoluteSize.Y - (mouse_location.Y - palette.AbsolutePosition.Y)) + 1.5)
                        v = y / 100
                        Resize(saturation_indicator, {Position = UDim2.new(0, 0, 0, math.abs(y - 100))}, options.tween_time)
                        update()
                    end

                    palette.InputBegan:Connect(function(inputObject)
                        if dropdown_open then return end
                        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
                            paletteDragging = true
                            updatePalette()
                            if paletteConn then paletteConn:Disconnect() end
                            paletteConn = RS.Heartbeat:Connect(function()
                                if paletteDragging and not dropdown_open then
                                    updatePalette()
                                end
                            end)
                        end
                    end)

                    saturation.InputBegan:Connect(function(inputObject)
                        if dropdown_open then return end
                        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
                            saturationDragging = true
                            updateSaturation()
                            if saturationConn then saturationConn:Disconnect() end
                            saturationConn = RS.Heartbeat:Connect(function()
                                if saturationDragging and not dropdown_open then
                                    updateSaturation()
                                end
                            end)
                        end
                    end)

                    UIS.InputEnded:Connect(function(inputObject)
                        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
                            paletteDragging = false
                            saturationDragging = false
                            if paletteConn then paletteConn:Disconnect(); paletteConn = nil end
                            if saturationConn then saturationConn:Disconnect(); saturationConn = nil end
                        end
                    end)

                    function color_picker_data:Set(color)
                        color = typeof(color) == "Color3" and color or Color3.new(1, 1, 1)
                        local h2, s2, v2 = rgbtohsv(color.r * 255, color.g * 255, color.b * 255)
                        h, s, v = h2, s2, v2
                        sample.ImageColor3 = color
                        saturation.ImageColor3 = Color3.fromHSV(h2, 1, 1)
                        pcall(callback, color)
                    end
                end
                return color_picker_data, color_picker
            end

            function tab_data:AddConsole(console_options)
                local console_data = {}
                console_options = typeof(console_options) == "table" and console_options or {["readonly"] = true, ["full"] = false}
                console_options = {
                    ["y"] = tonumber(console_options.y) or 200,
                    ["source"] = console_options.source or "Logs",
                    ["readonly"] = ((console_options.readonly) == true),
                    ["full"] = ((console_options.full) == true),
                }

                local console = Instance.new("Frame")
                console.Size = UDim2.new(1, 0, console_options.full and 1 or 0, console_options.y)
                console.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                console.BackgroundTransparency = 0.8
                console.BorderSizePixel = 0
                console.Parent = tabContainer
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
                Source.TextColor3 = Color3.new(1, 1, 1)
                Source.TextSize = 15
                Source.TextXAlignment = Enum.TextXAlignment.Left
                Source.TextYAlignment = Enum.TextYAlignment.Top
                Source.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                Source.TextStrokeTransparency = 0.3
                Source.Parent = sf

                local Lines = Instance.new("TextLabel")
                Lines.Name = "Lines"
                Lines.Size = UDim2.new(0, 40, 1, 0)
                Lines.BackgroundTransparency = 1
                Lines.BorderSizePixel = 0
                Lines.Font = Enum.Font.Code
                Lines.Text = "1\n"
                Lines.TextColor3 = Color3.new(1, 1, 1)
                Lines.TextSize = 15
                Lines.TextYAlignment = Enum.TextYAlignment.Top
                Lines.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                Lines.TextStrokeTransparency = 0.3
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
                return console_data, console
            end

            function tab_data:AddHorizontalAlignment()
                local ha_data = {}
                local ha = Instance.new("Frame")
                ha.Size = UDim2.new(1, 0, 0, 20)
                ha.BackgroundTransparency = 1
                ha.BorderSizePixel = 0
                ha.Parent = tabContainer

                local haLayout = Instance.new("UIListLayout")
                haLayout.FillDirection = Enum.FillDirection.Horizontal
                haLayout.SortOrder = Enum.SortOrder.LayoutOrder
                haLayout.Padding = UDim.new(0, 5)
                haLayout.Parent = ha

                function ha_data:AddButton(...)
                    local data, object
                    local ret = {tab_data:AddButton(...)}
                    if typeof(ret[1]) == "table" then
                        data = ret[1]
                        object = ret[2]
                        object.Parent = ha
                        return data, object
                    else
                        object = ret[1]
                        object.Parent = ha
                        return object
                    end
                end
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
                folder.Parent = tabContainer
                Instance.new("UICorner", folder).CornerRadius = UDim.new(0, 10)

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 35)
                button.BackgroundTransparency = 1
                button.BorderSizePixel = 0
                button.Font = Enum.Font.GothamBlack
                button.Text = "▼ " .. folder_name
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 14
                button.TextXAlignment = Enum.TextXAlignment.Left
                button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                button.TextStrokeTransparency = 0.3
                button.Parent = folder

                local offX, offY = 2, 2
                local folderTextShadow = Instance.new("TextLabel")
                folderTextShadow.Size = UDim2.new(1, 0, 1, 0)
                folderTextShadow.Position = UDim2.new(0, offX, 0, offY)
                folderTextShadow.BackgroundTransparency = 1
                folderTextShadow.Font = Enum.Font.GothamBlack
                folderTextShadow.Text = "▼ " .. folder_name
                folderTextShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                folderTextShadow.TextSize = 14
                folderTextShadow.TextXAlignment = Enum.TextXAlignment.Left
                folderTextShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                folderTextShadow.TextStrokeTransparency = 0.5
                folderTextShadow.Parent = button
                folderTextShadow.ZIndex = 0

                button.ZIndex = 1

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
                    for i, v in pairs(objects:GetChildren()) do
                        if not (v:IsA("UIListLayout")) then
                            n = n + v.AbsoluteSize.Y + 5
                        end
                    end
                    return n
                end

                local open = false
                button.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        button.Text = "▲ " .. folder_name
                        folderTextShadow.Text = "▲ " .. folder_name
                        objects.Visible = true
                    else
                        button.Text = "▼ " .. folder_name
                        folderTextShadow.Text = "▼ " .. folder_name
                        objects.Visible = false
                    end
                    Resize(folder, {Size = UDim2.new(1, 0, 0, (open and gFolderLen() or 35))}, options.tween_time)
                end)

                for i, v in pairs(tab_data) do
                    folder_data[i] = function(...)
                        local data, object
                        local ret = {v(...)}
                        if typeof(ret[1]) == "table" then
                            data = ret[1]
                            object = ret[2]
                            object.Parent = objects
                            return data, object
                        else
                            object = ret[1]
                            object.Parent = objects
                            return object
                        end
                    end
                end
                return folder_data, folder
            end

            return tab_data, tabContainer
        end
    end
    return window_data, Window
end

return library
