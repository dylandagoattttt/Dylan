local ui_options = {
    main_color = Color3.fromRGB(150, 80, 255),
    min_size = Vector2.new(400, 300),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true,
}

-- ============================================================
-- ALL ASSETS (native decal format)
-- ============================================================
local ASSETS = {
    BackgroundTexture = "rbxassetid://16736132788",
    RippleCircle      = "rbxassetid://266543268",
    CloseButton       = "rbxassetid://114840795551292",
    MinimizedIcon     = "rbxassetid://108067574147759",
    Banner            = "rbxassetid://119214568385242",  -- replace with your actual decal ID
    ColorPickerPalette    = "rbxassetid://698052001",
    ColorPickerIndicator  = "rbxassetid://2851926732",
    ColorPickerSample     = "rbxassetid://2851929490",
    ColorPickerSaturation = "rbxassetid://3641079629",
}
-- ============================================================

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
circle.Image = ASSETS.RippleCircle
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

local function Lighten(color, amt)
    return color:Lerp(Color3.new(1, 1, 1), amt)
end
local function Darken(color, amt)
    return color:Lerp(Color3.new(0, 0, 0), amt)
end

local activeToasts = 0
function library:Notify(title, message, duration)
    title = tostring(title or "Notice")
    message = tostring(message or "")
    duration = tonumber(duration) or 3

    local slot = activeToasts
    activeToasts = activeToasts + 1

    local toastShadow = Instance.new("Frame")
    toastShadow.AnchorPoint = Vector2.new(1, 0)
    toastShadow.Position = UDim2.new(1, 24, 0, 20 + slot * 78 + 4)
    toastShadow.Size = UDim2.new(0, 260, 0, 68)
    toastShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toastShadow.BackgroundTransparency = 0.5
    toastShadow.BorderSizePixel = 0
    toastShadow.ZIndex = 199
    toastShadow.Parent = imgui
    Instance.new("UICorner", toastShadow).CornerRadius = UDim.new(0, 12)

    local toast = Instance.new("Frame")
    toast.AnchorPoint = Vector2.new(1, 0)
    toast.Position = UDim2.new(1, 20, 0, 20 + slot * 78)
    toast.Size = UDim2.new(0, 260, 0, 68)
    toast.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
    toast.BorderSizePixel = 0
    toast.ZIndex = 200
    toast.ClipsDescendants = true
    toast.Parent = imgui
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 12)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 5, 1, 0)
    accentBar.BackgroundColor3 = ui_options.main_color or Color3.fromRGB(150, 80, 255)
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 201
    accentBar.Parent = toast
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 12)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -24, 0, 24)
    titleLabel.Position = UDim2.new(0, 16, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextStrokeTransparency = 0.3
    titleLabel.ZIndex = 201
    titleLabel.Parent = toast

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -24, 0, 28)
    messageLabel.Position = UDim2.new(0, 16, 0, 32)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(220, 210, 235)
    messageLabel.TextSize = 13
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.ZIndex = 201
    messageLabel.Parent = toast

    local tweenIn = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(toast, tweenIn, {Position = UDim2.new(1, -20, 0, 20 + slot * 78)}):Play()
    TweenService:Create(toastShadow, tweenIn, {Position = UDim2.new(1, -16, 0, 20 + slot * 78 + 4)}):Play()

    task.delay(duration, function()
        local tweenOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(toast, tweenOut, {Position = UDim2.new(1, 20, 0, toast.Position.Y.Offset)}):Play()
        TweenService:Create(toastShadow, tweenOut, {Position = UDim2.new(1, 24, 0, toastShadow.Position.Y.Offset)}):Play()
        task.wait(0.3)
        toast:Destroy()
        toastShadow:Destroy()
        activeToasts = math.max(0, activeToasts - 1)
    end)
end

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

local function CreatePanel(name, anchorPos, size, cornerRadius, zIndex, parent, accentColor)
    accentColor = accentColor or ui_options.main_color or Color3.fromRGB(150, 80, 255)
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
        ColorSequenceKeypoint.new(0.00, accentColor),
        ColorSequenceKeypoint.new(0.45, Lighten(accentColor, 0.2)),
        ColorSequenceKeypoint.new(1.00, Lighten(accentColor, 0.55))
    }
    gradient.Parent = panel.Frame

    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.fromScale(1, 1)
    bgImage.BackgroundTransparency = 1
    bgImage.BorderSizePixel = 0
    bgImage.Image = ASSETS.BackgroundTexture
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

    local MainWidth = 0.75
    local MainHeight = 0.95
    local SidebarWidth = 0.24

    local MainSize = UDim2.fromScale(MainWidth, MainHeight)
    local MainPos = UDim2.fromScale(0.5, 0.5)
    local MainPanel = CreatePanel("Main_" .. windows, MainPos, MainSize, 20, 1, windowsFrame, options.main_color)

    -- =====================================================
    -- CLOSE BUTTON (top-right)
    -- =====================================================
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseButton.Position = UDim2.new(1, 0, 0, 0)
    CloseButton.Size = UDim2.fromOffset(56, 56)
    CloseButton.BackgroundTransparency = 1
    CloseButton.BorderSizePixel = 0
    CloseButton.Image = ASSETS.CloseButton
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

    -- =====================================================
    -- BANNER (full‑width strip at the top)
    -- =====================================================
    local Banner = Instance.new("ImageLabel")
    Banner.Name = "Banner"
    Banner.Position = UDim2.fromScale(0, 0)
    Banner.Size = UDim2.new(1, 0, 0, 90)
    Banner.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
    Banner.BackgroundTransparency = 0
    Banner.BorderSizePixel = 0
    Banner.Image = tostring(options.banner_image or ASSETS.Banner)
    Banner.ScaleType = Enum.ScaleType.Crop
    Banner.ZIndex = 2   -- above the BackgroundImage (texture)
    Banner.Parent = MainPanel.Frame
    Instance.new("UICorner", Banner).CornerRadius = UDim.new(0, 20)

    -- Mask the bottom corners of the banner
    local BannerMask = Instance.new("Frame")
    BannerMask.Name = "BannerMask"
    BannerMask.AnchorPoint = Vector2.new(0, 1)
    BannerMask.Position = UDim2.new(0, 0, 1, 0)
    BannerMask.Size = UDim2.new(1, 0, 0, 20)
    BannerMask.BackgroundColor3 = Banner.BackgroundColor3
    BannerMask.BorderSizePixel = 0
    BannerMask.ZIndex = 1
    BannerMask.Parent = Banner

    local BannerGradient = Instance.new("UIGradient")
    BannerGradient.Rotation = 90
    BannerGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 0.15),
    }
    BannerGradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
    BannerGradient.Parent = Banner

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Position = UDim2.new(0, 0, 0, Banner.Size.Y.Offset)
    Sidebar.Size = UDim2.new(SidebarWidth, 0, 1, -Banner.Size.Y.Offset)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainPanel.Frame

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Name = "Divider"
    SidebarDivider.AnchorPoint = Vector2.new(1, 0)
    SidebarDivider.Position = UDim2.new(1, 0, 0, 0)
    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SidebarDivider.BackgroundTransparency = 0.85
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = Sidebar

    -- PROFILE SECTION
    local Profile = Instance.new("Frame")
    Profile.Name = "Profile"
    Profile.Position = UDim2.new(0, 10, 0, 12)
    Profile.Size = UDim2.new(1, -20, 0, 60)
    Profile.BackgroundTransparency = 1
    Profile.BorderSizePixel = 0
    Profile.Parent = Sidebar

    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.Size = UDim2.fromOffset(48, 48)
    Avatar.Position = UDim2.new(0, 0, 0.5, 0)
    Avatar.AnchorPoint = Vector2.new(0, 0.5)
    Avatar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Avatar.BackgroundTransparency = 0.85
    Avatar.BorderSizePixel = 0
    Avatar.ScaleType = Enum.ScaleType.Crop
    Avatar.Parent = Profile
    Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = Color3.fromRGB(255, 255, 255)
    AvatarStroke.Thickness = 1.5
    AvatarStroke.Transparency = 0.4
    AvatarStroke.Parent = Avatar

    task.spawn(function()
        local ok, content = pcall(function()
            return ps:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and content then
            Avatar.Image = content
        end
    end)

    local Username = Instance.new("TextLabel")
    Username.Name = "Username"
    Username.Position = UDim2.new(0, 58, 0.5, -18)
    Username.Size = UDim2.new(1, -58, 0, 18)
    Username.BackgroundTransparency = 1
    Username.Font = Enum.Font.GothamBlack
    Username.Text = p.DisplayName or p.Name
    Username.TextColor3 = Color3.fromRGB(255, 255, 255)
    Username.TextSize = 14
    Username.TextXAlignment = Enum.TextXAlignment.Left
    Username.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Username.TextStrokeTransparency = 0.4
    Username.TextTruncate = Enum.TextTruncate.AtEnd
    Username.Parent = Profile

    local Handle = Instance.new("TextLabel")
    Handle.Name = "Handle"
    Handle.Position = UDim2.new(0, 58, 0.5, 2)
    Handle.Size = UDim2.new(1, -58, 0, 16)
    Handle.BackgroundTransparency = 1
    Handle.Font = Enum.Font.Gotham
    Handle.Text = "@" .. p.Name
    Handle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Handle.TextTransparency = 0.35
    Handle.TextSize = 12
    Handle.TextXAlignment = Enum.TextXAlignment.Left
    Handle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Handle.TextStrokeTransparency = 0.5
    Handle.TextTruncate = Enum.TextTruncate.AtEnd
    Handle.Parent = Profile

    local ProfileDivider = Instance.new("Frame")
    ProfileDivider.Name = "ProfileDivider"
    ProfileDivider.Position = UDim2.new(0, 10, 0, Profile.Position.Y.Offset + Profile.Size.Y.Offset + 8)
    ProfileDivider.Size = UDim2.new(1, -20, 0, 1)
    ProfileDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProfileDivider.BackgroundTransparency = 0.85
    ProfileDivider.BorderSizePixel = 0
    ProfileDivider.Parent = Sidebar

    -- MINIMIZED STATE
    local MinimizedFrame = Instance.new("ImageButton")
    MinimizedFrame.Name = "MinimizedFrame_" .. windows
    MinimizedFrame.AnchorPoint = Vector2.new(1, 0)
    MinimizedFrame.Position = UDim2.new(1, -50, 0, 20)
    MinimizedFrame.Size = UDim2.fromOffset(60, 60)
    MinimizedFrame.BackgroundTransparency = 1
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Visible = false
    MinimizedFrame.ZIndex = 100
    MinimizedFrame.Image = ASSETS.MinimizedIcon
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

            task.wait(0.3)
            MainPanel.Frame.Visible = false
            MainPanel.Shadow.Visible = false

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

        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(MainPanel.Frame, tweenInfo, {Size = MainSize, Position = MainPos}):Play()
        TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = MainSize, Position = MainPos + UDim2.new(0, 0, 0, 8)}):Play()
        isMinimized = false
    end)

    local window_data = {}
    local Window = MainPanel.Frame
    local Tabs = Instance.new("Frame")
    Tabs.Name = "Tabs"
    Tabs.Size = UDim2.new(1 - SidebarWidth, -20, 1, -Banner.Size.Y.Offset - 20)
    Tabs.Position = UDim2.new(SidebarWidth, 10, 0, Banner.Size.Y.Offset + 10)
    Tabs.BackgroundTransparency = 1
    Tabs.BorderSizePixel = 0
    Tabs.Parent = MainPanel.Frame

    local TabButtonsTop = ProfileDivider.Position.Y.Offset + 10

    local TabButtonsShadow = Instance.new("Frame")
    TabButtonsShadow.Name = "TabButtonsShadow"
    TabButtonsShadow.Size = UDim2.new(1, -20, 1, -(TabButtonsTop + 10))
    TabButtonsShadow.Position = UDim2.new(0, 10, 0, TabButtonsTop)
    TabButtonsShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonsShadow.BackgroundTransparency = 0.5
    TabButtonsShadow.BorderSizePixel = 0
    TabButtonsShadow.ZIndex = 0
    TabButtonsShadow.Parent = Sidebar
    Instance.new("UICorner", TabButtonsShadow).CornerRadius = UDim.new(0, 10)

    local TabButtons = Instance.new("ScrollingFrame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, -20, 1, -(TabButtonsTop + 10))
    TabButtons.Position = UDim2.new(0, 10, 0, TabButtonsTop)
    TabButtons.BackgroundTransparency = 1
    TabButtons.BorderSizePixel = 0
    TabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtons.ScrollBarThickness = 4
    TabButtons.ZIndex = 1
    TabButtons.Parent = Sidebar

    local TabButtonsList = Instance.new("UIListLayout")
    TabButtonsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsList.Padding = UDim.new(0, 5)
    TabButtonsList.Parent = TabButtons

    do -- Add Tab
        function window_data:AddTab(tab_name)
            local tab_data = {}
            tab_name = tostring(tab_name or "New Tab")

            local new_button = Instance.new("ImageButton")
            new_button.Name = "TabButton_" .. tab_name
            new_button.Size = UDim2.new(1, 0, 0, 35)
            new_button.BackgroundTransparency = 1
            new_button.BorderSizePixel = 0
            new_button.Image = ASSETS.BackgroundTexture
            new_button.ImageTransparency = 0.3
            new_button.ScaleType = Enum.ScaleType.Stretch
            new_button.Parent = TabButtons
            Instance.new("UICorner", new_button).CornerRadius = UDim.new(0, 10)

            local buttonContainer = Instance.new("Frame")
            buttonContainer.Name = "LabelContainer"
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

            TabButtons.CanvasSize = UDim2.new(0, 0, 0, (#TabButtons:GetChildren() - 1) * 40)

            local tabContainer = Instance.new("ScrollingFrame")
            tabContainer.Name = "TabContainer_" .. tab_name
            tabContainer.Size = UDim2.new(1, 0, 1, 0)
            tabContainer.BackgroundTransparency = 1
            tabContainer.BorderSizePixel = 0
            tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            tabContainer.ScrollBarThickness = 4
            tabContainer.ClipsDescendants = true
            tabContainer.Visible = false
            tabContainer.Parent = Tabs

            local tabContainerPadding = Instance.new("UIPadding")
            tabContainerPadding.PaddingRight = UDim.new(0, 8)
            tabContainerPadding.Parent = tabContainer

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

            local GOLD = Color3.fromRGB(255, 200, 60)

            local goldTint = Instance.new("Frame")
            goldTint.Name = "GoldTint"
            goldTint.Size = UDim2.new(1, 0, 1, 0)
            goldTint.BackgroundColor3 = GOLD
            goldTint.BackgroundTransparency = 1
            goldTint.BorderSizePixel = 0
            goldTint.ZIndex = 0
            goldTint.Parent = new_button
            Instance.new("UICorner", goldTint).CornerRadius = UDim.new(0, 10)

            local function show()
                if dropdown_open then return end
                for i, v in pairs(TabButtons:GetChildren()) do
                    if v:IsA("ImageButton") then
                        v.ImageTransparency = 0.3
                        local tint = v:FindFirstChild("GoldTint")
                        if tint then tint.BackgroundTransparency = 1 end
                        local container = v:FindFirstChild("LabelContainer")
                        if container then
                            local lbl = container:FindFirstChild("ButtonLabel")
                            if lbl then lbl.TextColor3 = Color3.fromRGB(255, 255, 255) end
                        end
                    end
                end
                for i, v in pairs(Tabs:GetChildren()) do
                    if v:IsA("ScrollingFrame") and v ~= tabContainer then
                        v.Visible = false
                    end
                end
                new_button.ImageTransparency = 0
                TweenService:Create(goldTint, TweenInfo.new(0.15), {BackgroundTransparency = 0.82}):Play()
                buttonLabel.TextColor3 = GOLD
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

            function tab_data:AddDescription(desc_text)
                desc_text = tostring(desc_text or "")
                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, 0, 0, 16)
                desc.BackgroundTransparency = 1
                desc.Font = Enum.Font.Gotham
                desc.Text = desc_text
                desc.TextColor3 = Color3.fromRGB(210, 200, 225)
                desc.TextSize = 12
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                desc.TextStrokeTransparency = 0.6
                desc.TextWrapped = true
                desc.Parent = tabContainer
                return desc
            end

            function tab_data:AddDivider()
                local base = options.main_color or Color3.fromRGB(150, 80, 255)
                local dividerFrame = Instance.new("Frame")
                dividerFrame.Size = UDim2.new(1, 0, 0, 12)
                dividerFrame.BackgroundTransparency = 1
                dividerFrame.Parent = tabContainer

                local line = Instance.new("Frame")
                line.Size = UDim2.new(1, 0, 0, 1)
                line.Position = UDim2.new(0, 0, 0.5, 0)
                line.BackgroundColor3 = Lighten(base, 0.3)
                line.BackgroundTransparency = 0.3
                line.BorderSizePixel = 0
                line.Parent = dividerFrame

                local grad = Instance.new("UIGradient")
                grad.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }
                grad.Parent = line

                return dividerFrame
            end

            function tab_data:AddButton(button_text, callback)
                button_text = tostring(button_text or "New Button")
                callback = typeof(callback) == "function" and callback or function() end

                local base = options.main_color or Color3.fromRGB(150, 80, 255)

                local buttonFrame = Instance.new("Frame")
                buttonFrame.Size = UDim2.new(1, 0, 0, 38)
                buttonFrame.BackgroundTransparency = 1
                buttonFrame.BorderSizePixel = 0
                buttonFrame.Parent = tabContainer

                local shadow = Instance.new("Frame")
                shadow.Size = UDim2.new(1, 0, 0, 35)
                shadow.Position = UDim2.new(0, 0, 0, 3)
                shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                shadow.BackgroundTransparency = 0.55
                shadow.BorderSizePixel = 0
                shadow.Parent = buttonFrame
                Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 12)

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 35)
                button.BackgroundColor3 = Lighten(base, 0.1)
                button.BackgroundTransparency = 0.45
                button.BorderSizePixel = 0
                button.AutoButtonColor = false
                button.Text = ""
                button.ClipsDescendants = true
                button.Parent = buttonFrame
                Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

                local sheen = Instance.new("Frame")
                sheen.Size = UDim2.new(1, 0, 0.55, 0)
                sheen.Position = UDim2.new(0, 0, 0, 0)
                sheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sheen.BackgroundTransparency = 0.75
                sheen.BorderSizePixel = 0
                sheen.Parent = button
                local sheenCorner = Instance.new("UICorner", sheen)
                sheenCorner.CornerRadius = UDim.new(0, 12)
                local sheenGradient = Instance.new("UIGradient")
                sheenGradient.Rotation = 90
                sheenGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }
                sheenGradient.Parent = sheen

                local glowStroke = Instance.new("UIStroke")
                glowStroke.Color = Lighten(base, 0.55)
                glowStroke.Thickness = 1.25
                glowStroke.Transparency = 0.45
                glowStroke.Parent = button

                local textContainer = Instance.new("Frame")
                textContainer.Size = UDim2.new(1, -24, 1, 0)
                textContainer.Position = UDim2.new(0, 14, 0, 0)
                textContainer.BackgroundTransparency = 1
                textContainer.Parent = button

                local textShadow = Instance.new("TextLabel")
                textShadow.Size = UDim2.new(1, 0, 1, 0)
                textShadow.Position = UDim2.new(0, 2, 0, 2)
                textShadow.BackgroundTransparency = 1
                textShadow.Font = Enum.Font.GothamBlack
                textShadow.Text = button_text
                textShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                textShadow.TextSize = 14
                textShadow.TextXAlignment = Enum.TextXAlignment.Left
                textShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                textShadow.TextStrokeTransparency = 0.5
                textShadow.ZIndex = 0
                textShadow.Parent = textContainer

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Font = Enum.Font.GothamBlack
                textLabel.Text = button_text
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextSize = 14
                textLabel.TextXAlignment = Enum.TextXAlignment.Left
                textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                textLabel.TextStrokeTransparency = 0.3
                textLabel.ZIndex = 1
                textLabel.Parent = textContainer

                button.MouseEnter:Connect(function()
                    TweenService:Create(glowStroke, TweenInfo.new(0.15), {Transparency = 0.1, Thickness = 1.75}):Play()
                    TweenService:Create(button, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
                end)
                button.MouseLeave:Connect(function()
                    TweenService:Create(glowStroke, TweenInfo.new(0.15), {Transparency = 0.45, Thickness = 1.25}):Play()
                    TweenService:Create(button, TweenInfo.new(0.15), {BackgroundTransparency = 0.45}):Play()
                end)
                button.MouseButton1Down:Connect(function()
                    TweenService:Create(buttonFrame, TweenInfo.new(0.08), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                end)
                button.MouseButton1Up:Connect(function()
                    TweenService:Create(buttonFrame, TweenInfo.new(0.08), {Size = UDim2.new(1, 0, 0, 38)}):Play()
                end)

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
                toggleButton.AutoButtonColor = false
                toggleButton.Text = ""
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

                local toggleTextLabel = Instance.new("TextLabel")
                toggleTextLabel.Size = UDim2.new(1, 0, 1, 0)
                toggleTextLabel.BackgroundTransparency = 1
                toggleTextLabel.Font = Enum.Font.GothamBlack
                toggleTextLabel.Text = "OFF"
                toggleTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleTextLabel.TextSize = 12
                toggleTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                toggleTextLabel.TextStrokeTransparency = 0.3
                toggleTextLabel.ZIndex = 1
                toggleTextLabel.Parent = toggleButton

                local toggled = false

                local function updateToggle(state)
                    toggled = state
                    local targetColor = toggled and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
                    toggleTextLabel.Text = toggled and "ON" or "OFF"
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

                sliderBg.MouseEnter:Connect(function()
                    TweenService:Create(sliderBg, TweenInfo.new(0.15), {BackgroundTransparency = 0.65}):Play()
                end)
                sliderBg.MouseLeave:Connect(function()
                    TweenService:Create(sliderBg, TweenInfo.new(0.15), {BackgroundTransparency = 0.8}):Play()
                end)

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
                input.Text = ""
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

                local inputTextLabel = Instance.new("TextLabel")
                inputTextLabel.Size = UDim2.new(1, 0, 1, 0)
                inputTextLabel.BackgroundTransparency = 1
                inputTextLabel.Font = Enum.Font.GothamBlack
                inputTextLabel.Text = "RShift"
                inputTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                inputTextLabel.TextSize = 12
                inputTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                inputTextLabel.TextStrokeTransparency = 0.3
                inputTextLabel.ZIndex = 1
                inputTextLabel.Parent = input

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
                    inputTextLabel.Text = key
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
                    inputTextLabel.Text = "..."
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

                local base = options.main_color or Color3.fromRGB(150, 80, 255)

                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Size = UDim2.new(1, 0, 0, 38)
                dropdownFrame.BackgroundTransparency = 1
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.ClipsDescendants = false
                dropdownFrame.Parent = tabContainer

                local headerShadow = Instance.new("Frame")
                headerShadow.Size = UDim2.new(1, 0, 0, 35)
                headerShadow.Position = UDim2.new(0, 0, 0, 3)
                headerShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                headerShadow.BackgroundTransparency = 0.55
                headerShadow.BorderSizePixel = 0
                headerShadow.Parent = dropdownFrame
                Instance.new("UICorner", headerShadow).CornerRadius = UDim.new(0, 10)

                local dropdown = Instance.new("TextButton")
                dropdown.Size = UDim2.new(1, 0, 0, 35)
                dropdown.BackgroundColor3 = Lighten(base, 0.1)
                dropdown.BackgroundTransparency = 0.45
                dropdown.BorderSizePixel = 0
                dropdown.AutoButtonColor = false
                dropdown.Text = ""
                dropdown.ClipsDescendants = false
                dropdown.ZIndex = 10
                dropdown.Parent = dropdownFrame
                Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 10)

                local headerSheen = Instance.new("Frame")
                headerSheen.Size = UDim2.new(1, 0, 0.55, 0)
                headerSheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                headerSheen.BackgroundTransparency = 0.78
                headerSheen.BorderSizePixel = 0
                headerSheen.ZIndex = 10
                headerSheen.Parent = dropdown
                Instance.new("UICorner", headerSheen).CornerRadius = UDim.new(0, 10)
                local headerSheenGradient = Instance.new("UIGradient")
                headerSheenGradient.Rotation = 90
                headerSheenGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }
                headerSheenGradient.Parent = headerSheen

                local headerStroke = Instance.new("UIStroke")
                headerStroke.Color = Lighten(base, 0.55)
                headerStroke.Thickness = 1.25
                headerStroke.Transparency = 0.45
                headerStroke.Parent = dropdown

                local dropdownTextShadow = Instance.new("TextLabel")
                dropdownTextShadow.Size = UDim2.new(1, -35, 1, 0)
                dropdownTextShadow.Position = UDim2.new(0, 14, 0, 2)
                dropdownTextShadow.BackgroundTransparency = 1
                dropdownTextShadow.Font = Enum.Font.GothamBlack
                dropdownTextShadow.Text = dropdown_name
                dropdownTextShadow.TextColor3 = Color3.fromRGB(20, 20, 20)
                dropdownTextShadow.TextSize = 14
                dropdownTextShadow.TextXAlignment = Enum.TextXAlignment.Left
                dropdownTextShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                dropdownTextShadow.TextStrokeTransparency = 0.5
                dropdownTextShadow.Parent = dropdown
                dropdownTextShadow.ZIndex = 11

                local dropdownTextLabel = Instance.new("TextLabel")
                dropdownTextLabel.Size = UDim2.new(1, -35, 1, 0)
                dropdownTextLabel.Position = UDim2.new(0, 12, 0, 0)
                dropdownTextLabel.BackgroundTransparency = 1
                dropdownTextLabel.Font = Enum.Font.GothamBlack
                dropdownTextLabel.Text = dropdown_name
                dropdownTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdownTextLabel.TextSize = 14
                dropdownTextLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropdownTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                dropdownTextLabel.TextStrokeTransparency = 0.3
                dropdownTextLabel.ZIndex = 12
                dropdownTextLabel.Parent = dropdown

                local indicator = Instance.new("TextLabel")
                indicator.Size = UDim2.new(0, 24, 1, 0)
                indicator.Position = UDim2.new(1, -30, 0, 0)
                indicator.BackgroundTransparency = 1
                indicator.Font = Enum.Font.GothamBlack
                indicator.Text = "▼"
                indicator.TextColor3 = Lighten(base, 0.5)
                indicator.TextSize = 14
                indicator.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                indicator.TextStrokeTransparency = 0.3
                indicator.ZIndex = 12
                indicator.Parent = dropdown

                dropdown.MouseEnter:Connect(function()
                    TweenService:Create(headerStroke, TweenInfo.new(0.15), {Transparency = 0.1, Thickness = 1.75}):Play()
                    TweenService:Create(dropdown, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
                end)
                dropdown.MouseLeave:Connect(function()
                    TweenService:Create(headerStroke, TweenInfo.new(0.15), {Transparency = 0.45, Thickness = 1.25}):Play()
                    TweenService:Create(dropdown, TweenInfo.new(0.15), {BackgroundTransparency = 0.45}):Play()
                end)

                local box = Instance.new("Frame")
                box.Size = UDim2.new(1, 0, 0, 0)
                box.Position = UDim2.new(0, 0, 1, 8)
                box.BackgroundColor3 = Darken(base, 0.35)
                box.BackgroundTransparency = 0.25
                box.BorderSizePixel = 0
                box.ClipsDescendants = true
                box.ZIndex = 50
                box.Parent = dropdown
                Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)

                local boxStroke = Instance.new("UIStroke")
                boxStroke.Color = Lighten(base, 0.4)
                boxStroke.Thickness = 1.25
                boxStroke.Transparency = 0.35
                boxStroke.Parent = box

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
                local selectedObject = nil

                dropdown.MouseButton1Click:Connect(function()
                    open = not open
                    local len = (#objects:GetChildren() - 1) * 34
                    if #objects:GetChildren() - 1 >= 10 then
                        len = 10 * 34
                        objects.CanvasSize = UDim2.new(0, 0, 0, (#objects:GetChildren() - 1) * 34)
                    end
                    if open then
                        if dropdown_open then return end
                        dropdown_open = true
                        tabContainer.ClipsDescendants = false
                        Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                        TweenService:Create(indicator, TweenInfo.new(0.15), {Rotation = 180}):Play()
                    else
                        dropdown_open = false
                        Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                        TweenService:Create(indicator, TweenInfo.new(0.15), {Rotation = 0}):Play()
                        task.delay(options.tween_time, function()
                            tabContainer.ClipsDescendants = true
                        end)
                    end
                end)

                function dropdown_data:Add(n)
                    local object_data = {}
                    n = tostring(n or "New Object")

                    local object = Instance.new("TextButton")
                    object.Size = UDim2.new(1, 0, 0, 34)
                    object.BackgroundColor3 = Lighten(base, 0.05)
                    object.BackgroundTransparency = 0.75
                    object.BorderSizePixel = 0
                    object.AutoButtonColor = false
                    object.Text = ""
                    object.ZIndex = 52
                    object.Parent = objects

                    local selectBar = Instance.new("Frame")
                    selectBar.Size = UDim2.new(0, 3, 1, -8)
                    selectBar.Position = UDim2.new(0, 0, 0, 4)
                    selectBar.BackgroundColor3 = Lighten(base, 0.4)
                    selectBar.BackgroundTransparency = 1
                    selectBar.BorderSizePixel = 0
                    selectBar.ZIndex = 53
                    selectBar.Parent = object

                    local objectLabel = Instance.new("TextLabel")
                    objectLabel.Size = UDim2.new(1, -16, 1, 0)
                    objectLabel.Position = UDim2.new(0, 12, 0, 0)
                    objectLabel.BackgroundTransparency = 1
                    objectLabel.Font = Enum.Font.GothamSemibold
                    objectLabel.Text = n
                    objectLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    objectLabel.TextSize = 14
                    objectLabel.TextXAlignment = Enum.TextXAlignment.Left
                    objectLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    objectLabel.TextStrokeTransparency = 0.4
                    objectLabel.ZIndex = 53
                    objectLabel.Parent = object

                    object.MouseEnter:Connect(function()
                        if object ~= selectedObject then
                            TweenService:Create(object, TweenInfo.new(0.12), {BackgroundTransparency = 0.55}):Play()
                        end
                    end)
                    object.MouseLeave:Connect(function()
                        if object ~= selectedObject then
                            TweenService:Create(object, TweenInfo.new(0.12), {BackgroundTransparency = 0.75}):Play()
                        end
                    end)

                    if open then
                        local len = (#objects:GetChildren() - 1) * 34
                        if #objects:GetChildren() - 1 >= 10 then
                            len = 10 * 34
                            objects.CanvasSize = UDim2.new(0, 0, 0, (#objects:GetChildren() - 1) * 34)
                        end
                        Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                    end

                    object.MouseButton1Click:Connect(function()
                        if dropdown_open then
                            if selectedObject and selectedObject ~= object then
                                local prevBar = selectedObject:FindFirstChild("Frame")
                                TweenService:Create(selectedObject, TweenInfo.new(0.12), {BackgroundTransparency = 0.75}):Play()
                                if prevBar then TweenService:Create(prevBar, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play() end
                            end
                            selectedObject = object
                            TweenService:Create(object, TweenInfo.new(0.12), {BackgroundTransparency = 0.4}):Play()
                            TweenService:Create(selectBar, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()

                            dropdownTextLabel.Text = n
                            dropdownTextShadow.Text = n
                            dropdown_open = false
                            open = false
                            Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                            TweenService:Create(indicator, TweenInfo.new(0.15), {Rotation = 0}):Play()
                            task.delay(options.tween_time, function()
                                tabContainer.ClipsDescendants = true
                            end)
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
                palette.Image = ASSETS.ColorPickerPalette
                palette.ScaleType = Enum.ScaleType.Slice
                palette.SliceCenter = Rect.new(4, 4, 4, 4)
                palette.Parent = color_picker

                local palette_indicator = Instance.new("ImageLabel")
                palette_indicator.Name = "Indicator"
                palette_indicator.Size = UDim2.new(0, 5, 0, 5)
                palette_indicator.BackgroundColor3 = Color3.new(1, 1, 1)
                palette_indicator.BackgroundTransparency = 1
                palette_indicator.ZIndex = 2
                palette_indicator.Image = ASSETS.ColorPickerIndicator
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
                sample.Image = ASSETS.ColorPickerSample
                sample.ScaleType = Enum.ScaleType.Slice
                sample.SliceCenter = Rect.new(4, 4, 4, 4)
                sample.Parent = color_picker

                local saturation = Instance.new("ImageLabel")
                saturation.Name = "Saturation"
                saturation.Size = UDim2.new(0, 15, 0, 100)
                saturation.Position = UDim2.new(0.65, 0, 0.05, 0)
                saturation.BackgroundColor3 = Color3.new(1, 1, 1)
                saturation.Image = ASSETS.ColorPickerSaturation
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
                button.Text = ""
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

                local folderTextLabel = Instance.new("TextLabel")
                folderTextLabel.Size = UDim2.new(1, 0, 1, 0)
                folderTextLabel.BackgroundTransparency = 1
                folderTextLabel.Font = Enum.Font.GothamBlack
                folderTextLabel.Text = "▼ " .. folder_name
                folderTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                folderTextLabel.TextSize = 14
                folderTextLabel.TextXAlignment = Enum.TextXAlignment.Left
                folderTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                folderTextLabel.TextStrokeTransparency = 0.3
                folderTextLabel.ZIndex = 1
                folderTextLabel.Parent = button

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
                        folderTextLabel.Text = "▲ " .. folder_name
                        folderTextShadow.Text = "▲ " .. folder_name
                        objects.Visible = true
                    else
                        folderTextLabel.Text = "▼ " .. folder_name
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
